#!/bin/sh

set -e

FILES="gitconfig inputrc tmux.conf vim vimrc zshrc"
BASEPATH=$(dirname $0)

if [ -z "${HOME}" ]
then
	echo "[!] need \$HOME set"
	exit 1
fi

for file in $FILES
do
	src="${BASEPATH}/${file}"
	dst="${HOME}/.${file}"

	if [ -e "${dst}" ]
	then
		echo "[!] ${dst} already exist, skip"
	else
		echo ln -s '"'${src}'"' '"'${dst}'" ? [y/n] '
		read ans
		if [ "${ans}" = "y" ]
		then
			ln -s "${src}" "${dst}"
		fi
	fi
done
