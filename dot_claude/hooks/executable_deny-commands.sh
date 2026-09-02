#!/usr/bin/env python3
"""Claude Code PreToolUse hook: block always-denied shell commands.

Mirrors the deny list from
    ~/.config/zed/settings.json
    -> agent.tool_permissions.tools.terminal.always_deny
onto Claude Code's Bash tool, which Zed's list does not govern (Zed's list
applies to Zed's own native-agent `terminal` tool, not to an ACP external
agent's `Bash` tool).

stdin  : PreToolUse JSON payload
exit 0 : allow
exit 2 : block; stderr is returned to the model

Design notes
------------
* Fails CLOSED. Unparseable input is blocked, not allowed.
* Matches on command *identity*, not string prefix: normalizes away env-var
  prefixes (`AWS_PROFILE=x aws ...`), absolute paths (`/opt/homebrew/bin/aws`),
  wrapper commands (`env`, `xargs`, `timeout`, ...), and compound-command
  operators (`;` `&&` `||` `|` `$(...)` backticks).
* Recurses into `sh -c '...'` payloads, depth-capped.
* Deliberately errs toward over-blocking. See DENY_ANYWHERE below.
"""

import json
import os
import re
import shlex
import sys

# Denied when they are the command being run.
DENY_COMMANDS = {"kubectl", "helmfile", "helm", "aws", "releasaurus", "sudo", "su"}

# Denied `git` subcommands. Matched anywhere in a `git` invocation so that
# `git -C /path push` and `git --no-pager push` are both caught.
DENY_GIT_SUBCOMMANDS = {
    "clean", "commit", "cherry-pick", "apply", "stash", "revert",
    "rebase", "merge", "push", "checkout", "reset", "restore", "switch",
}

# Denied wherever they appear, even as a bare argument. This is the
# belt-and-braces layer and it OVER-BLOCKS by design: `grep -r aws .` and
# `echo aws` are refused too. Trim this set (or set it to an empty set) if the
# false positives get annoying -- DENY_COMMANDS above still covers real
# invocations.
DENY_ANYWHERE = {"kubectl", "helmfile", "helm", "aws", "releasaurus", "sudo", "su"}

# Skipped over when looking for the real command.
WRAPPERS = {
    "env", "command", "builtin", "exec", "nohup", "time", "nice", "ionice",
    "stdbuf", "timeout", "watch", "xargs", "setsid", "script", "then", "do",
    "else", "elif",
}

SHELLS = {"sh", "bash", "zsh", "dash", "ksh", "fish"}

# Tokens that terminate one command and begin another.
OPERATORS = {";", "&&", "||", "|", "&", "|&", "(", ")", "\n", "{", "}"}

ASSIGNMENT = re.compile(r"^[A-Za-z_][A-Za-z0-9_]*=")

MAX_DEPTH = 5


def die(what):
    sys.stderr.write(
        "BLOCKED by deny-commands hook: '%s' is on the user's always-deny list.\n"
        "Do not retry with a different spelling, wrapper, absolute path, env-var "
        "prefix, subshell, or script that reaches the same command. A block is a "
        "final answer, not an obstacle to route around. Ask the user to run it "
        "themselves.\n" % what
    )
    sys.exit(2)


def norm(token):
    """Reduce a token to a bare command name."""
    t = token.strip()
    for _ in range(4):
        t = t.strip("`'\"")
        t = t.lstrip("$")
        t = t.lstrip("(")
        t = t.rstrip(")")
    if not t or t.startswith("-"):
        return ""
    return os.path.basename(t)


def tokenize(cmd):
    try:
        lexer = shlex.shlex(cmd, posix=True, punctuation_chars=True)
        lexer.whitespace_split = True
        # Do not treat '#' as a comment: we would rather over-block on a
        # commented-out command than lose text we should have inspected.
        lexer.commenters = ""
        return list(lexer)
    except ValueError:
        # Unbalanced quotes and friends. Fall back to a crude split rather
        # than letting the command through unexamined.
        crude = cmd
        for op in ("&&", "||", ";", "|", "&", "$(", ")", "`"):
            crude = crude.replace(op, " %s " % op)
        return crude.split()


def segments(tokens):
    seg = []
    for tok in tokens:
        if tok in OPERATORS:
            if seg:
                yield seg
            seg = []
        else:
            seg.append(tok)
    if seg:
        yield seg


def check(cmd, depth=0):
    if depth > MAX_DEPTH or not cmd.strip():
        return

    tokens = tokenize(cmd)

    for tok in tokens:
        bare = norm(tok)
        if bare in DENY_ANYWHERE:
            die(bare)

    for seg in segments(tokens):
        i = 0
        while i < len(seg):
            if ASSIGNMENT.match(seg[i]) or norm(seg[i]) in WRAPPERS:
                i += 1
                while i < len(seg) and seg[i].startswith("-"):
                    i += 1
                continue
            break
        if i >= len(seg):
            continue

        head = norm(seg[i])
        rest = seg[i + 1:]

        if head in DENY_COMMANDS:
            die(head)

        if head == "git":
            for tok in rest:
                bare = norm(tok)
                if bare in DENY_GIT_SUBCOMMANDS:
                    die("git %s" % bare)

        if head in SHELLS:
            for j, tok in enumerate(rest):
                if tok == "-c" and j + 1 < len(rest):
                    check(rest[j + 1], depth + 1)


def main():
    try:
        payload = json.loads(sys.stdin.read())
        command = payload.get("tool_input", {}).get("command", "")
    except Exception:
        sys.stderr.write(
            "BLOCKED by deny-commands hook: hook input could not be parsed. "
            "Failing closed.\n"
        )
        sys.exit(2)

    if not isinstance(command, str) or not command.strip():
        sys.exit(0)

    check(command)
    sys.exit(0)


main()
