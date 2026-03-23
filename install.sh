#!/bin/bash
set -e

# Get the absolute path of the current script
SCRIPT_PATH=$(realpath "$0")
FROM=$(dirname "$SCRIPT_PATH")
SHARED=$HOME/shared
LOCAL_BIN=$HOME/.local/bin

if [ ! -d "$LOCAL_BIN" ]; then
    mkdir -p "$LOCAL_BIN"
fi

is_macos() {
    [[ $OSTYPE == 'darwin'* ]]
}

install_pkg() {
    if is_macos; then
        brew install "$1"
    else
        sudo apt-get install -y "$1"
    fi
}

ensure_ansible() {
    if ! command -v ansible-vault &>/dev/null; then
        install_pkg ansible
    fi
}

# Symlink function
symlink() {
    local from_path="$FROM/$1"
    local home_path="$HOME/$1"
    if [ ! -e "$from_path" ]; then
        echo "Skipping $1 (missing in repo)"
        return
    fi
    echo "Linking $1 ..."
    rm -rf "$home_path"
    ln -s "$from_path" "$home_path"
}

# Copy file and expand ~/ to absolute home path
copy_with_home_expansion() {
    local from_path="$FROM/$1"
    local home_path="$HOME/$1"
    if [ ! -e "$from_path" ]; then
        echo "Skipping $1 (missing in repo)"
        return
    fi
    echo "Copying $1 ..."
    sed "s|~/|$HOME/|g" "$from_path" > "$home_path"
}

# Symlink from shared network drive
symlink_external() {
    local external_path="$SHARED/$1"
    local home_path="$HOME/$1"
    echo "Linking $1 from shared drive..."
    mkdir -p "$external_path"
    if [ ! -L "$home_path" ]; then
        rm -rf "$home_path"
        ln -s "$external_path" "$home_path"
    fi
}

# Setup SSH keys
mkdir -p "$HOME/.ssh"
if [ ! -f "$HOME/.ssh/id_ed25519" ] && [ -f "$FROM/.ssh/id_ed25519" ]; then
    echo "Copying SSH keys..."
    cp "$FROM/.ssh/id_ed25519" "$HOME/.ssh"
fi
if [ ! -f "$HOME/.ssh/id_ed25519.pub" ] && [ -f "$FROM/.ssh/id_ed25519.pub" ]; then
    cp "$FROM/.ssh/id_ed25519.pub" "$HOME/.ssh"
fi
if [ -f "$HOME/.ssh/id_ed25519" ]; then
    chmod 600 "$HOME/.ssh/id_ed25519"
    if grep -q '^\$ANSIBLE_VAULT;' "$HOME/.ssh/id_ed25519"; then
        ensure_ansible
        ansible-vault decrypt "$HOME/.ssh/id_ed25519"
    fi
fi

# Setup API secrets
if [ ! -f "$HOME/.secrets" ]; then
    cp "$FROM/.secrets" "$HOME/.secrets"
fi
if [ -f "$HOME/.secrets" ] && grep -q '^\$ANSIBLE_VAULT;' "$HOME/.secrets"; then
    ensure_ansible
    ansible-vault decrypt "$HOME/.secrets"
fi

# Setup tmux
if ! command -v tmux &>/dev/null; then
    install_pkg tmux
fi

# Setup uv
if ! command -v uv &>/dev/null; then
    curl -LsSf https://astral.sh/uv/install.sh | sh
fi

# Setup oh-my-zsh
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo "Setting up oh-my-zsh ..."
    git clone https://github.com/ohmyzsh/ohmyzsh.git "$HOME/.oh-my-zsh"
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting"
    git clone https://github.com/zsh-users/zsh-autosuggestions.git "$HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions"
fi

# Setup fzf
if [ ! -d "$HOME/.fzf" ]; then
    echo "Setting up fzf..."
    git clone --depth 1 https://github.com/junegunn/fzf.git "$HOME/.fzf"
    echo "y" | "$HOME/.fzf/install"
fi

# Setup diff-so-fancy
if [ ! -d "$HOME/.diff-so-fancy" ]; then
    echo "Setting up diff-so-fancy..."
    git clone https://github.com/so-fancy/diff-so-fancy.git "$HOME/.diff-so-fancy"
fi

# Setup fd
if ! command -v fdfind &>/dev/null && ! command -v fd &>/dev/null; then
    echo "Setting up fd ..."
    if is_macos; then
        install_pkg fd
    else
        install_pkg fd-find
        # Symlink fdfind to fd on Linux
        if [ ! -f "$LOCAL_BIN/fd" ] && command -v fdfind &>/dev/null; then
            ln -s "$(which fdfind)" "$LOCAL_BIN/fd"
        fi
    fi
fi

# Setup bat
if ! command -v batcat &>/dev/null && ! command -v bat &>/dev/null; then
    echo "Setting up bat ..."
    if is_macos; then
        install_pkg bat
    else
        install_pkg bat
        # Symlink batcat to bat on Linux
        if [ ! -f "$LOCAL_BIN/bat" ] && command -v batcat &>/dev/null; then
            ln -s "$(which batcat)" "$LOCAL_BIN/bat"
        fi
    fi
fi

# Setup clang-format
if ! command -v clang-format &>/dev/null; then
    if ! is_macos; then
        install_pkg clang-format
    fi
fi

# Setup zoxide
if ! command -v zoxide &>/dev/null; then
    if is_macos; then
        install_pkg zoxide
    else
        curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh
    fi
fi

# Setup glow (markdown renderer)
if ! command -v glow &>/dev/null; then
    if is_macos; then
        install_pkg glow
    else
        sudo mkdir -p /etc/apt/keyrings
        curl -fsSL https://repo.charm.sh/apt/gpg.key | sudo gpg --dearmor -o /etc/apt/keyrings/charm.gpg
        echo "deb [signed-by=/etc/apt/keyrings/charm.gpg] https://repo.charm.sh/apt/ * *" | sudo tee /etc/apt/sources.list.d/charm.list
        sudo apt update && sudo apt install glow
    fi
fi

if [ ! -d "$HOME/dev" ]; then
    echo "Setting up dev venv..."
    python3 -m venv $HOME/dev 
    source $HOME/dev/bin/activate
    pip install -r $FROM/requirements.txt
fi

# Link dotfiles
symlink ".utilrc"
symlink ".bashrc"
symlink ".zshrc"
symlink ".profile"
symlink ".colorsrc"
symlink ".emacs"
symlink ".gitconfig"
symlink ".tmux.conf"
symlink ".workrc"
symlink "bin"
copy_with_home_expansion ".ondirrc"

# Link large directories from shared network drive
if [ -d "$SHARED" ]; then
    symlink_external ".cache"
    symlink_external ".vscode-server"
    symlink_external "testify"
fi
# symlink_external ".ccache" # poor performance on network drive