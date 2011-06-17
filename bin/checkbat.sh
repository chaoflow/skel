#!/bin/sh

if [ -r /sys/class/power_supply/BAT0/energy_now ]; then
    cat /sys/class/power_supply/BAT0/energy_now
    cat /sys/class/power_supply/BAT0/energy_full
    cat /sys/class/power_supply/BAT0/energy_full_design
else
    cat /sys/class/power_supply/BAT0/charge_now
    cat /sys/class/power_supply/BAT0/charge_full
    cat /sys/class/power_supply/BAT0/charge_full_design
fi
