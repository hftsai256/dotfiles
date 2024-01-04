#!/usr/bin/env bash
pgrep -u "$USER" ssh-agent > /dev/null || {
    ssh-agent > "$XDG_RUNTIME_DIR/ssh-agent.env"
}

[[ ! -f "$SSH_AUTH_SOCK" ]] || {
    source "$XDG_RUNTIME_DIR/ssh-agent.env"
}

for key in $HOME/.ssh/{id_*,*_rsa}; do
    ssh-add -k $key
done

