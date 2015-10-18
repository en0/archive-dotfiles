#!/bin/bash

# Send a notification up to Hipchat

if [ -z $1 ]; then
    echo "Usage: $0 [ROOM] [FILE]"
    echo ""
    echo "Options:"
    echo "  ROOM - The room to send the message to."
    echo "  FILE - Optional: The file to send as the message."
    echo ""
    exit 1
fi

hipchav.py -h >/dev/null 2>&1 || { echo >&2 "hipchav.py is required. Try: pip install hipchav"; exit 1; }

VAR="/quote"
while IFS="";read -r line
do
    echo "${line}"
    VAR="${VAR}${line}
"
done < "${2:-/dev/stdin}"

hipchav.py message "${1}" "${VAR}"
