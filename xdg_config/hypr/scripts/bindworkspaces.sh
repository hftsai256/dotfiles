#!/usr/bin/env bash

builtin_monitor="0"
builtin_ws=(8 9 10)

prime_monitor="1"
prime_ws=(1 2 3 4 5)

handleworkspaces() {
    if [[ ${1:0:15} == "createworkspace" ]]; then
        ws=$(( ${1:17:19} ))
        if  [[ "${prime_ws[@]}" =~ "$ws" ]]; then
            echo "create workspace#$ws to prime monitor"
            hyprctl dispatch moveworkspacetomonitor "$ws $prime_monitor"
        elif  [[ "${builtin_ws[@]}" =~ "$ws" ]]; then
            echo "create workspace#$ws to builtin monitor"
            hyprctl dispatch moveworkspacetomonitor "$ws $builtin_monitor"
        fi
    elif [[ ${1:0:9} == "workspace" ]]; then
        ws=$(( ${1:11:13} ))
        if  [[ "${prime_ws[@]}" =~ "$ws" ]]; then
            echo "move workspace#$ws to prime monitor"
            hyprctl dispatch moveworkspacetomonitor "$ws $prime_monitor"
        elif  [[ "${builtin_ws[@]}" =~ "$ws" ]]; then
            echo "move workspace#$ws to builtin monitor"
            hyprctl dispatch moveworkspacetomonitor  "$builtin_ws $builtin_monitor"
        fi
    fi
}

socat - UNIX-CONNECT:/tmp/hypr/$(echo $HYPRLAND_INSTANCE_SIGNATURE)/.socket2.sock | while read line; do handleworkspaces $line; done

