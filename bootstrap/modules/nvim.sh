#!/usr/bin/env bash
source ${DOTFILES}/bootstrap/utility.sh
p_header "Configure Neovim"

if [[ $(util_getos) =~ osx ]]; then
    NVIM_CFG_PATH="${HOME}/.config/nvim"
    p_arrow "Looking for installed neovim"

    # Check if neovim has been installed under /usr/local/bin
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
        sudo pip3 install -qqq pynvim
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

    # Check if neovim has been installed
	which nvim > /dev/null 2>&1 || sudo apt install -y neovim
	which nvim-qt > /dev/null 2>&1 || sudo apt install -y neovim-qt 
	which vimr > /dev/null 2>&1 || sudo ln -s /usr/bin/nvim-qt /usr/bin/vimr

	# Install python3 neovim support package
	which pip3 > /dev/null 2>&1 && sudo pip3 -H install -qqq pynvim

	# Install node.js for neovim
	curl -sL https://deb.nodesource.com/setup_14.x | sudo -E bash -
	sudo apt-get install -y nodejs
	sudo npm install -g neovim
fi

p_success "Done"
