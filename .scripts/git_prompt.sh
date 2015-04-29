# Fancy prompt for GIT details
# Ian Laird - 2015

# Colors
COLOR_BRANCH="\e[45;1;37m"
COLOR_BRANCH_ARROW="\e[;42;35m"
COLOR_COMMIT="\e[42;1;37m"
COLOR_COMMIT_ARROW="\e[;43;32m"
COLOR_UNSTAGED="\e[43;1;37m"
COLOR_UNSTAGED_ARROW="\e[;44;33m"
COLOR_UNSTAGED_ARROW_END="\e[40;0;33m"
COLOR_PATH="\e[44;37m"
COLOR_PATH_ARROW="\e[40;0;34m"
RESET_COLOR="\e[0m"

function _for_commit() {
    _add=$(git status --porcelain | grep ^A | wc -l)
    _del=$(git status --porcelain | grep ^D | wc -l)
    _mod=$(git status --porcelain | grep ^M | wc -l)
    _mod=$[_mod + $(git status --porcelain | grep ^R | wc -l)]
    _sum=$[_add + _del + _mod]
    if [[ _sum -gt 0 ]]; then
        echo -n " +:${_add} ~:${_mod} -:${_del} "
    else
        echo -n ""
    fi
}

function _not_commit() {
    _add=$(git status --porcelain | grep ^\?? | wc -l)
    _add=$[_add + $(git status --porcelain | grep ^\ A | wc -l)]
    _del=$(git status --porcelain | grep ^\ D | wc -l)
    _mod=$(git status --porcelain | grep ^\ M | wc -l)
    _mod=$[_mod + $(git status --porcelain | grep ^\ R | wc -l)]
    _sum=$[_add + _del + _mod]
    if [[ _sum -gt 0 ]]; then
        echo -n " +:${_add} ~:${_mod} -:${_del} "
    else
        echo -n ""
    fi
}

function _get_branch() {
    _branch=$(git status --branch --porcelain | grep ^##)
    _local_branch=$(echo -n ${_branch} | grep -oP "^##\ \K[A-Za-z0-9_-]+")

    _count=$(echo -n ${_branch} | grep -oP "\[\w+\ \K(\d+)(?=\])")
    _ahead=""
    if [ ! -z "${_count}" ]; then
        _symbol=$(echo -n ${_branch} | grep -oP "\[\K\w+(?=\ \d+\])" | sed -e s/behind/-/ -e s/ahead/+/)
        _ahead=" ${_symbol}${_count}"
    fi

    echo -n "  ${_local_branch}${_ahead} "
}

function _get_root() {
    if [ -z "$(git rev-parse --git-dir 2> /dev/null)" ]; then
        echo -n "\w"
        return 1
    fi
    echo -n "$(git rev-parse --show-prefix)${1}"
}

function set_ps1() {
    if [ -z "$(git rev-parse --git-dir 2> /dev/null)" ]; then
        PS1='\[\e[1;36m\]\u\[\e[m\] \[\e[1;34m\]\w\[\e[m\] \[\e[1;32m\]\$\[\e[m\] \[\033[m\]'
        return 1
    fi

    branch="\[${COLOR_BRANCH}\]$(_get_branch)\[${COLOR_BRANCH_ARROW}\]"
    staged="\[${COLOR_COMMIT}\]$(_for_commit)\[${COLOR_COMMIT_ARROW}\]"
    unstaged="\[${COLOR_UNSTAGED}\]$(_not_commit)\[${COLOR_UNSTAGED_ARROW_END}\]\[${RESET_COLOR}\]"

    PS1="${branch}${staged}${unstaged} \[\e[1;36m\]\u\[\e[m\] \[\e[1;34m\]/$(_get_root '')\[\e[m\] \[\e[1;32m\]\$\[\e[m\] \[\033[m\]"
}

function set_prompt_header() {
    if [ -z "$(git rev-parse --git-dir 2> /dev/null)" ]; then
        return 1
    fi

    branch="${COLOR_BRANCH}$(_get_branch)${COLOR_BRANCH_ARROW}"
    staged="${COLOR_COMMIT}$(_for_commit)${COLOR_COMMIT_ARROW}"
    unstaged="${COLOR_UNSTAGED}$(_not_commit)${COLOR_UNSTAGED_ARROW}"
    prodj_root="${COLOR_PATH} /$(_get_root ' ')${COLOR_PATH_ARROW}${RESET_COLOR}"

    echo -e "${branch}${staged}${unstaged}${prodj_root}"
}

# Examples: 
# With a prompt and a header
#export PS1='\[\e[1;36m\]\u\[\e[m\] \[\e[1;34m\]\w\[\e[m\] \[\e[1;32m\]\$\[\e[m\] \[\033[m\]'
#export PROMPT_COMMAND=set_prompt_header

# With a fancey prompt
#export PROMPT_COMMAND=set_ps1
