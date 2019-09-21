#!/usr/bin/env bash
DOTFILES="${HOME}/.dotfiles"
REPOS="${HOME}/.third-party-repos"
PATH="/usr/local/bin:${PATH}"

# Detect OS
function _util_isubuntu() {
  [[ "$(cat /etc/issue 2> /dev/null)" =~ Ubuntu ]] || return 1
}
function _util_isosx() {
  [[ "$OSTYPE" =~ ^darwin ]] || return 1
}
function util_getos() {
  for os in osx ubuntu; do
    _util_is${os}; [[ $? == ${1:-0} ]] && echo $os
  done
}

# Check if command exist
function check_command() {
    if [[ ! $(command -v $1) ]]; then
        if [[ -z $2 ]]; then
            echo $1
        else
            echo $2
        fi
    fi
}

# Install packages
function package_buildString() {
    pkg_string=""
    packages=("$@")
    for item in "${packages[@]}"; do
        if [[ ! -z $(check_command ${item}) ]]; then
            if [[ -z pkg_string ]]; then
                pkg_string="$(check_command ${item})"
            else
                pkg_string="${pkg_string} $(check_command ${item})"
            fi
        fi
    done
    echo ${pkg_string}
}

# Logging stuff.
function p_header()   { echo -e "\n\033[1m$@\033[0m"; }
function p_success()  { echo -e " \033[1;32m✔\033[0m  $@"; }
function p_error()    { echo -e " \033[1;31m✖\033[0m  $@"; }
function p_arrow()    { echo -e " \033[1;34m➜\033[0m  $@"; }

if [[ $(util_getos) =~ osx ]]; then
    # Install package manager for OS X
    if [[ ! $(command -v brew) ]]; then
        echo "\n\033[1mInstall Homebrew\033[0m"
        xcode-select --install
        ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    fi
    PMANAGER="brew"
    pkg_list=(git wget)
fi

if [[ $(util_getos) =~ ubuntu ]]; then
    PMANAGER="sudo apt"
    pkg_list=(git wget zsh)
fi

# Install essential tools
pkg_list=$(package_buildString ${pkg_list[@]})
if [[ ! -z ${pkg_list} ]]; then
    p_arrow "Install ${pkg_list}"
    ${PMANAGER} install ${pkg_list}
fi
git clone https://github.com/hftsai256/dotfiles.git ${DOTFILES}

# Clone Powerlevel9k theme for zsh
if [[ ! -d ${REPOS}/zsh/oh-my-zsh ]]; then
    p_arrow "Install oh-my-zsh"
    mkdir -p ${REPOS}/zsh
    git clone https://github.com/robbyrussell/oh-my-zsh.git ${REPOS}/zsh/oh-my-zsh
fi

if [[ ! -d ${REPOS}/zsh/themes/powerlevel9k ]]; then
    p_arrow "Install Powerlevel9k for zsh"
    mkdir -p ${REPOS}/zsh/themes
    git clone https://github.com/bhilburn/powerlevel9k.git ${REPOS}/zsh/themes/powerlevel9k
fi 

# Setting up shells
if [[ $(util_getos) =~ osx ]]; then
    # add customized zsh (if any) to safe harbor (OSX thing)
    p_header "Configuring zsh"
    if [[ ! $(grep $(which zsh) /etc/shells) ]]; then
        printf "$(which zsh)\n" | sudo tee -a /etc/shells
    fi
fi

# Link zshrc
if [[ ! -L ${HOME}/.zshrc ]]; then
    ln -s ${DOTFILES}/zsh/zshrc.zsh ${HOME}/.zshrc
fi

chsh -s $(which zsh)

p_success "Done, re-login to take effect"
