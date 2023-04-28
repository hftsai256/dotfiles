#!/usr/bin/env bash
# Adapted from https://unix.stackexchange.com/questions/591621/how-can-i-reload-swayidle-swaylock

SELF=$(realpath $0)
[[ "$SWAYSOCK" ]] && {
    TIMEOUT=300

    case "$1" in
        lock-now)
            BG='&'
            [[ "$2" == "wait" ]] && BG=''
            swaylock-fancy 
            ;;

        lock-off)
            pkill swayidle
            swayidle -w \
                timeout $TIMEOUT  "swaymsg 'output * dpms off'" \
                resume            "swaymsg 'output * dpms on'" \
                before-sleep      "$SELF lock-now wait; $SELF enable-lock" &
            ;;

        enable-lock|*)
            pkill swayidle
            swayidle -w \
                timeout $TIMEOUT                "swaymsg 'output * dpms off'"  resume "swaymsg 'output * dpms on'" \
                timeout $(( TIMEOUT * 2 ))      "swaymsg 'output * dpms on'; $SELF lock-now" \
                timeout $(( TIMEOUT * 3 ))      "swaymsg 'output * dpms off'" resume "swaymsg 'output * dpms on'" \
                timeout $(( TIMEOUT * 4 ))      "sudo systemctl suspend" \
                before-sleep                    "$SELF lock-now wait" &
            ;;
    esac

    #ps -ef |grep '[s]wayidle'
    exit $?
}
