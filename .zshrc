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
  git zsh-syntax-highlighting #zsh-autosuggestions
)

source $ZSH/oh-my-zsh.sh

# Autojump
# Manually load from brew install dir as it's not working for plugins
[ -f /usr/local/etc/profile.d/autojump.sh ] && . /usr/local/etc/profile.d/autojump.sh

# Autosuggest
# Ctrl-k to execute suggestion
#bindkey '^k' autosuggest-execute

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/rsa_id"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

######################
# Envvars
######################

# Add user bin to PATH
export PATH="$HOME/bin:$PATH"

# Add coreutils to PATH
export PATH="/usr/local/opt/coreutils/libexec/gnubin:$PATH"

# Add linuxbrew to PATH
export PATH="$HOME/.linuxbrew/bin:$PATH"

# Add user workspace to ROOT
export ROOT="/localhome/tzhou/tensix"

# Tell less not to paginate if less than a page
export LESS="-F -X $LESS"

# requires % <brew install> coreutils
# to get GNU ls, aka gls.
export LS_COLORS='no=00;37:fi=00;37:di=01;97:ln=01;33:pi=40;34:so=00;34:bd=40;34;01:cd=40;34;01:or=01;31:mi=37;41:ex=00;32:*.cmd=00;32:*.exe=00;32:*.com=00;32:*.btm=00;32:*.bat=00;32:*.sh=00;32:*.csh=00;32:*.tar=00;31:*.tgz=00;31:*.arj=00;31:*.taz=00;31:*.lzh=00;31:*.zip=00;31:*.z=00;31:*.Z=00;31:*.gz=00;31:*.bz2=00;31:*.bz=00;31:*.tz=00;31:*.rpm=00;31:*.cpio=00;31:*.jpg=00;35:*.gif=00;35:*.bmp=00;35:*.xbm=00;35:*.xpm=00;35:*.png=00;35:*.tif=00;35:*.pl=00;36:*.gv=00;36:*.svh=00;36:*.vh=00;36:*.sv=00;36:*.v=00;36:*.ncf=00;33:*.edf=00;33:*.ucf=00;33:*.log=00;35:*.vcd=00;31:*.fsdb=00;31:'

# Go Environment
#export GOPATH="${HOME}/.go"
#export GOROOT="$(brew --prefix golang)/libexec"
#export PATH="$PATH:${GOPATH}/bin:${GOROOT}/bin"

# Codesearch
export CSEARCHINDEX="$HOME/.index"

# Custom envvars
export ARCHIVE="$HOME/work/archive"
export ARTIFACTS="$HOME/work/artifacts"

# Conda
export ANACONDA_PATH=/opt/miniconda
source $ANACONDA_PATH/etc/profile.d/conda.sh
export CONDA_ENVS_PATH=$HOME/conda-envs

# FZF in Tmux
export FZF_TMUX=1

######################
# Perl
######################

#PATH="$HOME/perl5/bin${PATH:+:${PATH}}"; export PATH;
#PERL5LIB="$HOME/perl5/lib/perl5${PERL5LIB:+:${PERL5LIB}}"; export PERL5LIB;
#PERL_LOCAL_LIB_ROOT="$HOME/perl5${PERL_LOCAL_LIB_ROOT:+:${PERL_LOCAL_LIB_ROOT}}"; export PERL_LOCAL_LIB_ROOT;
#PERL_MB_OPT="--install_base \"$HOME/perl5\""; export PERL_MB_OPT;
#PERL_MM_OPT="INSTALL_BASE=$HOME/perl5"; export PERL_MM_OPT;

######################
# Shell
######################
setopt CORRECT                  # Enable auto-correct ls *(<tab> for globbing options
setopt extendedglob             # Enable extended-globbing
autoload -U colors              # Enable colors
colors

######################
# Alias
######################
alias -- c='cd ..'
alias -- exe='x'
alias -- more='less'
alias -- sz='source ~/.zshrc'
alias -- l.='ls -d .* --color=tty'
alias -- ll='ls -l --color=tty'
alias -- ls='ls --color=tty'
alias -- gh='history | egrep '
alias -- cat='bat'

######################
# Applications
######################
alias -- stem='export ROOT=`pwd`'
#alias -- emacs='/Applications/Emacs.app/Contents/MacOS/Emacs'
#alias -- gtkwave='/Applications/gtkwave.app/Contents/Resources/bin/gtkwave'
alias -- cs='csearch'
alias -- csg='CSEARCHINDEX="$HOME/work/.csearch/grayskull_rtl.index" csearch'
alias -- vcdparse='$ROOT/bin/vcd/vcdparse.py'
alias -- run.log='find . -name "run.log"'
alias -- profile-emacs='emacs -Q -l ~/emacs.d/profile-dotemacs/profile-dotemacs.el --eval "(setq profile-dotemacs-file (setq load-file-name \"~/emacs\"))" -f profile-dotemacs'

e   () { emacsclient > /dev/null 2>&1 "$@" & }
en  () { emacs -nw "$@" }

pie () { /usr/bin/perl -p -i -e "s/$1/$2/g" $3 }
prm () { /usr/bin/perl -ni -e "print unless /$1/" $2 }
ansi_colors () { for (( i = 30; i < 38; i++ )); do echo -e "\033[0;"$i"m Normal: (0;$i); \033[1;"$i"m Light: (1;$i)"; done }
pingme () { export title=$@ && osascript -e "display notification \"$PWD\" with title \"$title Complete\"" }

######################
# Prompt
######################
NEWLINE=$'\n'

#function precmd {
#    PROMPT="%{$fg[cyan]%}@ %~%{$reset_color%} $(git_prompt_info) ${NEWLINE}${ret_status} %{$reset_color%}"
#}

######################
# TensTorrent
######################

#export MP=2 # defult number of processes to run for zversim
#export CKDEBUG=1 # enable fwlog
export VCD_NOFPU=1 # disable vcd dump for FPU
#export TRACE_FST=1 # trace dump fst instead of vcd
export FAST_VERSIM=3 # optimized for runtime

alias -- jp='cd $ROOT'
alias -- jpgc='cd $ROOT/src/software/graph_compiler'
alias -- jptests='cd $ROOT/src/hardware/tb_tensix/tests'
alias -- jpvcore='cd $ROOT/src/t6ifc/versim-core'
alias -- jptdma='cd $ROOT/src/hardware/tdma/tb'
alias -- jpfpu='cd $ROOT/src/hardware/fpu/tb/tb_fp_lane_lb'
alias -- jpzver='cd $ROOT/testing/tests/zversim/tb-stress'

alias -- unttx='rm -rf ttx && mkdir ttx && cp *.ttx ttx && cd ttx && unzip *.ttx'
alias -- unart='cd $ARTIFACTS && mkdir `date +"%m%d%H%M"` && cd `date +"%m%d%H%M"` && mv ~/Downloads/artifacts.zip ./ && unzip artifacts.zip'
alias -- unout='pwd | pbcopy; cd $ARTIFACTS && mkdir `date +"%m%d%H%M"` && cd `date +"%m%d%H%M"` && mv ~/Downloads/artifacts.zip ./ && unzip artifacts.zip; mv testing/tests/zversim/tb-stress/out `pbpaste` && cd `pbpaste`'

######################
# Directory Triggers
######################

cd() {
    builtin cd "$@" && eval "`ondir \"$OLDPWD\" \"$PWD\"`"
}

pushd() {
    builtin pushd "$@" && eval "`ondir \"$OLDPWD\" \"$PWD\"`"
}

popd() {
    builtin popd "$@" && eval "`ondir \"$OLDPWD\" \"$PWD\"`"
}

# Run ondir on login
eval "`ondir /`"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

source ~/.fonts/*.sh
