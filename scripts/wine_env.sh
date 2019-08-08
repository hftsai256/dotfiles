# Must be sourced from shell for obvious reason
WINENV_PATH=${WINENV_PATH:-${DOTFILES}/wine}
declare -a WINENV_ALLENV

winenv() {
    local WINENV_NAME;
    local WINENV_ARCH;
    if [[ $# -eq 0 ]]; then
        winenv_help
        return -1
    fi

    while getopts :ha:c:dl opt; do
        case $1 in
            -h)
                winenv_help
                break
                ;;
            -c)
                WINENV_NAME=$2
                WINENV_ARCH=$3
                winenv_create
                break
                ;;
            -l)
                winenv_list
                break
                ;;
            -s)
                WINENV_NAME=$2
                winenv_set
                break
                ;;
            --) # End argument parsing
                shift
                break
                ;;
            -*) # Unsupported arguments
                printf "Error: Unsupported argument: $1\n" >&2
                winenv_help
                ;;
        esac
    done
}

winenv_help() {
    printf "Wine Virtual Environment Utility (for version > 3.7.1)\n"
    printf "Usage: winenv [-a name] [-c name [arch]] [-d] [-l] [-h]\n"
    printf "\n"
    printf "Arguments:\n"
    printf "  -c  Create a new wine environment"
    printf "  -l  List installed virtual environment under WINENV_PATH\n"
    printf "  -s  Set wine environment variables"
    printf "  -h  Print this help\n"
}

winenv_create() {
    if [[ "${WINENV_ARCH}" -eq "win32" || "${WINENV_ARCH}" -eq "32" ]]; then
        printf "Win32 architecture specified\n"
        WINENV_ARCH="win32"
    else
        printf "Win32 architecture not specified. Using \"win64\" as default\n"
        WINENV_ARCH="win64"
    fi

    if [[ -z "$WINENV_NAME" ]]; then
        printf "Wine prefix name not specified. Using \"wine\" as default\n"
        WINENV_NAME="wine"
    fi

    printf "Wine prefix set to \"${WINENV_PATH}/${WINENV_NAME}_${WINENV_ARCH}\" with architecture \"${WINENV_ARCH}\"\n"

    export WINEARCH=${WINENV_ARCH}
    export WINEPREFIX=${WINENV_PATH}/${WINENV_NAME}_${WINENV_ARCH}

    mkdir -p ${WINENV_PATH}/${WINENV_NAME}_${WINENV_ARCH}

    wineboot -u
}

winenv_set() {
    re_is_number='^[0-9]+$'
    winenv_list

    if [[ ${WINENV_NAME} -eq 0 || -z "${WINENV_NAME}" ]]; then
        printf "Selecting first virtual environment by default\n"
        WINENV_NAME=1
    fi

    if [[ ${WINENV_NAME} =~ ${re_is_number} ]]; then
        WINENV_NAME=${WINENV_ALLENV[${WINENV_NAME}]}
    fi

    WINENV_ARCH=$(echo ${WINENV_NAME} | cut -d _ -f 2)
    WINENV_NAME=$(echo ${WINENV_NAME} | cut -d _ -f 1)
    printf "Selecting wine environment: %s\nEnvironment architecture: %s\n" ${WINENV_NAME} ${WINENV_ARCH}
    
    export WINEPREFIX=${WINENV_PATH}/${WINENV_NAME}_${WINENV_ARCH}
    export WINEARCH=${WINENV_ARCH}
}

winenv_list() {
    local winenv_count; winenv_count=1;
    winenv_getAllEnv;
    if [[ ${#WINENV_ALLENV[@]} -eq 0 ]]; then
        printf "Cannot find installed wine environment under: %s\n" ${WINENV_PATH}
        return 0
    else
        printf "Available wine environments under: %s\n" ${WINENV_PATH}
        for n in ${WINENV_ALLENV}; do
            printf "  %2d) %s\n" ${winenv_count} ${n}
            winenv_count=$((${winenv_count} + 1))
        done
    fi
}

winenv_getAllEnv() {
    WINENV_ALLENV=()
    for f in ${WINENV_PATH}/*/; do
        if [[ -d ${f}/drive_c ]]; then
            WINENV_ALLENV+=$(print ${f} | awk -F/ '{print $(NF-1)}')
        fi
    done
}