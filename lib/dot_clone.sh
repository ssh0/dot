# vim: ft=sh

dot_clone() { 
  local cloneto confirm
  cloneto="${1:-"${dotdir}"}"

  echo -n "[$(tput bold)$(tput setaf 3)try$(tput sgr0)] "
  echo "git clone --recursive ${clone_repository} ${cloneto}"
  echo -n "[$(tput bold)$(tput setaf 6)message$(tput sgr0)] "
  echo -n "Continue? [y/N]"
  read confirm
  if [ "$confirm" != "y" ]; then
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

  unset -v confirm
  unset -f $0
} 
