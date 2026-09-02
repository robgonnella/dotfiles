#!/usr/bin/env python3
"""Test harness for deny-commands.sh.

Feeds command strings to the hook as JSON on stdin and reports the hook's
verdict from its exit code. NOTHING IN THE CASES BELOW IS EXECUTED -- the
strings are only ever data passed to the hook.

Run:  python3 ~/.claude/hooks/test-deny-commands.py
Exit: 0 if every case matches its expectation, 1 otherwise.
"""

import json
import os
import subprocess
import sys

HOOK = os.path.join(os.path.dirname(os.path.abspath(__file__)), "deny-commands.sh")

# (command, expected_verdict)
CASES = [
    # --- must be DENIED ---------------------------------------------------
    ("aws s3 ls", "DENY"),                                   # plain
    ("AWS_PROFILE=x aws sts get-caller-identity", "DENY"),   # env prefix
    ("/opt/homebrew/bin/aws s3 ls", "DENY"),                 # absolute path
    ("echo hi && aws s3 ls", "DENY"),                        # compound &&
    ("echo hi; aws s3 ls", "DENY"),                          # compound ;
    ("env aws s3 ls", "DENY"),                               # env wrapper
    ("sh -c 'aws s3 ls'", "DENY"),                           # nested shell
    ("bash -c \"aws s3 ls\"", "DENY"),                       # nested shell, dquotes
    ("timeout 5 aws s3 ls", "DENY"),                         # wrapper + flag
    ("echo $(aws sts get-caller-identity)", "DENY"),         # command substitution
    ("ls | xargs kubectl delete pod", "DENY"),               # pipe + xargs
    ("kubectl get pods", "DENY"),
    ("helm upgrade foo .", "DENY"),
    ("helmfile apply", "DENY"),
    ("sudo rm -rf /tmp/x", "DENY"),
    ("git push origin main", "DENY"),
    ("git -C /tmp/repo push", "DENY"),                       # git global flag
    ("git --no-pager commit -m x", "DENY"),
    ("git checkout -b feature", "DENY"),
    ("git reset --hard origin/main", "DENY"),
    ("releasaurus --help", "DENY"),
    ("echo hi; releasaurus --help", "DENY"),
    ("cd /tmp && sudo su -", "DENY"),

    # --- must be ALLOWED --------------------------------------------------
    ("git status", "ALLOW"),
    ("git diff --stat", "ALLOW"),
    ("git log --oneline -5", "ALLOW"),
    ("ls -la", "ALLOW"),
    ("python -m pytest tests/ -v", "ALLOW"),
    ("black ocr_lambdas/", "ALLOW"),
    ("echo hello", "ALLOW"),
    ("cat template.yaml", "ALLOW"),
]


def verdict(command):
    payload = json.dumps({"tool_name": "Bash", "tool_input": {"command": command}})
    proc = subprocess.run(
        [sys.executable, HOOK],
        input=payload,
        capture_output=True,
        text=True,
    )
    return "ALLOW" if proc.returncode == 0 else "DENY"


def main():
    failures = 0
    for command, expected in CASES:
        got = verdict(command)
        ok = got == expected
        if not ok:
            failures += 1
        print("%-4s %-45s expected=%-5s got=%s"
              % ("ok" if ok else "FAIL", command, expected, got))

    print("\n%d/%d passed" % (len(CASES) - failures, len(CASES)))
    sys.exit(1 if failures else 0)


main()
