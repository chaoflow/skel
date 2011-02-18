#!/bin/sh

cd

pulseaudio --realtime --start &

#nm-applet &
./bin/init_keyboard.sh &

# bell off
xset b off &

# enable dpms, no standby, no suspend, off after 5min
xset +dpms &
xset dpms 0 0 300 &

exec awesome
