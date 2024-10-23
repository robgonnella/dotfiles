# Dotfiles

Contains dotfile setup using [chezmoi] for repeatable
cross-platform consistency.

## Install

**Prerequisites**:

There are only two prerequisite to setting up a new environment with the configs
defined in this repo:

1. Install [chezmoi][chezmoi_install].

```bash
sh -c "$(curl -fsLS get.chezmoi.io)"
```

2. Install [git] - (This is most likely already installed on your system)

Once prerequisites are satisfied run the following:

```bash
chezmoi init https://github.com/robgonnella/dotfiles.git
```


[chezmoi]: https://www.chezmoi.io/
[chezmoi_install]: https://www.chezmoi.io/install/#one-line-package-install
[git]: https://git-scm.com/
