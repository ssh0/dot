# vim: ft=sh
dot_pull() { 
  local cwd="$(pwd)"

  if [ "$1" = "--self" ]; then
    echo $(prmpt 4 "Update dot")
    builtin cd "${DOT_SCRIPT_ROOTDIR}" && git pull
  else
    # git pull
    echo "$(prmpt 4 "Update dotfiles")cd "${dotdir}" && git pull"
    builtin cd "${dotdir}" && git pull
  fi
  builtin cd "$cwd"

  unset -f $0
} 
