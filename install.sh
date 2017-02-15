#!/bin/sh

set -e

[ -z "$HOME" ] && echo "[!] Need \$HOME set" && exit 1

HERE=$(dirname $(readlink -f $0))

for f in gitconfig tmux.conf vim vimrc zshrc pythonstartup gitignore_global hgrc hgignore_global hgrc.d i3 gemrc; do
	echo ln -fsn $HERE/$f $HOME/.$f
	ln -fsn $HERE/$f $HOME/.$f
done

mkdir -p $HOME/.config/xfce4/terminal
ln -fsn $HERE/xfce4-terminalrc $HOME/.config/xfce4/terminal/terminalrc
