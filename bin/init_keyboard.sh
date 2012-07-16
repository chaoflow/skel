#!/bin/sh

# XXX make this more robust, with fallback keymap? or check whether keymap exists?
setxkbmap -model thinkpad60 -layout chaoflow
xmodmap ~/.Xmodmap &
xset r rate 250 100 &

# let's find everything that has a trackpoint and enable wheel emulation
for id in `xinput list |grep -i trackpoint |cut -d= -f2 |cut -d'	' -f1`; do
	xinput set-int-prop $id "Evdev Wheel Emulation" 8 1 2>/dev/null &
	xinput set-int-prop $id "Evdev Wheel Emulation Button" 8 2 2>/dev/null &
	xinput set-int-prop $id "Evdev Wheel Emulation Axes" 8 6 7 4 5 2>/dev/null &
	xinput set-int-prop $id "Evdev Wheel Emulation Timeout" 8 50 2>/dev/null &
done

xset m 4 0 &
