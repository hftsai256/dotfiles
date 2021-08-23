# Load Common Init Scripts
for f in ${DOTFILES}/init/common/*.sh; do
    source $f;
done

# Load Identity Sensitive Scripts
if compgen -G "${DOTFILES}/init/secret/*.sh" > /dev/null; then
	for f in ${DOTFILES}/init/secret/*.sh; do
    	source $f;
	done
fi

# Load OSX-only Init Scripts
if [[ "$OSTYPE" =~ ^darwin ]]; then
	for f in ${DOTFILES}/init/osx/*.sh; do
		source $f
	done
fi

# Load Debian based Init Scripts
if which apt-get 2>&1 > /dev/null; then
	for f in ${DOTFILES}/init/debian/*.sh; do
		source $f
	done
fi

