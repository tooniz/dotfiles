# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

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
  git zsh-syntax-highlighting # zsh-autosuggestions
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
for file in /etc/profile.d/*.sh; do
    emulate bash -c 'source "$file"'
done

# Add user bin to PATH
export PATH="/usr/bin/:$HOME/.local/bin:$HOME/bin:$PATH"

# Tell less not to paginate if less than a page
export LESS="-F -X $LESS"

# Default ls colors
export LS_COLORS='no=00;37:fi=00;37:di=01;97:ln=01;33:pi=40;34:so=00;34:bd=40;34;01:cd=40;34;01:or=01;31:mi=37;41:ex=00;32:*.cmd=00;32:*.exe=00;32:*.com=00;32:*.btm=00;32:*.bat=00;32:*.sh=00;32:*.csh=00;32:*.tar=00;31:*.tgz=00;31:*.arj=00;31:*.taz=00;31:*.lzh=00;31:*.zip=00;31:*.z=00;31:*.Z=00;31:*.gz=00;31:*.bz2=00;31:*.bz=00;31:*.tz=00;31:*.rpm=00;31:*.cpio=00;31:*.jpg=00;35:*.gif=00;35:*.bmp=00;35:*.xbm=00;35:*.xpm=00;35:*.png=00;35:*.tif=00;35:*.pl=00;36:*.gv=00;36:*.svh=00;36:*.vh=00;36:*.sv=00;36:*.v=00;36:*.ncf=00;33:*.edf=00;33:*.ucf=00;33:*.log=00;35:*.vcd=00;31:*.fsdb=00;31:'

[ -f ~/.ttrc ] && source ~/.ttrc

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

# Directory triggers for ondir
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
