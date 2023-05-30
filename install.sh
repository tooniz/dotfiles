#!/bin/bash

# Get the absolute path of the current script
script_path=$(realpath "$0")

# Extract the directory path FROM the script path
FROM=$(dirname "$script_path")

# mkdir -p $HOME/.ssh
# ln -s $FROM/.ssh/id_ed25519 $HOME/.ssh/id_ed25519
# ln -s $FROM/.ssh/id_ed25519.pub $HOME/.ssh/id_ed25519.pub

git clone https://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting

git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
echo "y" | ~/.fzf/install

ln -s $FROM/.bashrc $HOME/.bashrc
ln -s $FROM/.zshrc $HOME/.zshrc
ln -s $FROM/.gitconfig $HOME/.gitconfig
ln -s $FROM/bin $HOME/bin

cd $HOME

