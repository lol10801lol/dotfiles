#!/bin/sh

# vol.sh - a control script for the pamixer
# 2014 - by pschmitt
# 2014 - redone by klassiker

# Fallback value
VOL_STEPS=5

# Prints out the current volume
vol() {
 echo "Volume: $(amixer get Master | egrep -o "[0-9]+%")"
}

# Increases the volume by fallback value or parameter
inc() {
    [[ -n "$1" ]] && VOL_STEPS=$1 # If no value is given, use fallback value
    amixer -c 1 set Master playback $VOL_STEPS%+ unmute
    [[ -z "$2" ]] && noti && vol
}

# Decreases the volume by fallback value or parameter
dec() {
    [[ -n "$1" ]] && VOL_STEPS=$1 # If no value is given, use fallback value
    amixer -c 1 set Master playback $VOL_STEPS%- unmute
    [[ -z "$2" ]] && noti && vol
}

# Mute the channel
mute() {
    amixer -c 1 set Master playback toggle
    noti
}

# Callback to splashscreen of volnoti.
# This could be removed to reduce dependencies.
noti() {
    local v=$(amixer get Master | egrep -o "[0-9]+%"|sed 's/.$//')
    local m=$(amixer -c 1 get Master|grep -o "off")
    [[ "$v" -gt 100 ]] && v=100 # max value
    [[ "$m" == "off" ]] && { volnoti-show -m; return; }
    [[ "$v" -eq 0 ]] && volnoti-show -m || volnoti-show $v
}

# Prints out the helpmenu
showhelp() {
    echo "./$0 <arg> <val>"
    echo "<arg> i/inc/increase:  increase volume by <val>"
    echo "      d/dec/decrease:  decrease volume by <val>"
    echo "      m/mute:          mute/demute. no <val>"
    echo "      n/noti/notify:   show a notification splash. no <val>"
    echo "Default output is the current volume."
}

# Show help if no parameter is given
[[ ! -n "$1" ]] && showhelp

# Now do everything the user wants
case "$1" in
    i|inc|increase)
        inc "$2" "$3"
        ;;
    d|dec|decrease)
        dec "$2" "$3"
        ;;
    m|mute)
        mute
        ;;
    n|noti|notify)
        noti
        ;;
    *)
        vol
        ;;
esac
