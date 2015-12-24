# vim: ft=sh
dot_unlink() { 
  local f

  for f in "$@"; do
    if [ ! -L "$f" ]; then
      echo -n "[$(tput bold)$(tput setaf 1)error$(tput sgr0)] "
      echo "$(tput bold)$f$(tput sgr0) is not the symbolic link."
    else
      # get the file's path
      local currentpath="$(get_fullpath "$f")"

      # get the absolute path
      local abspath="$(readlink "$f")"

      # unlink the file
      unlink "$currentpath"

      # copy the file
      cp "$abspath" "$currentpath"

      echo -n "[$(tput bold)$(tput setaf 6)message$(tput sgr0)] "
      echo -n "$(tput bold)$f$(tput sgr0) was unlinked "
      echo "and its now the copy of $(tput bold)$abspath$(tput sgr0)."
    fi
  done

  unset -f $0
} 
