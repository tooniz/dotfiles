# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a personal dotfiles repository for macOS and Linux systems. It contains shell configurations, utility scripts, and an installation script that symlinks dotfiles to the home directory.

## Installation

```bash
./install.sh
```

The install script:
- Symlinks dotfiles (`.zshrc`, `.bashrc`, `.gitconfig`, `.tmux.conf`, etc.) from this repo to `$HOME`
- Sets up SSH keys and API secrets (encrypted with ansible-vault)
- Installs dependencies: oh-my-zsh, fzf, diff-so-fancy, fd, bat, tmux, zoxide, glow
- Installs zsh plugins: zsh-syntax-highlighting, zsh-autosuggestions
- Creates a Python virtual environment at `$HOME/dev` with packages from `requirements.txt`

## Structure

- **Shell configs**: `.zshrc` (primary), `.bashrc`, `.profile` - sources `.utilrc` for shared aliases
- **`.utilrc`**: Shared aliases and functions used by both bash and zsh
- **`.workrc`**: Project-specific environment variables and debug toggles (`dbgon`/`dbgoff`)
- **`.gitconfig`**: Git aliases and settings (rerere, autoSetupRemote enabled)
- **`.tmux.conf`**: Minimal tmux config (mouse, vim splits, no escape delay)
- **`.colorsrc`**: LS_COLORS configuration
- **`bin/`**: Utility scripts added to PATH
  - `fpmath.py`: Floating-point number analyzer for hardware development
  - `ondir`/`ondir_osx`: Directory-change triggers

## Key Aliases

| Alias | Description |
|-------|-------------|
| `c` | `cd ..` |
| `x` | `exit` |
| `t <name>` | `tmux attach -d -t <name>` |
| `dev` | Activate `$HOME/dev` Python virtualenv |
| `cat` | Smart cat: uses `glow` for `.md` files, `bat` otherwise |
| `gs` | `git status` |
| `gl` | `git lg` (pretty log) |
| `grbom` | Fetch origin, rebase on main, sync submodules |
| `dotfiles` | Pull latest dotfiles from remote |
| `dsf` | Diff with diff-so-fancy formatting |
| `z <path>` | zoxide smart directory jump |

## Git Config

Key settings in `.gitconfig`:
- `rerere.enabled = true`: Remembers conflict resolutions
- `push.autoSetupRemote = true`: No need for `--set-upstream`
- `pull.rebase = true`: Rebase on pull by default
- Aliases: `lg`, `lga`, `pb`, `cm`, `co`, `cob`, `sync`, `su`

## Tmux

Minimal config in `.tmux.conf`:
- Mouse support enabled
- Windows start at 1
- No escape delay (for vim)
- Split with `|` and `-` (preserves current directory)
- Vi copy mode

## Secrets

Encrypted files (`.secrets`, `.ssh/id_ed25519`) are decrypted during install using `ansible-vault`. The `.secrets` file should contain API keys like `GROQ_API_KEY`.
