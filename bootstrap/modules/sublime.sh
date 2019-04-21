#!/usr/bin/env bash
source ${DOTFILES}/bootstrap/utility.sh
p_header "Configure Sublime Text 3"

if [[ $(util_getos) =~ osx ]]; then
    SUBL_PKG_PATH="${HOME}/Library/Application Support/Sublime Text 3"
    p_arrow "Looking for installed sublime text under /Application/Sublime Text 3"

    # Check if sublime has been installed
    if [[ ! -d /Applications/Sublime\ Text.app ]]; then
        p_arrow "Install Sublime Text 3 with Homebrew"
        brew cask install sublime-text
    fi

    # Link useful CLI launcher for user
    if [[ ! -L /usr/local/bin/subl ]]; then
        p_arrow "Link subl CLI launcher"
        ln -s /Applications/Sublime\ Text.app/Contents/SharedSupport/bin/subl /usr/local/bin/subl
    fi

    # Create empty configuration folder
    mkdir -p "${SUBL_PKG_PATH}/Packages"
fi

if [[ $(util_getos) =~ ubuntu ]]; then
    SUBL_PKG_PATH="${HOME}/.config/sublime-text-3"
    p_arrow "Looking for installed sublime-text"
fi

if [[ ! -L ${SUBL_PKG_PATH}/Packages/User ]]; then
    p_arrow "Link Sublime Text 3 user settings folder"
    ln -s ${DOTFILES}/sublime/user "${SUBL_PKG_PATH}/Packages/User"
fi

if [[ ! -L ${SUBL_PKG_PATH}/Installed\ Packages ]]; then
    p_arrow "Link Sublime Text 3 user settings folder"
    ln -s ${DOTFILES}/sublime/packages "${SUBL_PKG_PATH}/Installed Packages"
fi

p_success "Done"