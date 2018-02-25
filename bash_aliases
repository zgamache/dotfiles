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
tg() { top -p $(pgrep -d , "$1") ; }

# Misc
alias ts="date +%Y-%m-%d_%H%M%S"

# Source environment config
if [ -f ~/.bash_env ]; then
    . ~/.bash_env
fi
