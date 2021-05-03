export SSH_KEY_PATH='~/.ssh'
if [ -f $SSH_KEY_PATH/id_rsa ]; then
    ssh-add -K $SSH_KEY_PATH/id_rsa 2>/dev/null
fi
