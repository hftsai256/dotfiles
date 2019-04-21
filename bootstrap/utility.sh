# Utility functions

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
            pkg_string="${pkg_string} $(check_command ${item})"
        fi
    done
    echo ${pkg_string}
}

# Logging stuff.
function p_header()   { echo -e "\n\033[1m$@\033[0m"; }
function p_success()  { echo -e " \033[1;32m✔\033[0m  $@"; }
function p_error()    { echo -e " \033[1;31m✖\033[0m  $@"; }
function p_arrow()    { echo -e " \033[1;34m➜\033[0m  $@"; }