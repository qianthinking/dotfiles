# PS
alias psa="ps aux"
alias pse="ps -ef"
alias psg="ps aux | grep"

# System Aliases
alias top='glances'

# My Git Aliases
alias gs='git status'
alias gcim='git ci -m'
alias gci='git ci'
alias gplr='git pull --rebase'
alias gpc='git push --set-upstream origin "$VCS_STATUS_LOCAL_BRANCH"'

# chezmoi Aliases
alias ch='chezmoi'
alias che='chezmoi edit --apply'
alias cch='cd ~/.local/share/chezmoi'
