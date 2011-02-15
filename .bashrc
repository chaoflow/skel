#!/bin/sh

if [ -f /etc/bashrc ]; then
    source /etc/bashrc
fi

if [ -f ~/.shrc ]; then
    source ~/.shrc
fi
