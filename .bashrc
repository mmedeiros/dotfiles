# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# don't put duplicate lines in the history. See bash(1) for more options
export HISTCONTROL=ignoredups
HISTFILE=~/.history/.history
HISTFILESIZE=10000
HISTSIZE=10000
export HISTTIMEFORMAT='%F %T '

# Set the xterm title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME}: ${PWD/$HOME/~}\007"'
     PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;36m\]\w\[\033[00m\]\$ '
    #PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
    ;;
*)
    ;;
esac

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(lesspipe)"

############################
##        Todo.txt        ##
############################

# access ToDo from anywhere 
PATH=$PATH:/Applications/todo.sh/

# Avoid typing todo.sh every time. 
alias t='clear; todo.sh -d /Users/matt/.todo'
alias dohome='t list | grep -v @cheet|grep -v @stall|grep -v @project|grep -v @band'
alias band='t list | grep @band'

############################
## Welcome to Aliastown!! ##
############################

# So little time, so much todo 
alias ctodo='cd /Users/matt/Documents/CM/!!todo/; vim *todo.txt'
alias follow='cd /Users/matt/Documents/CM/!!todo; vim -o followup.txt work_done.txt'

# Band Stuff 
alias kdo='cd /Users/matt/Documents/band\ stuff/kalopsia/demo_web'


# Hack Utils 
alias finf='find . 2> /dev/null |  xargs grep -li 2>/dev/null'
alias toobig='find * ! -type l -ls | sort -k 7nr'

# Git for gits
alias gpp='clear && git pull origin && git push' 
alias gitlog='git log --oneline --color --graph --decorate'
alias punch='git blame'

# SSL syntax haxx
# Get general info 
sslcsr ()  { openssl req  -text -noout < $1; }
sslkey ()  { openssl rsa  -text -noout < $1; }
sslcert () { openssl x509 -text -noout < $1; }

# Get modulus 
modcsr ()  { openssl req  -noout -modulus < $1; }
modkey ()  { openssl rsa  -noout -modulus < $1; }
modcert () { openssl x509 -noout -modulus < $1; }

# Tar syntax is a pain in the ass 
alias untar='tar -xvzf '

mktar () {
  dir=$1;
  if [[ $dir != "" ]]
  then
    tar cfvz $dir.tgz $dir;
  else
    echo "no specified file or directory for tar ($dir)"
  fi  
}

# Some ls aliases
alias ls='ls -G'
alias ll='ls -l'
alias la='ls -A'
#alias l='ls -CF'

# Places to go, things to see 
alias ma01='ssh mmedeiros@ops-screendoor01.ma01.shuttercorp.net'
alias nyc01='ssh mmedeiros@ops-screendoor01.nyc01.shuttercorp.net'
