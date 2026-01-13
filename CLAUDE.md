# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a personal dotfiles repository for macOS and Linux systems. It contains shell configurations, utility scripts, and an installation script that symlinks dotfiles to the home directory.

## Installation

```bash
./install.sh
```

The install script:
- Symlinks dotfiles (`.zshrc`, `.bashrc`, `.gitconfig`, etc.) from this repo to `$HOME`
- Sets up SSH keys and API secrets (encrypted with ansible-vault)
- Installs dependencies: oh-my-zsh, fzf, diff-so-fancy, fd, bat, tmux
- Creates a Python virtual environment at `$HOME/dev` with packages from `requirements.txt`

## Structure

- **Shell configs**: `.zshrc` (primary), `.bashrc`, `.profile` - sources `.utilrc` for shared aliases
- **`.utilrc`**: Shared aliases and functions used by both bash and zsh
- **`.workrc`**: Project-specific environment variables and debug toggles (`dbgon`/`dbgoff`)
- **`.gitconfig`**: Git aliases including `lg`, `lga`, `pb`, `sync`, `su`
- **`bin/`**: Utility scripts added to PATH
  - `query.py`: LLM query tool using Groq API (aliased as `q` function)
  - `ondir`/`ondir_osx`: Directory-change triggers

## Key Aliases

- `q <prompt>`: Query Groq LLM (requires `GROQ_API_KEY` in `.secrets`)
- `dev`: Activate the `$HOME/dev` Python virtualenv
- `dotfiles`: Pull latest dotfiles from remote
- `dsf`: Diff with diff-so-fancy formatting
- `grbom`: Fetch, rebase on main, and sync submodules

## Secrets

Encrypted files (`.secrets`, `.ssh/id_ed25519`) are decrypted during install using `ansible-vault`. The `.secrets` file should contain API keys like `GROQ_API_KEY`.
