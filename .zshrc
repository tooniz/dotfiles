# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

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
#ZSH_THEME="agnoster"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in ~/.oh-my-zsh/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in ~/.oh-my-zsh/plugins/*
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.

######################
# Plugins
######################

plugins=(
  git # zsh-syntax-highlighting # zsh-autosuggestions
)

source $ZSH/oh-my-zsh.sh

######################
# Dotfiles
######################
if [[ -v IRD_CLUSTER ]]; then
    if ! command -v fdfind &>/dev/null; then
        source ~/dotfiles/install.sh
    fi
fi

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
[ -f ~/.taalasrc ] && source ~/.taalasrc

# Conda
export ANACONDA_PATH=$USER_DEV/miniconda3/
if [ -d "$ANACONDA_PATH" ]; then
    emulate bash -c '. $ANACONDA_PATH/etc/profile.d/conda.sh'
    source $ANACONDA_PATH/etc/profile.d/conda.sh
    export CONDA_ENVS_PATH=$HOME/miniconda3/envs/
fi

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

######################
# Auto File Open
######################
alias -s cc=$EDITOR_NB
alias -s cpp=$EDITOR_NB
alias -s h=$EDITOR_NB
alias -s hpp=$EDITOR_NB
alias -s yaml=$EDITOR_NB

######################
# Functions
######################

if [[ $(uname) == "Darwin" ]]; then
    alias ondir='ondir_osx'
fi

# Disabled due to slowness. Directory triggers for ondir
cd() {
    builtin cd "$@" && eval "`ondir \"$OLDPWD\" \"$PWD\"`"
}
pushd() {
    builtin pushd "$@" && eval "`ondir \"$OLDPWD\" \"$PWD\"`"
}
popd() {
    builtin popd "$@" && eval "`ondir \"$OLDPWD\" \"$PWD\"`"
}

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
