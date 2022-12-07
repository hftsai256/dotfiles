SSH_KEY_DIR=$HOME/.ssh

for pubkey in $SSH_KEY_DIR/*.pub; do
    ssh-add --apple-use-keychain ${pubkey%.*} 
done

