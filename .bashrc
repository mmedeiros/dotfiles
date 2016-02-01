# ~/.bashrc: executed by bash(1) for non-login shells.
# This is my .bashrc file, there are many like it, but this one is mine.
#
# My .bashrc file is my best friend. It is my life.
# I must master it as I must master my life.
#
# Without me my .bashrc file is useless.
# Without my .bashrc file, I am (practically) useless.
#
# I must source my .bashrc file true.
# I must debug my system, who is trying to bug me.
# I will...

# Sometimes I'm not me. Make my homedir available always:

if [ -d "/home/mmedeiros"  ]; then
  MMEDEIROS_HOME=/home/mmedeiros
elif [ -d "/home/matt.m"  ]; then
  MMEDEIROS_HOME=/home/matt.m
elif [ -d "/home/matt"  ]; then
  MMEDEIROS_HOME=/home/matt
else
  MMEDEIROS_HOME=$HOME
fi

# Get all that good env stuff
for f in $MMEDEIROS_HOME/.bash_includes/*; do source $f; done

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# Prompt colors:
PINK=$'\e[1;35m'
GREEN=$'\e[1;32m'
WHITE=$'\e[0;37m'
CYAN=$'\e[1;36m'
RED=$'\e[1;31m'

# Set the xterm title to user@host:dir(git branch)
# Red for root!
who=`whoami`

box=`hostname`
case "$TERM" in
  xterm*|rxvt*)
    if [[ $who =~ root ]]; then
      PS1='${debian_chroot:+($debian_chroot)}\[${RED}\]\u@${box}\[${WHITE}\]:\[${RED}\]\w\[${PINK}\]$(__git_ps1)\[${WHITE}\]$ '
    elif [[ $who =~ mede ]] || [[ $who =~ matt ]]; then
      PS1='${debian_chroot:+($debian_chroot)}\[${GREEN}\]\u@${box}\[${WHITE}\]:\[${CYAN}\]\w\[${PINK}\]$(__git_ps1)\[${WHITE}\]$ '
    else
      PS1='${debian_chroot:+($debian_chroot)}\[${PINK}\]\u@${box}\[${WHITE}\]:\[${CYAN}\]\w$\[${PINK}\]$(__git_ps1)\[${WHITE}\]$ '
    fi
esac

# root history goes different places on linux/mac, and homedir structure changes
if [[ $who =~ root ]]; then
  if [ -d "/root"  ]; then
    HISTFILE=/root/.bash_history
  elif [ -d "/var/root"  ]; then
    HISTFILE=/var/root/.sh_history
  else
    HISTFILE=~/.history/.history
  fi
else
  HISTFILE=~/.history/.history
fi

# don't put duplicate lines in the history. See bash(1) for more options
export HISTCONTROL=ignoredups
HISTFILESIZE=100000
HISTSIZE=10000
export HISTTIMEFORMAT='%F %T '

if [ -d "$MMEDEIROS_HOME/bin"  ]; then
  PATH=$PATH:$MMEDEIROS_HOME/bin
fi

if [ -d "$MMEDEIROS_HOME/Documents/scripts"  ]; then
  PATH=$PATH:$MMEDEIROS_HOME/Documents/scripts
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
alias finf='find . -type f 2> /dev/null |  xargs grep -li 2>/dev/null'
alias toobig='find * ! -type l -ls | sort -k 7nr'
alias mtr='/usr/local/sbin/mtr'
alias sudo="echo source $MMEDEIROS_HOME/.bashrc; sudo"
alias vim="vim -u $MMEDEIROS_HOME/.vimrc"
alias vimdiff='vimdiff -u $MMEDEIROS_HOME/.vimrc'
alias lockit='open -a /System/Library/Frameworks/ScreenSaver.framework/Versions/A/Resources/ScreenSaverEngine.app'

# Git for gits
alias gpp='clear && git pull origin && git push'
alias gitlog='git log --oneline --color --graph --decorate'
alias punch='blame'
alias gs='git status'
gitdiff ()   { git diff --cached ; }
gitcom ()    { git checkout master ;}
gitnuke ()   { git fetch --all && git reset --hard origin/master; }
gitclean ()  { git ls-files --deleted -z | xargs -0 git rm; }
gitlast ()   { git diff -w HEAD^ HEAD $*; }
delremote () { git push origin :$1; }
blame ()     { git blame $1 | less; }

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
		openssl req  -modulus -noout < $1 | openssl md5;
	elif [[ $line =~ CERTIFICATE ]] ; then
		openssl x509 -modulus -noout < $1 | openssl md5;
	elif [[ $line =~ KEY ]] ; then
		openssl rsa  -modulus -noout < $1 | openssl md5;
	else
		echo "Sorry, $1 is not a valid ssl file";
	fi
}

rmtmp () {
  for tmp in `find . -type f -name '*~' 2> /dev/null | grep -vi dropbox`
  do
    rm -i $tmp
  done
}

vdie () {
	`ps aux | grep -i [v]lc | awk '{print $2}' | xargs kill -9`;
}

nofab () {
	`ps aux | grep [f]ab | grep -v vim | awk '{print \$2}' | xargs kill -9`;
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

startup () {
  startup=~/Documents/scripts/startup;
  if [[ -a $startup ]]
  then
    sh $startup;
  else
    echo "startup file does not exist!"
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

# If the first Chef run fails, you need to call
# the config file directly. Shortcut this.
cheff () {
  chefhost=`hostname`
  if [[ $chefhost  =~ \.stg\. ]]; then
    chefenv='stg'
  elif [[ $chefhost  =~ \.qa\. ]]; then
    chefenv='qa'
  elif [[ $chefhost  =~ \.prod\. ]]; then
    chefenv='prod'
  elif [[ $chefhost  =~ \.inf\. ]]; then
    chefenv='inf'
  elif [[ $chefhost  =~ \.demo\. ]]; then
    chefenv='demo'
  elif [[ $chefhost  =~ \.dev\. ]]; then
    chefenv='dev'
  else
    echo "no environment in hostname"
    echo "please run manually"
    exit 1
  fi

  if [[ $who =~ root ]]; then
    echo "chef-client --once -E $chefenv -j /etc/chef/first-boot.json"
    chef-client --once -E $chefenv -j /etc/chef/first-boot.json
  else
    echo "User $who is not root, using sudo:"
    echo "chef-client --once -E $chefenv -j /etc/chef/first-boot.json"
    sudo chef-client --once -E $chefenv -j /etc/chef/first-boot.json
  fi
}

purgemail(){
  postsuper -d ALL
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

# list the open ports with less typing
neto () {
  netstat -an | grep -i list
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
alias now='echo $(date +%Y%m%d%H%M%S)'
alias epoch='date +%s'

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
  alias df='df -P | column -t'
  alias dfh='\df -h -P | column -t'
  alias dnsclear='sudo killall -HUP mDNSResponder'
  alias la='clear; ls -Al'
  alias ll='clear; ls -l'
  alias lr='clear; ls -ltr'
  alias ls='ls -G'
  alias lz='clear; ls -Sal'
  alias md5sum='md5 -r'
  alias spacehog='du -s * 2>/dev/null | sort -nr | head'
  export LSCOLORS="gxfxcxdxbxegedabagacad"
  MYIP="127.0.0.1"
elif [[ $platform == 'linux' ]]; then
  alias df='df -P | column -t'
  alias dfh='\df -hP | column -t'
  alias la='clear; ls -Al'
  alias ll='clear; ls -l'
  alias lr='clear; ls -ltr'
  alias ls='ls --color=auto'
  alias lz='clear; ls -Sal'
  alias spacehog='du --max-depth=1 2> /dev/null  | sort -nr  | head'
  LS_COLORS='di=0;35' ; export LS_COLORS
  MYIP=$(ifconfig eth0| grep 'inet addr' | cut -d':' -f2 | cut -d' ' -f1)
fi

alias mede='source $MMEDEIROS_HOME/.bashrc'
alias vimpr='vim $MMEDEIROS_HOME/.bashrc'

# Ruby and perl stuff
PATH=$PATH:$HOME/.rvm/bin # Add RVM to PATH for scripting
PERL_MB_OPT="--install_base \"$MMEDEIROS_HOME/perl5\""; export PERL_MB_OPT;
PERL_MM_OPT="INSTALL_BASE=$MMEDEIROS_HOME/perl5"; export PERL_MM_OPT;
complete -C aws_completer aws

GEM_HOME="$GEM_HOME:/usr/local/var/rbenv/versions/2.1.5/lib/ruby/gems/2.1.0"
GEM_PATH="$GEM_PATH:/usr/local/var/rbenv/versions/2.1.5/lib/ruby/gems/2.1.0/gems"
