# PS
alias psa="ps aux"
alias pse="ps -ef"
alias psg="ps aux | grep"

# opencode
alias oc='opencode'

# System Aliases
alias top='glances'

# My Git Aliases
alias gs='git status'
alias gcim='git ci -m'
alias gci='git ci'
alias gpl='git pull'
alias gplr='git pull --rebase'
alias gpc='git push --set-upstream origin "$VCS_STATUS_LOCAL_BRANCH"'
alias gl='git l'
alias glp="git lp"
alias PL='GIT_PAGER="less -r"'
alias PD='GIT_PAGER="delta --paging=always"'

# chezmoi Aliases
alias ch='chezmoi'
alias chdr='chezmoi diff -r'
alias che='chezmoi edit --apply'
alias cch='cd ~/.local/share/chezmoi'

# cd Aliases
alias chd='cd ~/Downloads'
alias chw='cd ~/workspace'
alias cho='cd ~/opensource'

# Ohter Aliases
alias -g ...='../..'
alias -g ....='../../..'
alias -g .....='../../../..'
alias -g C='| wc -l'
alias -g H='| head'
alias -g L="| less"
alias -g N="| /dev/null"
alias -g S='| sort'
alias -g G='| grep' # now you can do: ls foo G something
alias -g GV='| grep -v grep'
alias -g A='| awk'
alias -g P1='"{print \$1}"'
alias -g P2='"{print \$2}"'
alias -g P3='"{print \$3}"'
alias -g K='| xargs kill'
alias -g K9='| xargs kill -9'

# function to re-add a directory for chezmoi with forget and add
function chreadd() {
  if [[ -d "$1" ]]; then
    chezmoi forget "$1" --force
    chezmoi add "$1" --force
  else
    echo "Directory '$1' does not exist."
  fi
}

# function to re-add all file with chezmoi native command and re-add all directories with forget and add
function chreaddall() {
  chezmoi re-add --force
  manage_directories=$(chezmoi managed -i dirs | grep -v "\/")
  while IFS= read -r dir; do
    dir="$HOME/$dir"
    if [[ -d "$dir" ]]; then
      echo "Re-adding directory: $dir"
      chezmoi forget "$dir" --force
      chezmoi add "$dir" --force
    else
      echo "Directory '$dir' does not exist, skipping."
    fi
  done <<< "$manage_directories"
}

# Function to create a directory and change into it
mcd() { mkdir -p "$1" && cd "$1" }
