# vim: ft=sh
dot_pull() {
  local cwd="$(pwd)"

  if [ "$1" = "--self" ]; then
    echo $(prmpt 4 "Update dot")
    builtin cd "${DOT_SCRIPT_ROOTDIR}" && git pull
  else
    # git pull
    echo "$(prmpt 4 "Update dotfiles")cd "${dotdir}" && git pull"
    git -C "${dotdir}" pull
    if ${dotpull_update_submodule} && test -s "${dotdir}/.gitmodules"; then
      echo "$(prmpt 4 "Update the submodules ...")"
      git -C "${dotdir}" submodule init
      git -C "${dotdie}" submodule update
    fi
  fi
  builtin cd "$cwd"

  unset -f $0
}
