#!/usr/bin/env zsh
export EDITOR=vim
export GREP_COLOR=mt=31
export PYTHONSTARTUP=~/.pythonstartup
export DEBEMAIL=phil@philpep.org
export DEBFULLNAME="Philippe Pepiot"
export DOCKER_HOST=unix://$XDG_RUNTIME_DIR/docker.sock
export DOCKER_HOST=unix:///run/user/$UID/docker.sock
HISTFILE=~/.histfile
HISTSIZE=100000
SAVEHIST=100000
setopt append_history hist_ignore_all_dups hist_reduce_blanks
setopt autocd
unsetopt beep
unsetopt notify
setopt extendedglob

autoload -U colors
colors

watch=all

bindkey -e

fpath=(~/.zsh/functions $fpath)
autoload -Uz compinit
compinit
command -v kubectl >/dev/null 2>&1 && source <(kubectl completion zsh)


typeset -U path PATH

case `uname -s` in
  FreeBSD)
  export LC_ALL="en_US.UTF-8"
  export LANG="en_US.UTF-8"
  export LSCOLORS="exgxfxcxcxdxdxhbadacec"
  alias man="PAGER=\"col -b | vim -c 'set ft=man nomod nolist' -\" man"
  alias ls="ls -G"
  alias ll="ls -Glh"
  alias lla="ls -Glha"
  alias lll="ls -Glh | less"
  alias grep="grep --colour"
  alias cp='cp -v'
  alias mv='mv -v'
  alias rm='rm -v'
  kbdcontrol -b off
  ;;
  OpenBSD)
  export PKG_PATH="http://ftp.fr.openbsd.org/pub/OpenBSD/$(uname -r)/packages/$(uname -m)/"
  which colorls >/dev/null 2>&1 && alias ls="colorls -G"
  ;;
  Linux)
  if [[ -r ~/.dir_colors ]]; then
    eval `dircolors -b ~/.dir_colors`
  elif [[ -r /etc/DIR_COLORS ]]; then
    eval `dircolors -b /etc/DIR_COLORS`
  fi
  alias ls="ls --color=auto"
  alias ll='ls --color=auto -lh'
  alias lla='ls --color=auto -lha'
  alias lll='ls --color=auto -lh | less'
  alias vim='TERM=xterm-256color vim'
  which chg 2>/dev/null >/dev/null && alias hg=chg
  alias grep='grep --color=auto'
  # export MANPAGER="/bin/sh -c \"sed -e 's/.$(echo -e '\010')//g' | vim -R -c 'set ft=man nomod nolist' -\""
  path=(~/.local/bin ~/.local/node_modules/bin ~/bin /sbin /usr/sbin /usr/local/bin /usr/local/sbin $path)
  export PAGER='less -FRXS'
  alias cp='cp -v'
  alias mv='mv -v'
  alias rm='rm -v'
  ;;
esac


alias xs='cd'
alias sl='ls'
alias :e="\$EDITOR"
alias :wq='exit'
alias :q!='exit'
alias less='less -r'
alias more='less -r'
alias c='clear'
alias exit="clear; exit"
alias top-10="sed -e 's/sudo //' $HOME/.histfile |  cut -d' ' -f1 | sort | uniq -c | sort -rg | head"
alias libreoffice="libreoffice --norestore"
alias localc="localc --norestore"

# per extentions
alias -s pdf="evince"
alias -s png="eog"
alias -s jpg="eog"
alias -s gif="eog"

zmodload zsh/complist
zstyle ':completion:*:descriptions' format '%U%B%d%b%u'
zstyle ':completion:*:warnings' format '%BSorry, no matches for: %d%b'
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.zsh_cache
zstyle ':completion:*:processes' command 'ps -aU$USER'
zstyle ':completion:*:*:kill:*:processes' list-colors "=(#b) #([0-9]#)*=36=31"
zstyle ':completion:*:sudo:*' command-path /usr/local/sbin /usr/local/bin \
/usr/sbin /usr/bin /sbin /bin /usr/X11R6/bin
zstyle ':completion:*' list-colors ${(s.:.)LSCOLORS}
zstyle ':completion:*' menu select=2
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle ':completion:*:rm:*' ignore-line yes
zstyle ':completion:*:mv:*' ignore-line yes
zstyle ':completion:*:cp:*' ignore-line yes
compdef chg='hg'


# Convert * to mp3 files
function 2mp3() 
{
  until [ -z $1 ]
  do
    ffmpeg -i $1 -acodec libmp3lame "`basename $1`.mp3"
    shift
  done
}

function 2html()
{
  until [ -z $1 ]
  do
    vim -n -c ':TOhtml' -c ':wqa' $1 &>/dev/null
    shift
  done
}

function precmd
{
  local deco="%{${fg_bold[default]}%}"

  if [[ -e ".git/HEAD" ]]; then
    local git_branch=" [`awk '{split($0, a, "refs/heads/")} END { print a[2] }' .git/HEAD`]"
  else
    local git_branch=""
  fi

  local yellow="%{${fg_bold[yellow]}%}"

  local sandbox=""
  local init=""
  [[ -r /proc/1/comm ]] && init="$(</proc/1/comm)"

  if [[ -n $SANDBOX_NAME ]]; then
    sandbox="%{${fg_bold[yellow]}%}🔒 ${SANDBOX_NAME} "
  elif [[ $init == bwrap ]]; then
    sandbox="%{${fg_bold[yellow]}%}🔒 "
  elif (( ${path[(I)*.sandbox/bin]} )); then
    sandbox="%{${fg_bold[yellow]}%}🔒 "
  fi

  local return_code="%(?..${deco}!%{${fg_no_bold[red]}%}%?${deco}! )"
  local user_at_host="%{${fg_bold[red]}%}%n${yellow}@%{${deco}%}%m"
  local cwd="%{${deco}%}%48<...<%~"
  local sign="%(!.%{${fg_bold[red]}%}.${deco})%#"

  PS1="${sandbox}${return_code}${deco}(${user_at_host} ${cwd}${git_branch}${deco}) ${sign}%{${reset_color}%} "
}

__git_files () {
  _wanted files expl 'local files' _files
}

if [ -d "$HOME/adb-fastboot/platform-tools" ] ; then
 path=(~/adb-fastboot/platform-tools $path)
fi

command -v direnv 2>/dev/null >/dev/null && eval "$(direnv hook zsh)"



# vim:filetype=zsh:tabstop=8:shiftwidth=2:fdm=marker:
