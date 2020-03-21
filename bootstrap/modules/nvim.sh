#!/usr/bin/env bash
source ${DOTFILES}/bootstrap/utility.sh
p_header "Configure Neovim"

if [[ $(util_getos) =~ osx ]]; then
    NVIM_CFG_PATH="${HOME}/.config/nvim"
    p_arrow "Looking for installed neovim"

    # Check if sublime has been installed under /usr/local/bin
    if [[ ! -f /usr/local/bin/nvim ]]; then
        p_arrow "Install neovim with Homebrew"
        brew install neovim
    fi

    if [[ ! -d /Applications/VimR.app ]]; then
        p_arrow "Install VimR with Homebrew"
        brew cask install vimr
    fi

    # Install python 3 neovim support package
    if $(command -v pip3 >/dev/null 2>&1 ); then
        p_arrow "Install neovim python packages"
        sudo pip3 install -qqq neovim
    fi

    # Install Node.js and neovim support package
    if $(command -v node >/dev/null 2>&1 ); then
    	p_arrow "Install node.js"
    	brew install node
		npm install -g neovim
    fi

    # Install Ruby neovim support package
    sudo gem install neovim

    # Simlink neovim configuration folder
    if [[ ! -L ${NVIM_CFG_PATH} ]]; then
        p_arrow "Link neovim config folder"
        ln -s ${HOME}/.dotfiles/nvim ${NVIM_CFG_PATH}
    fi
fi

if [[ $(util_getos) =~ ubuntu ]]; then
    NVIM_CFG_PATH="${HOME}/.config/nvim"
    p_arrow "Looking for installed neovim"
fi

p_success "Done"
