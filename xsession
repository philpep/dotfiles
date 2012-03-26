#!/bin/sh
LOGFILE="$HOME/.xserver.log"
#LANG="en_US.UTF-8"; export LANG
numlockx &
#setxkbmap -model pc105 -layout fr
#xrandr --output LVDS --mode 1280x800
pgrep urxvtd || urxvtd -q -o -f &
#hsetroot -fill $HOME/photos/bg/freebsd.png &
#synclient TapButton1=1
#synclient HorizTwoFingerScroll=1
xset b off
eval $(ssh-agent)
eval $(gpg-agent --daemon)
export PATH="$HOME/bin:$PATH"
while true;
do
	dwm
done
