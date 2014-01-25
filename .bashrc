# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# don't put duplicate lines in the history. See bash(1) for more options
export HISTCONTROL=ignoredups
HISTFILE=~/.history/.history
HISTFILESIZE=100000
HISTSIZE=10000
export HISTTIMEFORMAT='%F %T '

# Set the xterm title to user@host:dir
# Red for root! 
who=`whoami`
if [[ $who =~ root ]]; then
	case "$TERM" in
		xterm*|rxvt*)
			PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME}: ${PWD/$HOME/~}\007"'
			PS1='${debian_chroot:+($debian_chroot)}\[\033[01;31m\]\u@\h\[\033[00m\]:\[\033[01;31m\]\w\[\033[00m\]\$ '
			;;
		*)
			;;
	esac
else
	case "$TERM" in
		xterm*|rxvt*)
			PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME}: ${PWD/$HOME/~}\007"'
			PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;36m\]\w\[\033[00m\]\$ '
			;;
		*)
			;;
	esac
fi

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
alias mtr='sudo /usr/local/sbin/mtr'
alias sudo='echo source /home/mmedeiros/.bashrc; sudo'
alias vim='vim -u /home/mmedeiros/.vimrc'
alias vimdiff='vimdiff -u /home/mmedeiros/.vimrc'
alias lockit='open -a /System/Library/Frameworks/ScreenSaver.framework/Versions/A/Resources/ScreenSaverEngine.app'

# Git for gits
alias gpp='clear && git pull origin && git push' 
alias gitlog='git log --oneline --color --graph --decorate'
alias punch='blame'
blame () { git blame $1 | less; }

# SSL syntax haxx
# Get general info 
sslcsr ()  { openssl req  -text -noout < $1; }
sslkey ()  { openssl rsa  -text -noout < $1; }
sslcert () { openssl x509 -text -noout < $1; }

# Get modulus 
modcsr ()  { openssl req  -noout -modulus < $1; }
modkey ()  { openssl rsa  -noout -modulus < $1; }
modcert () { openssl x509 -noout -modulus < $1; }

# Smarter SSL info fetcher
ssl () {
	line=$(head -n 1 $1)
	if   [[ $line =~ "CERTIFICATE REQUEST" ]]; then 
		openssl req  -text -noout < $1;
	elif [[ $line =~ CERTIFICATE ]] ; then 
		openssl x509 -text -noout < $1;
	elif [[ $line =~ KEY ]] ; then
		openssl rsa  -text -noout < $1; 
	else 
		echo "Sorry, $1 is not a valid ssl file"; 
	fi
	}

# Smarter SSL modulus 
sslmod () {
	line=$(head -n 1 $1)
	if   [[ $line =~ "CERTIFICATE REQUEST" ]]; then 
		openssl req  -modulus -noout < $1;
	elif [[ $line =~ CERTIFICATE ]] ; then 
		openssl x509 -modulus -noout < $1;
	elif [[ $line =~ KEY ]] ; then
		openssl rsa  -modulus -noout < $1; 
	else 
		echo "Sorry, $1 is not a valid ssl file"; 
	fi
}

vdie () { 
	`ps aux | grep -i [v]lc | awk '{print $2}' | xargs kill -9`;
}

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

getenv () {
  getfile=~/Documents/scripts/getenv;
  if [[ -a $getfile ]] 
  then
    sh $getfile | pbcopy; 
  else
    echo "getenv file does not exist!" 
  fi  
}

# grepped process list with header 
# shortcut for example "ps faux | head -n1 ; ps faux | grep -C1 [y]um"
pss () {
  unamestr=`uname`
  if [[ $unamestr =~ Darwin ]]; then
    echo "pss is currently for unix systems only, sorry"
  else
    word=$1
    if [ "$#" == "0" ] ; then 
      ps faux 
    else
      if [ "$#" == "2" ] ; then 
        if [[ $2 =~ ^-?[0-9]+$ ]] ; then 
          l=$2
        fi  
      else 
        l=5 
      fi  
      front=$(echo $word | cut -c 1,2)
      back=$(echo $word | cut -c 3-)
      str="[$front]$back"
      #echo "str = $str"
      ps faux | head -n1 ; ps faux | grep -C$l -i $str
    fi
  fi
}

# grep my history faster 
# shortcut for "history | grep $something | tail -n 10" 
hist () {
	if [ "$#" == "0" ] ; then 
		history 
	else
		history | grep -i $1 | tail
	fi
}

# Launch browsers from command line with some syntax checks
# Google Chrome 
chrm () {
	if [[ "$1" =~ https?:// ]] ; then
		open -a /Applications/Google\ Chrome.app $1;
	else
		if [[ "$1" =~ "." ]] ; then
			open -a /Applications/Google\ Chrome.app http://$1;
		else 
			open -a /Applications/Google\ Chrome.app http://$1.com;
		fi
	fi
}

# Mozilla Firefox
fox () {
	if [[ "$1" =~ https?:// ]] ; then
		open -a /Applications/Firefox.app $1;
	else
		if [[ "$1" =~ "." ]] ; then
			open -a /Applications/Firefox.app http://$1;
		else 
			open -a /Applications/Firefox.app http://$1.com;
		fi
	fi
}

# Print out the yyyymmdd datestamp for today 
alias datestamp='echo $(date +%Y%m%d)'

# Some ls aliases
# mac is annoying with --color

platform='unknown'
unamestr=`uname`
if [[ "$unamestr" =~ Darwin ]]; then
	platform='mac'
elif [[ "$unamestr" =~ Linux ]]; then
	platform='linux'
fi

if [[ $platform == 'mac' ]]; then
  alias ls='ls -G'
  alias ll='clear; ls -l'
  alias la='ls -Al'
elif [[ $platform == 'linux' ]]; then
  alias ls='ls --color=auto'
  alias ll='clear; ls -l'
  alias la='ls -Al'
  alias df='df -P | column -t'
fi

# Typos are annoying 
alias grpe='grep' 
alias gerp='grep'
alias clera='clear'
alias clar='clear'
alias clesr='clear'
alias claer='clear'
alias clea='clear'
alias cler='clear'
alias vmi='vim'
alias ehad='head'
alias cl='clear'

# Places to go, things to see 
alias ma01='ssh mmedeiros@ops-screendoor01.ma01.shuttercorp.net'
alias nyc01='ssh mmedeiros@ops-screendoor01.nyc01.shuttercorp.net'


PATH=$PATH:$HOME/.rvm/bin # Add RVM to PATH for scripting
