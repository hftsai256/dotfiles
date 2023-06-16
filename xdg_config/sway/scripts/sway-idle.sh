#!/usr/bin/env bash
# Adapted from https://unix.stackexchange.com/questions/591621/how-can-i-reload-swayidle-swaylock

#LOCK_CMD="swaylock-fancy --daemonize --ignore-empty-password"
LOCK_CMD=swaylock_effects
SELF=$(realpath $0)

swaylock_effects () {
    swaylock
}

dpms_op () {
    [[ $SWAYSOCK ]] && echo "swaymsg 'output * dpms $1'"
    [[ $HYPRLAND_INSTANCE_SIGNATURE ]] && echo "hyprctl dispatcher dpms $1"
}

[[ "$SWAYSOCK" ]] || [[ "$HYPRLAND_INSTANCE_SIGNATURE" ]] && {
    LOCK_TIMEOUT=300
    IDLE_TIMEOUT=300
    SUSP_TIMEOUT=1800

    case "$1" in
        lock-now)
            [[ "$2" == "wait" ]] && BG='' || BG=&
            $LOCK_CMD $BG
            ;;

        lock-off)
            pkill swayidle
            swayidle -w \
                timeout $LOCK_TIMEOUT "$(dpms_op off)" \
                    resume "$(dpms_op on)" \
                before-sleep "$SELF lock-now wait; $SELF enable-lock" &
            ;;

        enable-lock|*)
            pkill swayidle
            swayidle -w \
                timeout $LOCK_TIMEOUT "$(dpms_op on); $SELF lock-now" \
                timeout $((LOCK_TIMEOUT+IDLE_TIMEOUT)) "$(dpms_op off)" \
                    resume "$(dpms_op on)" \
                timeout $SUSP_TIMEOUT "systemctl suspend" \
                before-sleep "$SELF lock-now wait" &
            ;;
    esac

    exit $?
}
