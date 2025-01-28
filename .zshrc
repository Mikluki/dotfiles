# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="robbyrussell"

plugins=(
  git
  zsh-autosuggestions
  zsh-syntax-highlighting
)
bindkey '^ I'   complete-word         # tab          | complete

source $ZSH/oh-my-zsh.sh
### HISTORY SETTINGS
#set history size
export HISTSIZE=10000
#save history after logout
export SAVEHIST=10000
#history file
export HISTFILE=~/.zhistory
#append into history file
setopt INC_APPEND_HISTORY
#save only one command if 2 common are same and consistent
setopt HIST_IGNORE_DUPS
#add timestamp for each entry
setopt EXTENDED_HISTORY   

### KEYMAPS
# Define a custom widget to repeat the last command
repeat_last_command() {
  BUFFER=$(fc -ln -1)  # Get the last command from history
  zle accept-line      # Execute the command in the buffer
}
zle -N repeat_last_command

# Bind the widget to Ctrl+Enter
bindkey '^[[24~' repeat_last_command


### SHORTCUTS ###
alias v=nvim
alias cl=clear

# bashrc 
alias ebash='v $HOME/.bashrc'
alias rbash='source $HOME/.bashrc'
alias cl='clear'
# ezshrc
alias ezsh='v $HOME/.zshrc'
alias rzsh='source $HOME/.zshrc'

### LSD setup ###
alias ls='lsd'
alias l='ls -l'
alias la='ls -a'
alias lla='ls -la'
alias lt='ls --tree'


### PATHS ### 
export PATH=$HOME/.local/bin:$PATH 
 
export EDITOR='/usr/bin/nvim' 
export VISUAL='/usr/bin/nvim'

### YAZI ###
function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	yazi "$@" --cwd-file="$tmp"
	if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
		builtin cd -- "$cwd"
	fi
	rm -f -- "$tmp"
}


[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
eval "$(zoxide init zsh)"

