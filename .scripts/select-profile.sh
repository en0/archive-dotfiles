#!/usr/bin/env bash

PROFILE=$(xrandr | grep -oP '[a-zA-Z0-9]+ connected' | cut -d' ' -f1 | sort | xargs | tr ' ' '_')
echo Identified Profile: $PROFILE

for var in $@
do
    if [[ "${PROFILE}" =~ "${var%=*}" ]]
    then
        echo Executing Profile Script: ${var#*=}
        sh ${var#*=}
    fi
done
