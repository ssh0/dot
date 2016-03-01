# vim: ft=sh

dot_clone() { 
  local cloneto clonecmd
  cloneto="${1:-"${dotdir}"}"

  if ${dot_clone_shallow}; then
    clonecmd="git clone --recursive --depth 1 ${clone_repository} ${cloneto}"
  else
    clonecmd="git clone --recursive ${clone_repository} ${cloneto}"
  fi

  echo "$(prmpt 3 try): ${clonecmd}"
  if ! __confirm y "Continue? "; then
    echo "Aborted."
    echo ""
    echo "If you want to clone other repository, change environment variable DOT_REPO."
    echo "    export DOT_REPO=https://github.com/Your_Username/dotfiles.git"
    echo "Set the directory to clone by:"
    echo "    dot clone ~/dotfiles"
    echo "    export DOT_DIR=\$HOME/dotfiles"
    return 1
  fi

  eval "${clonecmd}"

  unset -f $0
} 
