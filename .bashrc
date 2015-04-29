#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'

. ~/.scripts/git_prompt.sh
export PROMPT_COMMAND=set_ps1
#export PS1='\[\e[1;36m\]\u\[\e[m\] \[\e[1;34m\]\w\[\e[m\] \[\e[1;32m\]\$\[\e[m\] \[\033[m\]'
#export PROMPT_COMMAND=set_prompt_header

if [ -d "$HOME/.bin" ] ; then
    PATH="$HOME/.bin:$PATH"
fi
