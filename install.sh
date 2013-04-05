#!/bin/sh

set -e

FILES="gitconfig inputrc tmux.conf vim vimrc zshrc"
BASEPATH=$(cd $(dirname $0); pwd)

if [ -z "${HOME}" ]
then
	echo "[!] need \$HOME set"
	exit 1
fi

for file in $FILES
do
	src="${BASEPATH}/${file}"
	dst="${HOME}/.${file}"
	ln -sfn "${src}" "${dst}"
done
