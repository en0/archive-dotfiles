#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'

. ~/.scripts/git_prompt.sh
export PROMPT_COMMAND=set_ps1

if [ -d "$HOME/.bin" ] ; then
    PATH="$HOME/.bin:$PATH"
fi
