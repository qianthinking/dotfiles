unset NEW_CONDA_LOADED
load_conda () {
  # >>> conda initialize >>>
  # !! Contents within this block are managed by 'conda init' !!
  __conda_setup="$($HOME'/miniforge3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
  if [ $? -eq 0 ]; then
      eval "$__conda_setup"
  else
      if [ -f "$HOME/miniforge3/etc/profile.d/conda.sh" ]; then
          . "$HOME/miniforge3/etc/profile.d/conda.sh"
      else
          export PATH="$HOME/miniforge3/bin:$PATH"
      fi
  fi
  unset __conda_setup
  conda config --set auto_activate_base false
  export NEW_CONDA_LOADED=1
}
for cmd in "conda"; do
  # Skip defining the function if the binary is already in the PATH
  #if ! which ${cmd} &>/dev/null; then
  # skip if had beed aliased
  alias $cmd 2>/dev/null >/dev/null || eval "${cmd}() { unset -f ${cmd} &>/dev/null; [ -z \${NEW_CONDA_LOADED+x} ] && load_conda; ${cmd} \$@; }"
  #fi
done

