#!/usr/bin/env bash

## You will need to run this under sudo.
## Put this rule in your sudoers file.
## your_username ALL=(root) NOPASSWD: ./kbd_backlight

LED_CLASS=/sys/class/leds/smc::kbd_backlight

KBD_BACKLIGHT_MIN=0
KBD_BACKLIGHT_MAX=$(cat ${LED_CLASS}/max_brightness)
KBD_BACKLIGHT_LEV=$(cat ${LED_CLASS}/brightness)

if [ $# -eq 0 ]
then
    echo "Missing arguments." >&2
    echo "Usage: sudo $(basename $0) [-inc|-dec] [VAL]" >&2
    exit 192
fi 

if [ $# -eq 2 ]
then
    val=$2
else
    val=10
fi

case $1 in
-inc ) 
    # increasing:
    KBD_BACKLIGHT_LEV=$[${KBD_BACKLIGHT_LEV}+${val}]
    if [ ${KBD_BACKLIGHT_LEV} -gt ${KBD_BACKLIGHT_MAX} ]
    then
        KBD_BACKLIGHT_LEV=$KBD_BACKLIGHT_MAX
    fi
    echo "VALUE: $(echo ${KBD_BACKLIGHT_LEV} | tee ${LED_CLASS}/brightness)" && exit 0
    ;;
-dec )
    # decreasing:
    KBD_BACKLIGHT_LEV=$[${KBD_BACKLIGHT_LEV}-${val}]
    if [ ${KBD_BACKLIGHT_LEV} -lt ${KBD_BACKLIGHT_MIN} ]
    then
        KBD_BACKLIGHT_LEV=$KBD_BACKLIGHT_MIN
    fi
    echo "VALUE: $(echo ${KBD_BACKLIGHT_LEV} | tee ${LED_CLASS}/brightness)" && exit 0
    ;;
esac

echo "Unknown option: $1" >&2

exit 192
