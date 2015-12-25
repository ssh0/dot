# vim: ft=sh
dot_list() { 
  local linkfile l

  _dot_list() { #{{{
    local dotfile orig origdir linkto
    # extract environment variables
    dotfile="$(eval echo $1)"
    orig="$(eval echo $2)"

    # path completion
    [ "${dotfile:0:1}" = "/" ] || dotfile="${dotdir}/$dotfile"
    [ "${orig:0:1}" = "/" ] || orig="$HOME/$orig"

    # if dotfile doesn't exist
    if [ ! -e "${dotfile}" ]; then
      echo "[$(tput bold)$(tput setaf 1)✘$(tput sgr0)] ${orig}"
      return 1
    fi

    if [ ! -e "${orig}" ]; then
      echo "[$(tput bold)$(tput setaf 1)✘$(tput sgr0)] ${orig}"
      return 1
    fi

    if [ ! -L "${orig}" ]; then
      echo "[$(tput bold)$(tput setaf 1)✘$(tput sgr0)] ${orig}"
      return 1
    fi

    linkto="$(readlink "${orig}")"

    if [ "${linkto}" = "${dotfile}" ]; then
      echo "[$(tput bold)$(tput setaf 2)✔$(tput sgr0)] ${orig}"
    else
      echo "[$(tput bold)$(tput setaf 1)✘$(tput sgr0)] ${orig}"
    fi
    return 0
  } #}}}

  for linkfile in "${linkfiles[@]}"; do
    echo "$(tput bold)$(tput setaf 4)From ${linkfile}$(tput sgr0)"
    for l in $(grep -Ev '^#|^$' "${linkfile}"); do
      _dot_list $(echo $l | tr ',' ' ')
    done
  done

  unset -f _dot_list $0

} 
