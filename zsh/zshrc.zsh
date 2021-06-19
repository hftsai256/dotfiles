# If you come from bash you might have to change your $PATH.
export DOTFILES="${HOME}/.dotfiles"
export REPOS="${HOME}/.third-party-repos"
export PATH="${PATH}:${DOTFILES}/bin"

# Oh-my-zsh Path
export ZSH="${REPOS}/zsh/oh-my-zsh"
plugins=(git)
source ${ZSH}/oh-my-zsh.sh

# ZSH Theme Configuration
source ${REPOS}/zsh/themes/powerlevel10k/powerlevel10k.zsh-theme
source ${DOTFILES}/zsh/powerlevel9k.sh

# Preferred editor for local and remote sessions
export EDITOR='nvim'
export CSCOPE_EDITOR='nvim'

# Compilation flags
# export ARCHFLAGS='-arch x86_64'

# Personal Aliases
alias py='python'
alias vim='nvim'
alias jnb='jupyter notebook'
alias ipy='ipython'
alias ls='ls --color=auto'

# Language Definitions
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

# Load All Customized Scripts
source ${DOTFILES}/init/init.sh
