#!/bin/sh

set -e

[ -z "$HOME" ] && echo "[!] Need \$HOME set" && exit 1

HERE=$(dirname $(readlink -f $0))

for f in gitconfig tmux.conf vim vimrc zshrc; do
	echo ln -fsn $HERE/$f $HOME/.$f
	ln -fsn $HERE/$f $HOME/.$f
done
