# If you come from bash you might have to change your $PATH.
export DOTFILES="${HOME}/.dotfiles"
export REPOS="${HOME}/.third-party-repos"
export PATH="${PATH}:${HOME}/bin:${DOTFILES}/bin:/usr/local/bin:/usr/local/opt/binutils/bin"
export PATH="${PATH}:/opt/gcc-arm-none-eabi/gcc-arm-none-eabi/bin"
export PATH="${PATH}:${HOME}/.hacky/bin"

# SEGGER
export PATH="Applications/SEGGER/JLink:${PATH}"

# Prioritize XCode Tools
# export PATH="/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin:${PATH}"

# Oh-my-zsh Path
export ZSH="${REPOS}/zsh/oh-my-zsh"
plugins=(git)
source ${ZSH}/oh-my-zsh.sh

# ZSH Theme Configuration
source ${REPOS}/zsh/themes/powerlevel9k/powerlevel9k.zsh-theme
source ${DOTFILES}/zsh/powerlevel9k.sh

# Preferred editor for local and remote sessions
export EDITOR='nvim'

# Compilation flags
# export ARCHFLAGS='-arch x86_64'

# ssh
export SSH_KEY_PATH='~/.ssh'

# Personal Aliases
alias vim='nvim'
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
