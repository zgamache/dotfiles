# Directory contents
alias la="ll -a"
alias lh="ls -lhS"
alias duh="du -h --max-depth=1 | sort -hr"
alias duhl="duh && lh"
alias cll="clear && ll"
alias cls="clear && ls"

# grep
alias ag="alias | grep"
alias eg="env | grep"
alias hg="history | grep"
alias lg="ls | grep"
alias pg="ps -ef | grep"
tg()
{
    case "$(uname -s)" in
        Darwin*)
            top -pid $(pgrep -d " -pid " "$1" | rev | cut -d - -f 2- |rev)
            ;;
        *)
            top -p $(pgrep -d , "$1")
            ;;
    esac
}

# Docker
docker_exec()
{
    container="$1"
    #docker exec -e COLUMNS="`tput cols`\" -e LINES=\"`tput lines`" $@
    docker exec -it "${container}" bash -c "export COLUMNS=`tput cols` && export LINES=`tput lines` && bash"
}

# Misc
alias ts="date +%Y-%m-%d_%H%M%S"
alias tl="tail -f *.log"
alias ctl="clear; tl"

alias de="docker_exec"
# Source environment config
if [ -f ~/.bash_env ]; then
    . ~/.bash_env
fi

