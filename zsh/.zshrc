export ZSH="$HOME/.oh-my-zsh"

# ZSH_THEME="robbyrussell"
ZSH_THEME=""

plugins=(git zsh-autosuggestions zsh-syntax-highlighting fast-syntax-highlighting zsh-autocomplete)

source $ZSH/oh-my-zsh.sh

# aliases
alias ag='antigravity'

# brew
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

# oh-my-posh
eval "$(oh-my-posh init zsh --config ~/.oh-my-posh/amro-monokai-metallian.omp.json)"
