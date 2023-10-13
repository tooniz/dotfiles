#!/bin/bash

# Get the absolute path of the current script
script_path=$(realpath "$0")

OS=$(uname)
PM="sudo apt-get"
if [ "$OS" == "Darwin" ]; then
    PM="brew"
fi

# Extract the directory path from the script path
FROM=$(dirname "$script_path")

# Shared development space
SHARED="/proj_sw/user_dev/$USER"

# Symlink from dotfiles repository
create_symlink() {
    echo "Linking $1 ..."
    local from_path="$FROM/$1"
    local home_path="$HOME/$1"
    rm -rf "$home_path"
    ln -s "$from_path" "$home_path"
}

# Symlink from shared network drive
create_external_symlink() {
    echo "Linking $1 ..."
    local external_path="$SHARED/$1"
    local home_path="$HOME/$1"
    if [ ! -d "$external_path" ]; then
        mkdir -p "$external_path"
    fi
    if [ ! -L "$home_path" ]; then
        rm -rf "$home_path"
        ln -s "$external_path" "$home_path"
    fi
}

if [ ! -d "$HOME/.ssh" ]; then
    echo "Setting up SSH keys..."
    mkdir -p "$HOME/.ssh"
    cp "$FROM/.ssh/id_ed25519" "$HOME/.ssh"
    cp "$FROM/.ssh/id_ed25519.pub" "$HOME/.ssh"
    $PM install ansible
    ansible-vault decrypt $HOME/.ssh/id_ed25519
fi

if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo "Setting up oh-my-zsh ..."
    git clone https://github.com/robbyrussell/oh-my-zsh.git $HOME/.oh-my-zsh
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting
fi

if [ ! -d "$HOME/.fzf" ]; then
    echo "Setting up fzf..."
    git clone --depth 1 https://github.com/junegunn/fzf.git $HOME/.fzf
    echo "y" | $HOME/.fzf/install
fi

if [ ! -d "$HOME/.diff-so-fancy" ]; then
    echo "Setting up diff-so-fancy..."
    git clone https://github.com/so-fancy/diff-so-fancy.git $HOME/.diff-so-fancy
fi

if ! command -v fdfind &>/dev/null; then
    echo "Setting up fd ..."
    if [ "$OS" == "Darwin" ]; then
        $PM install fd
    else
        $PM install fd-find
    fi
    if [ ! -f $HOME/.local/bin/fd ]; then
        ln -s $(which fdfind) $HOME/.local/bin/fd
    fi
fi

if ! command -v batcat &>/dev/null; then
    if ! command -v bat &>/dev/null; then
        echo "Setting up bat ..."
        echo "y" | $PM install bat
        if [ ! -f $HOME/.local/bin/bat ]; then
            ln -s $(which batcat) $HOME/.local/bin/bat
        fi
    fi
fi

# Link dotfiles
create_symlink ".ttrc"
create_symlink ".utilrc"
create_symlink ".bashrc"
create_symlink ".zshrc"
create_symlink ".profile"
create_symlink ".ondirrc"
create_symlink ".colorsrc"
create_symlink ".emacs"
create_symlink ".gitconfig"
create_symlink "bin"

# Link large directories from shared network drive
if [ -d "$SHARED" ]; then
    create_external_symlink ".cache"
    create_external_symlink ".vscode-server"
    create_external_symlink "testify"
fi
# create_external_symlink ".ccache" # poor performance on network drive
