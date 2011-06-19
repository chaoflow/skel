#!/bin/sh

source $HOME/.bashrc

cd

pulseaudio --realtime --start &

stalonetray &
./bin/init_keyboard.sh &

# bell off
xset b off &

# enable dpms, no standby, no suspend, off after 5min
xset +dpms &
xset dpms 0 0 300 &

# XXX: hack to fight what feels like a race condition
# the strace prevents an "Another window manager is already running" error
#strace awesome >/dev/null 2>&1
exec xmonad
