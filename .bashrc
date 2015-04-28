#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'

. ~/.scripts/git_prompt.sh
PS1='\[\e[45;1;37m\] $(__git_ps1)\[\e[40;0;35m\] \[\e[1;36m\]\u\[\e[m\] \[\e[1;34m\]\w\[\e[m\] \[\e[1;32m\]\$\[\e[m\] \[\033[m\]'

if [ -d "$HOME/.bin" ] ; then
    PATH="$HOME/.bin:$PATH"
fi
