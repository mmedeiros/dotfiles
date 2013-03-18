# ~/.bash_profile: executed by bash(1) for login shells.
# see /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.

# include .bashrc if it exists
if [ -f ~/.bashrc ]; then
    . ~/.bashrc
fi

# set PATH so it includes user's private bin if it exists
if [ -d ~/bin ] ; then
    PATH=~/bin:"${PATH}"
fi

# MacPorts Stuff 
export PATH=/opt/local/bin:/opt/local/sbin:$PATH
export DISPLAY=:0

test -r /sw/bin/init.sh && . /sw/bin/init.sh
