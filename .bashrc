#!/bin/bash

# If not running interactively, don't do anything.
[ -z "$PS1" ] && return

# Don't keep duplicate lines or lines starting with space in the history.
HISTCONTROL=ignoreboth
# Append to the history file, don't overwrite it.
shopt -s histappend

# Set the maximum history size and filesize.
HISTSIZE=1000
HISTFILESIZE=2000
HISTTIMEFORMAT="%h %d %H:%M:%S "

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# Make less more friendly for non-text input files, like binary.
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# Set a color prompt if the terminal supports it.
echo "$TERM" | grep -qi 'color' && color_prompt=yes

# Set a default PS1 and PS2 without colour.
PS1='\u@\h:\w\$ '
PS2=' > '

if [ "$color_prompt" = yes ]; then
  if [ -f "/usr/share/git/completion/git-prompt.sh" ]; then
    # shellcheck source=/dev/null
    source /usr/share/git/completion/git-prompt.sh
  fi

  # Fedora
  if [ -f "/usr/share/git-core/contrib/completion/git-prompt.sh" ]; then
    # shellcheck source=/dev/null
    source /usr/share/git-core/contrib/completion/git-prompt.sh
  fi

  PS2="\[\e[1;103m\]  \[\e[33;49m\] \[\e[0m\]"

  choose_ps1() {
    if [ "$(whoami)" == "root" ]; then
      PS1="\[\e[1;31m\]\u@\h\[\e[0m\]:\[\e[1;35m\]\w\[\e[0m\] # "
      return
    fi

    PS1="\[\033[1;97;104m\] \$PWD \[\033[0;94m\]\[\033[0m\]"

    if [ "$(git rev-parse --is-inside-work-tree 2>/dev/null)" ]; then
      PS1="\[\033[1;97;104m\] \$PWD \[\033[0;94;100m\] \[\033[97m\]\$(__git_ps1 | tail -c +3 | head -c -1) \[\033[49;90m\]"
    fi

    PS1="$PS1\n\[\033[0;97;100m\] \A \[\033[90;102m\] \[\033[1;30m\]\u@\h \[\033[32;49m\]\[\033[0m\] "
  }

  PROMPT_COMMAND="choose_ps1"

  # enable coloured ls and grep output.
  if [ -x /usr/bin/dircolors ]; then
    ( test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" ) || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias diff='diff --color'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
  fi
fi
unset color_prompt force_color_prompt

# Enable Bash completion.
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    # shellcheck source=/dev/null
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    # shellcheck source=/dev/null
    . /etc/bash_completion
  fi
fi

# Custom aliases
alias sshrc='sshrc -X'

alias sshtest='sshrc webdev@test.appno.nl'
alias sshtestroot='sshrc root@test.appno.nl'
alias sshhtest='sshrc webdev@htest.appno.nl'
alias sshhtestroot='sshrc root@htest.appno.nl'
alias sshacc='sshrc webdev@acc.appno.nl'
alias sshaccroot='sshrc root@acc.appno.nl'
alias sshhacc='sshrc webdev@hacc.appno.nl'
alias sshhaccroot='sshrc root@hacc.appno.nl'
alias sshacc01='sshrc webdev@acc01.appno.nl'
alias sshweb01='sshrc webdev@web01.appno.nl'
alias sshweb02='sshrc webdev@web02.appno.nl'
alias sshweb03='sshrc webdev@web03.appno.nl'
alias sshweb04='sshrc webdev@web04.appno.nl'
alias sshweb05='sshrc webdev@web05.appno.nl'
alias sshbu='sshrc webdev@bu.appno.nl'
alias sshgcd='sshrc webdev@gcd-production.wonderkruid.nl'
alias sshqlip='sshrc root@qlip.koekompas.nl'
alias sshcono='sshrc ssh://veehoudercono@cheese.nux.ntfm.nl:522'
alias sshwood='sshrc webdev@woodwing01.appno.nl'
alias sshwoodroot='sshrc root@woodwing01.appno.nl'
alias sshzwijsen='sshrc root@zwijsen-prod.appno.nl'
alias sshictu='sshrc ictu@ictu-web-p01.sc.nines.nl'
alias sshwooly='sshrc woolyyg250@woolytoons.com'
alias sshcertbot='sshrc debian@certbot.appno.nl'
alias sshcertroot='sshrc root@certbot.appno.nl'
alias sshvpn='sshrc root@vpn.appno.nl'
alias sshmatrix='sshrc root@matrix.dobefu.eu'
alias sshnextcloud='sshrc root@nextcloud.dobefu.eu'
alias sshgroenlinks='sshrc wunderkraut@gl-web01.nextpertise.nl'
alias sshtest2='sshrc root@htest.appno.nl'
alias sshacc2='sshrc root@hacc.appno.nl'
alias sshhetzner="sshrc dobefu@176.9.7.113"
alias sshhetzroot="sshrc root@176.9.7.113"
alias sshclockpi="sshrc pi@clockpi.local"

alias lll='lsd -lah | less'
alias ll='lsd -lah'
alias la='lsd -A'
alias l='lsd -F'
alias glog='git log --graph --pretty="format:%C(yellow)%h%Cred%d%Creset %s %C(white) %C(cyan)%an%Creset, %C(green)%ar%Creset"'
alias fucking='sudo'
alias c='clear && source $HOME/.bashrc'
alias :q='exit'
alias ..='cd ..'

alias copy='xclip -selection clipboard'
alias vi='nvim'
alias vim='nvim'
alias iv='nvim'
alias nvimrc='nvim ~/.config/nvim/init.vim'

# Docker related aliases.
alias initdocker='git clone git@bitbucket.org:wknl/docker.git'
alias dockerlocalup='pushd $HOME/Docker/docker-local-stack && make up ; popd'
alias dockerlocaldown='pushd $HOME/Docker/docker-local-stack && make down ; popd'

# Add directories to the PATH.
export PATH="$HOME/.config/composer/vendor/bin:$PATH"
export PATH="$HOME/.gem/ruby/2.6.0/bin/:$PATH"

# Set language variables.
export EDITOR="/usr/bin/neovim"
export LC_ALL="en_US.UTF-8"
export LANG="en_US.UTF-8"
export LANGUAGE="en_US.UTF-8"

export TERMINFO=/usr/lib/terminfo

# Load NVM
NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
export NVM_DIR
# shellcheck source=/dev/null
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" --no-use

if xhost >& /dev/null; then
  export DISPLAY=:0
fi

# Greet the user when a terminal opens.
if [ -f "$HOME/bin/motd" ]; then
  "$HOME"/bin/motd
fi
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
