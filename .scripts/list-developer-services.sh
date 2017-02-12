#!/usr/bin/env bash

SRV=$(docker ps --format "{{.Names}}" \
    | grep "^local_.*_[0-9]" \
    | sed -e 's/local_//' -e 's/_[0-9]//' \
    | xargs)

if [ -z "${SRV}" ]; then
    echo "NONE"
else
    echo ${SRV}
fi
