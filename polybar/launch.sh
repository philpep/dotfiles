#!/bin/sh
polybar-msg cmd quit
for m in $(xrandr --query | grep " connected" | cut -d" " -f1); do
    MONITOR=$m polybar --reload phil & disown
done
