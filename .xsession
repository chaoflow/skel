#!/bin/sh

if test -z $ZSH_VERSION && zsh --version >&/dev/null; then
    exec zsh -l "$0" "$@"
fi

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

exec xmonad
