# Must be sourced from shell for obvious reason

export PYVENV_PATH=${PYVENV_PATH:-$HOME/.config/pyvenv}

pyenv() {
    if [[ $# -eq 0 ]]; then
        pyenv_help
        return -1
    fi

    while getopts :ha:c:dl opt; do
        case $1 in
            -h)
                pyenv_help
                break
                ;;
            -a)
                PYVENV_NAME=$2
                pyenv_activate
                break
                ;;
            -c)
                PYVENV_NAME=$2
                pyenv_create
                break
                ;;
            -d)
                pyenv_deactivate
                break
                ;;
            -l)
                pyenv_list
                break
                ;;
            --) # End argument parsing
                shift
                break
                ;;
            -*) # Unsupported arguments
                printf "Error: Unsupported argument: $1\n" >&2
                pyenv_help
                ;;
        esac
    done
}

pyenv_help() {
    printf "Python Virtual Environment Utility (for version > 3.7.1)\n"
    printf "Usage: pyenv [-a name] [-c name] [-d] [-l] [-h]\n"
    printf "\n"
    printf "Arguments:\n"
    printf "  -a  Activate virtual environment (Default)\n"
    printf "  -c  Create virtual environment\n"
    printf "  -d  Deactivate environment, shorthand of \"deactivate\"\n"
    printf "  -l  List installed virtual environment under PYVENV_PATH\n"
    printf "  -h  Print this help\n"
}

pyenv_activate() {
    source ${PYVENV_PATH}/${PYVENV_NAME}/bin/activate
}

pyenv_deactivate(){
    deactivate
}

pyenv_create() {
    mkdir -p ${PYVENV_PATH}
    python3 -m virtualenv ${PYVENV_PATH}/${PYVENV_NAME}
}

pyenv_list() {
    find ${PYVENV_PATH} -name "activate" -exec dirname {} \;
}