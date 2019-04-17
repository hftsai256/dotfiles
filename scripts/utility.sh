# Utility functions

# OS detection
function is_ubuntu() {
    if [[ "$(cat /etc/issue 2> /dev/null)" =~ Ubuntu ]]; then
        echo 0
    else
        echo 1
    fi
}
function is_osx() {
    if [[ "$OSTYPE" =~ ^darwin ]]; then
        echo 0
    else
        echo 1
    fi
}

# Logging stuff.
function p_header()   { echo -e "\n\033[1m$@\033[0m"; }
function p_success()  { echo -e " \033[1;32m✔\033[0m  $@"; }
function p_error()    { echo -e " \033[1;31m✖\033[0m  $@"; }
function p_arrow()    { echo -e " \033[1;34m➜\033[0m  $@"; }