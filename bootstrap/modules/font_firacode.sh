#!/usr/bin/env bash
source ${DOTFILES}/bootstrap/utility.sh

p_header "Install FiraCode"

# Install for OSX
if [[ $(util_getos) =~ osx ]] ; then
    # User Prompt
    p_arrow "Mac OS X Detected"
    brew tap homebrew/cask-fonts
    brew install font-fira-code-nerd-font
    p_success "Done"
fi

# Install for Ubuntu
if [[ $(util_getos) =~ ubuntu ]]; then
    p_arrow "Ubuntu detected"
    p_arrow "Install with apt-get (package fonts-firacode)"
    sudo apt install fonts-firacode
    p_success "Done"
fi
