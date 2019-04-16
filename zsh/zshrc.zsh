# If you come from bash you might have to change your $PATH.
export DOTFILES=${HOME}/.dotfiles
export PATH="${HOME}/bin:${DOTFILES}/bin:/usr/local/bin:${PATH}"

# Oh-my-zsh Path
export ZSH="${HOME}/.oh-my-zsh"
plugins=(git)
source ${ZSH}/oh-my-zsh.sh

# ZSH Theme Configuration
POWERLEVEL9K_MODE='nerdfont-complete'
source /usr/local/opt/powerlevel9k/powerlevel9k.zsh-theme
source ${DOTFILES}/zsh/powerlevel9k.sh

# Preferred editor for local and remote sessions
export EDITOR='subl'

# Compilation flags
# export ARCHFLAGS='-arch x86_64'

# ssh
export SSH_KEY_PATH='~/.ssh'

# Personal Aliases
alias py='python3'
alias py2='python2'
alias py3='python3'
alias jnb='jupyter notebook'
alias ipy='ipython'

# Language Definitions
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

# Load All Customized Scripts
for f in ${DOTFILES}/scripts/*.sh; do
    source $f;
done