#!/bin/sh

source $HOME/.bashrc

cd

pulseaudio --start --realtime -C&

stalonetray &
./bin/init_keyboard.sh &

# bell off
xset b off &

# enable dpms, no standby, no suspend, off after 5min
xset +dpms &
xset dpms 0 0 300 &

# background and default cursor
xsetroot -solid "#505050" -cursor_name left_ptr &

# XXX: hack to fight what feels like a race condition
# the strace prevents an "Another window manager is already running" error
#strace awesome >/dev/null 2>&1
exec xmonad
