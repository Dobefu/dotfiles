# Custom aliases.
alias lll='ls -lah | less'
alias ll='ls -lah'
alias la='ls -A'
alias l='ls -CF'
alias sc='sudo systemctl'
alias glog='git log --graph --pretty="format:%C(yellow)%h%Cred%d%Creset %s %C(white) %C(cyan)%an%Creset, %C(green)%ar%Creset"'
alias c='reset -Q && source $HOME/.bashrc'
alias :q='exit'
alias ..='cd ..'

alias vi='vim'
alias mutt='neomutt'

# Set variables.
export PATH="$HOME/.config/composer/vendor/bin:$PATH"
export PATH="$HOME/.npm-global/bin:$PATH"
export EDITOR="/usr/bin/vim"
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

if xhost >& /dev/null; then
  export DISPLAY=:0
fi

if [ "$(tty)" == "/dev/tty1" ]; then
  startx 2&>1 > /dev/null
  return
fi

# Greet the user when a terminal opens.
$HOME/bin/motd
