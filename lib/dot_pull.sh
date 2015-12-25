# vim: ft=sh
dot_pull() { 
  local cwd="$(pwd)"

  if [ "$1" = "--self" ]; then
    echo "[$(tput bold)$(tput setaf 4)Update dot.$(tput sgr0)] "
    builtin cd "${DOT_SCRIPT_ROOTDIR}" && git pull
  else
    # git pull
    builtin cd "${dotdir}" && git pull
  fi
  builtin cd "$cwd"

  unset -f $0
} 
