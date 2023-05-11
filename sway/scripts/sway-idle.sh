#!/usr/bin/env bash
# Adapted from https://unix.stackexchange.com/questions/591621/how-can-i-reload-swayidle-swaylock

LOCK_CMD="swaylock-fancy --daemonize --ignore-empty-password"
SELF=$(realpath $0)

[[ "$SWAYSOCK" ]] && {
    IDLE_GAP=5
    IDLE_TIMEOUT=300
    LOCK_TIMEOUT=600
    SUSP_TIMEOUT=1800

    case "$1" in
        lock-now)
            [[ "$2" == "wait" ]] && BG='' || BG=&
            $LOCK_CMD $BG
            ;;

        lock-off)
            pkill swayidle
            swayidle -w \
                timeout $IDLE_TIMEOUT "swaymsg 'output * dpms off'" \
                    resume "swaymsg 'output * dpms on'" \
                before-sleep "$SELF lock-now wait; $SELF enable-lock" &
            ;;

        enable-lock|*)
            pkill swayidle
            swayidle -w \
                timeout $IDLE_TIMEOUT "swaymsg 'output * dpms off'" \
                    resume "swaymsg 'output * dpms on'" \
                timeout $LOCK_TIMEOUT "swaymsg 'output * dpms on'; $SELF lock-now" \
                timeout $((LOCK_TIMEOUT+IDLE_GAP)) "swaymsg 'output * dpms off'" \
                    resume "swaymsg 'output * dpms on'" \
                timeout $SUSP_TIMEOUT "systemctl suspend" \
                before-sleep "$SELF lock-now wait" &
            ;;
    esac

    exit $?
}
