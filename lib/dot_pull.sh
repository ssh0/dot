# vim: ft=sh
dot_pull() { 
  local cwd="$(pwd)"

  if [ "$1" = "--self" ]; then
    echo -n "[$(tput bold)$(tput setaf 6)message$(tput sgr0)] "
    echo "Update dot."
    builtin cd "${DOT_SCRIPT_ROOTDIR}" && git pull
  else
    # git pull
    builtin cd "${dotdir}" && git pull
  fi
  builtin cd "$cwd"

  unset -f $0
} 
