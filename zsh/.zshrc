export ZSH="$HOME/.oh-my-zsh"

# zsh-autosuggestions: Disable suggestions for big buffers (essential for pasting)
export ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=32

# zsh-autosuggestions: Disable suggestions asynchronously (don't lock the keyboard)
export ZSH_AUTOSUGGEST_USE_ASYNC=true

# zsh-autosuggestions: Forces the plugin to ignore "bracketed paste" events
zstyle ':bracketed-paste-magic' active-widgets '.self-*'

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
