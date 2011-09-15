#!/bin/sh

cd /sys/class/power_supply/BAT0

# why differs that for my two accumulators?
if [ -r energy_now ]; then
    cat energy_now
    cat energy_full
    cat energy_full_design
    cat power_now
else
    cat charge_now
    cat charge_full
    cat charge_full_design
    cat current_now
fi
