# Profiling ZSH
# zmodload zsh/zprof

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Change location of zcompdump cache
export ZSH_COMPDUMP=$ZSH/cache/.zcompdump-$HOST

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
ZSH_THEME="robbyrussell"

######################
# Plugins
######################

plugins=(git)

source $ZSH/oh-my-zsh.sh

######################
# Envvars
######################

# Bash init scripts (for compatibility)
if [ -d /etc/profile.d ]; then
    for file in /etc/profile.d/*.sh; do
        if [ -r "$file" ]; then
            emulate bash -c 'source "$file"'
        fi
    done
fi

# Add user bin to PATH
export PATH="/usr/bin/:$HOME/.local/bin:$HOME/bin:$PATH"

# Tell less not to paginate if less than a page
export LESS="-F -X $LESS"

[ -f ~/.secrets ] && source ~/.secrets
[ -f ~/.colorsrc ] && source ~/.colorsrc
[ -f ~/.workrc ] && source ~/.workrc

######################
# Shell
######################
setopt CORRECT                  # Enable auto-correct ls *(<tab> for globbing options
setopt extendedglob             # Enable extended-globbing
autoload -U colors              # Enable colors
colors

######################
# Alias and utils
######################
export EDITOR_NB='vim'

[ -f ~/.utilrc ] && source ~/.utilrc
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

######################
# Auto File Open
######################
file_extensions="cpp h py yaml"
for ext in $file_extensions; do
  alias -s $ext=$EDITOR_NB
done

######################
# Functions
######################

if [[ $(uname) == "Darwin" ]]; then
    alias ondir='ondir_osx'
fi

# Directory triggers for ondir
eval_ondir() {
  eval "`ondir \"$OLDPWD\" \"$PWD\"`"
}
chpwd_functions=( eval_ondir $chpwd_functions )
