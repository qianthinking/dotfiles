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
alias gpl='git pull'
alias gplr='git pull --rebase'
alias gpc='git push --set-upstream origin "$VCS_STATUS_LOCAL_BRANCH"'
alias gl='git l'
alias glp="git lp"

# chezmoi Aliases
alias ch='chezmoi'
alias che='chezmoi edit --apply'
alias cch='cd ~/.local/share/chezmoi'

# cd Aliases
alias chd='cd ~/Downloads'
alias chw='cd ~/workspace'
alias cho='cd ~/opensource'

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
