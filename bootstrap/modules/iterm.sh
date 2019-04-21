#!/usr/bin/env bash
source ${DOTFILES}/bootstrap/utility.sh
p_header "Configure iTerm"

if [[ $(util_getos) =~ osx ]]; then
    p_arrow "Looking for installed sublime text under /Application/iTerm"

    # Check if iterm has been installed
    if [[ ! -d /Applications/iTerm.app ]]; then
        p_arrow "Install iTerm with Homebrew"
        brew cask install iterm2
    fi

    p_arrow "Setting up customization plist"
    # Specify the preferences directory
    defaults write com.googlecode.iterm2.plist PrefsCustomFolder -string "${DOTFILES}/iterm"
    # Tell iTerm2 to use the custom preferences in the directory
    defaults write com.googlecode.iterm2.plist LoadPrefsFromCustomFolder -bool true

    p_success "Done"

else
    p_error "iTerm is not available on this platform"

fi
