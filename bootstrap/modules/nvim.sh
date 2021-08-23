#!/usr/bin/env bash
silence='>/dev/null 2>&1'

function npminstall() {
    npm list -g | grep $1 $silence || sudo npm install -g $1 
}

function pipinstall() {
    pip3 list | grep $1 $silence || pip3 install $1
}

source ${DOTFILES}/bootstrap/utility.sh

p_header "Configure Neovim"


if [[ $(util_getos) =~ osx ]]; then
    NVIM_CFG_PATH="${HOME}/.config/nvim"
    p_arrow "Looking for installed neovim"

    # Check if neovim has been installed under /usr/local/bin
    if ! $(which nvim) >/dev/null 2>&1; then
        p_arrow "Install neovim with Homebrew"
        brew install neovim
    fi

    if [[ ! -d /Applications/VimR.app ]]; then
        p_arrow "Install VimR with Homebrew"
        brew install vimr
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
		npminstall neovim
    fi

    # Install Ruby neovim support package
    sudo gem install neovim

    # Install language servers
    if ! $(which ccls) >/dev/null 2>&1; then
        p_arrow "Install ccls with Homebrew"
        brew install ccls
    fi

fi

if [[ $(util_getos) =~ ubuntu ]]; then
    NVIM_CFG_PATH="${HOME}/.config/nvim"
    p_arrow "Looking for installed neovim"

    # Check if neovim has been installed
    p_arrow "Install neovim"
	which nvim > /dev/null 2>&1 || sudo apt install -y neovim

    # ccls language server
    p_arrow "Install ccls language server"
    which ccls > /dev/null 2>&1 || sudo apt install -y ccls

	# Install python3 neovim support package
    p_arrow "Install pynvim"
	which pip3 > /dev/null 2>&1 && sudo pip3 -H install -qqq pynvim

	# Install node.js for neovim
    p_arrow "Install neovim helper on nodejs"
	curl -sL https://deb.nodesource.com/setup_14.x | sudo -E bash -
	sudo apt-get install -y nodejs
	npminstall neovim

    # Install pyright language server
    p_arrow "Install pyright language server on nodejs"
    npminstall pyright

    # Install bash language server
    p_arrow "Install bash language server on nodejs"
    npminstall bash-language-server

    # Install cmake language server
    p_arrow "Install cmake language server on pipy"
    pipinstall cmake-language-server
fi

# Simlink neovim configuration folder
if [[ ! -L ${NVIM_CFG_PATH} ]]; then
    p_arrow "Link neovim config folder"
    mkdir -p ${HOME}/.dotfiles
    ln -s ${HOME}/.dotfiles/nvim ${NVIM_CFG_PATH}
fi

p_success "Done"

