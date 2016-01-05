# vim: ft=sh

dot_clone() { 
  local cloneto
  cloneto="${1:-"${dotdir}"}"

  echo "$(prmpt 3 try)git clone --recursive ${clone_repository} ${cloneto}"
  echo -n "Continue? "
  if ! __confirm y; then
    echo "Aborted."
    echo ""
    echo "If you want to clone other repository, change environment variable DOT_REPO."
    echo "    export DOT_REPO=https://github.com/Your_Username/dotfiles.git"
    echo "Set the directory to clone by:"
    echo "    dot clone ~/dotfiles"
    echo "    export DOT_DIR=\$HOME/dotfiles"
    return 1
  fi

  git clone --recursive "${clone_repository}" "${cloneto}"

  unset -f $0
} 
