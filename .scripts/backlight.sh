#!/usr/bin/env bash

CURRENT_VALUE=$(xbacklight -get | cut -d'.' -f1)$(xbacklight -get | cut -d'.' -f2 | head -c2)
MIN_VALUE=1000

case $1 in
dec)
    if [[ $MIN_VALUE -lt $CURRENT_VALUE ]]
    then
        xbacklight -dec 5
    fi
    ;;
inc)
    xbacklight -inc 5
    ;;
esac

xbacklight -get

