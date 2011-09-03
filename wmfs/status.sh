#!/bin/bash

_memory() {
	memory_used="`free -m | sed -n 's|^-.*:[ \t]*\([0-9]*\) .*|\1|gp'`"
	memory_total="`free -m | sed -n 's|^M.*:[ \t]*\([0-9]*\) .*|\1|gp'`"
	memory="$memory_used/$memory_total Mo"
}

_date() {
	sys_date=`date '+%a %d %b %Y'`
	date="\\#ff6b6b\\$sys_date"
}

_hour() {
	sys_hour=`date '+%H:%M'`
	hour="\\#1793d1\\$sys_hour"
}

_separateur() {
	separateur="-"
}

statustext() {
	for arg in $@; do
		_${arg}
		args="${args}  `eval echo '$'$arg`"
	done
	wmfs -s "$args"
}

statustext memory separateur date separateur hour

