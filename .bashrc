#!/bin/sh

if [ -f /etc/bashrc ]; then
    source /etc/bashrc
elif [ -f /etc/bash/bashrc ]; then
    source /etc/bash/bashrc
fi

if [ -f ~/.shrc ]; then
    source ~/.shrc
fi
