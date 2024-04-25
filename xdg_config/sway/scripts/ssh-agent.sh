#!/usr/bin/env bash
SSH_AUTH_SOCK=/run/user/1000/ssh-agent.socket

for key in $HOME/.ssh/{id_*,*_rsa}; do
    echo add key $key to ssh agent keyring
    ssh-add -k $key
done

