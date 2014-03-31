#!/usr/bin/env zsh
# /etc/zsh/zshrc
# Global zsh configuration
#    _________  _   _ ____   ____ 
#   |__  / ___|| | | |  _ \ / ___|
#     / /\___ \| |_| | |_) | |    
#    / /_ ___) |  _  |  _ <| |___ 
#   /____|____/|_| |_|_| \_\\____|
#                                 
# philpep zshrc
# http://philpep.org
# Thanks to Geekounet http://poildetroll.net

export EDITOR=vim
export GREP_COLOR=31
export PYENV_ROOT="$HOME/.pyenv"
HISTFILE=~/.histfile
HISTSIZE=10000
SAVEHIST=10000
setopt append_history hist_ignore_all_dups hist_reduce_blanks
setopt autocd
unsetopt beep
unsetopt notify
setopt extendedglob

autoload -U colors
colors

watch=all

bindkey -e

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
  alias grep='grep --color=auto'
  export MANPAGER="/bin/sh -c \"sed -e 's/.$(echo -e '\010')//g' | vim -R -c 'set ft=man nomod nolist' -\""
  export PATH="$HOME/.pyenv/bin:$HOME/bin:/sbin:/usr/sbin:/usr/local/bin:/usr/local/sbin:$PATH"
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

# per extentions
alias -s pdf="epdfview"
alias -s png="eog"
alias -s jpg="eog"
alias -s gif="eog"

autoload -Uz compinit
compinit

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
  local deco="%{${fg_bold[black]}%}"

  if [[ -O "$PWD" ]]; then
    local path_color="${fg_no_bold[white]}"
  elif [[ -w "$PWD" ]]; then
    local path_color="${fg_no_bold[blue]}"
  else
    local path_color="${fg_no_bold[red]}"
  fi

  if [[ -e ".git/HEAD" ]]; then
    local git_branch=" [`awk '{split($0, a, "refs/heads/")} END { print a[2] }' .git/HEAD`]"
  else
    local git_branch=""
  fi

  local host_color="${fg_bold[default]}"

  local yellow="%{${fg_bold[yellow]}%}"

  local return_code="%(?..${deco}!%{${fg_no_bold[red]}%}%?${deco}! )"
  local user_at_host="%{${fg_bold[red]}%}%n${yellow}@%{${host_color}%}%m"
  local cwd="%{${path_color}%}%48<...<%~"
  local sign="%(!.%{${fg_bold[red]}%}.${deco})%#"

  if readlink -f .local/bin/activate | grep -q "^$HOME/venvs/"; then
      source .local/bin/activate
  else
      #deactivate >/dev/null 2>&1
  fi

  if [[ -n ${VIRTUAL_ENV} ]]; then
    local venv="(`basename $VIRTUAL_ENV`)"
  else
    local venv=""
  fi

  PS1="${return_code}${deco}${venv}(${user_at_host} ${cwd}${git_branch}${deco}) ${sign}%{${reset_color}%} "
}

__git_files () {
  _wanted files expl 'local files' _files
}

# vim:filetype=zsh:tabstop=8:shiftwidth=2:fdm=marker:
