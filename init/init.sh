function include () {
    [[ -d "$1" ]] || return 0

    for file in $1/*.sh; do
        [[ -e "$file" ]] || continue
        source "$file"
    done
}

# Load Common Init Scripts
include ${DOTFILES}/init/common
include ${DOTFILES}/init/secret


# Load OSX-only Init Scripts
if [[ "$OSTYPE" =~ ^darwin ]]; then
	include ${DOTFILES}/init/osx
fi

# Load Debian based Init Scripts
if which apt-get 2>&1 > /dev/null; then
	include ${DOTFILES}/init/debian
fi

