# AGENTS.md

This file provides guidance to coding agents working in this repository.

## Repository Overview

This is a personal dotfiles repository for macOS and Linux systems. It contains shell configuration, utility scripts, and an install script that links managed files into `$HOME`.

## Installation

```bash
./install.sh
```

The install script:
- Creates `$HOME/.local/bin` if needed
- Symlinks managed dotfiles (`.zshrc`, `.bashrc`, `.gitconfig`, `.tmux.conf`, `.workrc`, `.emacs`, `bin`, etc.) into `$HOME`
- Copies `.ondirrc` to `$HOME` and expands `~/` paths to absolute home paths during install
- Sets up SSH keys and `.secrets` (decrypting with `ansible-vault` when first copied)
- Installs and/or bootstraps tools: `tmux`, `uv`, oh-my-zsh, `fzf`, diff-so-fancy, `fd`, `bat`, `zoxide`, and `glow` (`clang-format` on Linux)
- Installs zsh plugins: `zsh-syntax-highlighting`, `zsh-autosuggestions`
- Creates a Python virtual environment at `$HOME/dev` and installs `requirements.txt`
- Optionally symlinks large paths from `$HOME/shared` (`.cache`, `.vscode-server`, `testify`)

## Structure

- **Shell configs**: `.zshrc` (primary), `.bashrc`, `.profile`
- **`.utilrc`**: Shared aliases/functions sourced by both bash and zsh
- **`.workrc`**: Local debug toggles (`dbgon` / `dbgoff`) and env vars
- **`.ondirrc`**: Directory enter/leave hooks for project auto-setup
- **`.gitconfig`**: Git aliases and defaults (`rerere`, rebase pulls, auto remote setup)
- **`.tmux.conf`**: Minimal tmux config (mouse, pane split cwd preservation, fast escape, large history)
- **`.colorsrc`**: Shell color environment configuration
- **`bin/`**:
  - `ondir_enter`: project-enter hook script (sets `ROOT`, virtualenv, status output)
  - `fpmath.py`: floating-point bit/format analysis utility

## Key Shell Shortcuts

| Name | Description |
|------|-------------|
| `c` | `cd ..` |
| `a` | Activate local `.venv` (`.venv/bin/activate`) |
| `x` | `exit` |
| `t <name>` | `tmux attach -d -t <name>` |
| `ts [root]` | Fuzzy-select project and create/attach tmux session |
| `dev` | Activate `$HOME/dev` virtualenv |
| `e <path>` | Open path in `code` (fallback to editor) |
| `ee` | Open current git repo root in editor |
| `ff` | Fuzzy-pick file and open |
| `gb` | Fuzzy-pick git branch and switch |
| `cat()` | Smart cat: `glow` for `.md`, `bat` otherwise |
| `gs` | `git status` |
| `gl` | `git lg` |
| `grbom` | Fetch/rebase on origin main branch + sync submodules |
| `dotfiles` | Rebase local dotfiles branch onto latest `origin/<main>` with autostash |
| `dsf` | `diff` piped through diff-so-fancy |

`zoxide` is initialized in `.zshrc`, so `z <path>` is available when installed.
`ls` aliases in `.utilrc` currently use GNU-style color flags.

## Git Config Highlights

Key settings in `.gitconfig`:
- `rerere.enabled = true`
- `push.autoSetupRemote = true`
- `pull.rebase = true`
- Aliases include: `lg`, `lga`, `pb`, `cm`, `co`, `cob`, `root`, `sync`, `su`, `patch`

## Tmux

Current `.tmux.conf` behavior:
- Mouse support enabled
- Windows start at index `1`
- Escape delay disabled (`escape-time 0`)
- Scrollback history set to `50000`
- Splits (`|` and `-`) inherit current pane directory

## Secrets

Sensitive files in this repo (for bootstrap only) include `.secrets` and `.ssh/id_ed25519`. They are intended to be decrypted during setup via `ansible-vault` and linked/copied into `$HOME` as needed.
