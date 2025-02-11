#!/bin/sh

set -e

[ -z "$HOME" ] && echo "[!] Need \$HOME set" && exit 1

HERE=$(dirname $(readlink -f $0))

for f in gitconfig tmux.conf vim zsh vimrc zshrc pythonstartup gitignore_global hgrc hgignore_global hgrc.d gemrc mutt psqlrc; do
    echo ln -fsn $HERE/$f $HOME/.$f
    ln -fsn $HERE/$f $HOME/.$f
done

for f in i3 sway; do
    echo ln -fsn $HERE/$f $HOME/.config/$f
    ln -fsn $HERE/$f $HOME/.config/$f
done

mkdir -p $HOME/.config/xfce4/terminal
ln -fsn $HERE/xfce4-terminalrc $HOME/.config/xfce4/terminal/terminalrc
mkdir -p $HOME/.cache/mutt

mkdir -p $HOME/.config/yamllint
ln -fsn $HERE/yamllint $HOME/.config/yamllint/config
