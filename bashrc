# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

#-------------------------------------------------------------------------------
# Functions
#-------------------------------------------------------------------------------

# Format the bash prompt
setup_prompt()
{
    local RED="\[\033[0;31m\]"
    local BRED="\[\033[1;31m\]"
    local GRE="\[\033[0;32m\]"
    local YEL="\[\033[0;33m\]"
    local VIL="\[\033[0;35m\]"
    local RST="\[\033[0m\]"

    if [ -n "${SSH_CLIENT+1}" ]; then
        local info=($SSH_CLIENT)
        local ip=${info[0]}

        if [ "$ip" == "::1" ]; then
            local ip="localhost"
        fi

        local origin="${BRED}${ip}${RST} "
    fi

    PS1="\n${origin}${GRE}\u@\h${RST} ${YEL}\w${RST}\n${VIL}\$${RST} "
    PS2="> "
}

# Get a formatted string containing user and hostname
get_prefix()
{
    if [ -n "${SSH_CLIENT+1}" ]; then
        echo "$(whoami)@$(hostname):"
    else
        echo ""
    fi
}

# sed command to build vim-tab-like abbreviated path
shorten()
{
	sed 's:\([^/]\)[^/]*/:\1/:g'
}

# Get a title based on current directory
get_title()
{
    # Set terminal title to path of form /d/d/d/d/cwd
    #title=`echo $PWD | shorten`

    # Set terminal title to basename of cwd
    echo "`basename "${PWD/#$HOME/~}"`"
}

# Create environment variables and aliases from an array of paths
#   $1  = associative array of form:
#       declare -A paths=(
#           [label]=path
#       )
#   $2 = comman path prefix
#   $3 = comman env prefix
#
# Use:
#   arr_to_env_paths "paths" "path_prefix" "env_prefix"
arr_to_env_paths()
{
    local arr=$(declare -p "$1")
    eval "declare -A paths="${arr#*=}
    local path_prefix="$2"
    local env_prefix="$3"

    for path in "${!paths[@]}"; do
        export ${env_prefix^^}${path^^}="${path_prefix}${paths[$path]}"
        alias ${env_prefix,,}${path,,}="cd ${path_prefix}${paths[$path]}"
    done
}

# For an array of root paths and an array of subpaths create environment vars
# and aliases for the concatenation of each root path with each subpath
#   $1 = associative array of form:
#       declare -A paths=(
#           [label]=path
#       )
#   $2 = associative array of form:
#       declare -A subpaths=(
#           [label]=subpath
#       )
#   $3 = common path prefix
#   $4 = common env prefix
arr_to_env_subpaths()
{
    local arr_root=$(declare -p "$1")
    local arr_sub=$(declare -p "$2")
    eval "declare -A paths="${arr_root#*=}
    eval "declare -A subpaths="${arr_sub#*=}
    local path_prefix="$3"
    local env_prefix="$4"

    for path in "${!paths[@]}"; do
        for subpath in "${!subpaths[@]}"; do
            export ${env_prefix^^}_${path^^}_${subpath^^}="${path_prefix}${paths[$path]}/${subpaths[$subpath]}"
            alias ${env_prefix,,}_${path,,}_${subpath,,}="cd ${path_prefix}${paths[$path]}/${subpaths[$subpath]}"
        done
    done
}

# Create environment variables and aliases from an array of hosts
#   $1 = associative array of form:
#       declare -A hosts=(
#           [label]=host
#       )
#   $2 = username for host
#   $3 = prefix for user@host env var
arr_to_env_hosts()
{
    local arr=$(declare -p "$1")
    eval "declare -A hosts="${arr#*=}
    local user="$2"
    local env_prefix="$3"

    for host in "${!hosts[@]}"; do
        export ${host^^}="${hosts[$host]}"
        export ${env_prefix^^}${host^^}="$user@${hosts[$host]}"
    done
}

# Move up the input number of directories
#   $1  = number of dirs to navigate
..()
{
    local num="$1"

    local path=""
    for i in $(seq $num); do
        path="../${path}"
    done

    cd "$path"
}


#-------------------------------------------------------------------------------
# Setup
#-------------------------------------------------------------------------------

setup_prompt

# Set the xterm title after every command in a shell
PROMPT_COMMAND='echo -ne "\033]0;$(get_prefix)$(get_title)\a\007"'

# Setup terminal colors
TERM=xterm-256color

# Setup DISPLAY for X11 forwarding
export DISPLAY=:0.0

# Don't duplicate BASH history
export HISTCONTROL=ignoredups:erasedups
shopt -s histappend

