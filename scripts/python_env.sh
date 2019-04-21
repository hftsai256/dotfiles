# Must be sourced from shell for obvious reason

PYVENV_PATH=${PYVENV_PATH:-${DOTFILES}/pyvenv}
declare -a PYVENV_ALLENV

pyenv() {
    local PYVENV_NAME;
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
    re_is_number='^[0-9]+$'
    pyenv_list

    if [[ ${PYVENV_NAME} -eq 0 || -z "${PYVENV_NAME}" ]]; then
        printf "Selecting first virtual environment by default\n"
        PYVENV_NAME=1
    fi

    if [[ ${PYVENV_NAME} =~ ${re_is_number} ]]; then
        PYVENV_NAME=${PYVENV_ALLENV[${PYVENV_NAME}]}
    fi
    printf "Activate virtual environment: %s\n" ${PYVENV_NAME}
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
    local pyenv_count; pyenv_count=1;
    pyenv_getAllEnv;
    if [[ ${#PYVENV_ALLENV[@]} -eq 0 ]]; then
        printf "Cannot find installed Python environment under: %s\n" ${PYVENV_PATH}
        return 0
    else
        printf "Available Python environments under: %s\n" ${PYVENV_PATH}
        for n in ${PYVENV_ALLENV}; do
            printf "  %2d) %s\n" ${pyenv_count} ${n}
            pyenv_count=$((${pyenv_count} + 1))
        done
    fi
}

pyenv_getAllEnv() {
    PYVENV_ALLENV=()
    for f in ${PYVENV_PATH}/*/; do
        if [[ ${f}bin/activate ]]; then
            PYVENV_ALLENV+=$(print ${f} | awk -F/ '{print $(NF-1)}')
        fi
    done
}
