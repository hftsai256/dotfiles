#!/usr/bin/env bash
source ${DOTFILES}/bootstrap/utility.sh

p_header "Install FiraCode"

# Install for OSX
if [[ $(util_getos) =~ osx ]] ; then
    # User Prompt
    p_arrow "Mac OS X Detected"
    # Create temporary folder
    mkdir -p ${DOTFILES}/temp_FiraCode
    pushd ${DOTFILES}/temp_FiraCode > /dev/null

    # Download latest release of FiraCode from Github
    url=$(curl -s https://api.github.com/repos/tonsky/FiraCode/releases/latest \
        | grep "browser_download_url" \
        | cut -d'"' -f4)
    p_arrow "Download latest release from:"
    printf  "        %s\n" ${url}
    wget -q ${url}

    # Extract archive and enter folder
    find . -name "*.zip" -exec unzip -q {} \;

    # Install to local machine path
    p_arrow "Install to /Library/Fonts"
    mv otf/*.otf /Library/Fonts

    # Clean up
    p_arrow "Clean up temporary files"
    popd > /dev/null; rm -rf ${DOTFILES}/temp_FiraCode

    p_success "Done"
fi

# Install for Ubuntu
if [[ $(util_getos) =~ ubuntu ]]; then
    p_arrow "Ubuntu detected"
    p_arrow "Install with apt-get (package fonts-firacode)"
    sudo apt install fonts-firacode
    p_success "Done"
fi
