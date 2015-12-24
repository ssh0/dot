# vim: ft=sh
dot_list() { 

  _dot_list() { #{{{
    local l

    for l in $(grep -Ev '^#' "$1" | grep -Ev '^$'); do
      dotfile="$(eval echo "$l" | awk 'BEGIN {FS=","; }  { print $1; }')"
      orig="$(eval echo "$l" | awk 'BEGIN {FS=","; }  { print $2; }')"

      if [ "$(echo $dotfile | cut -c 1)" != "/" ]; then
        dotfile="${dotdir}/$dotfile"
      fi

      if [ "$(echo $orig | cut -c 1)" != "/" ]; then
        orig="$HOME/$orig"
      fi

      # if dotfile doesn't exist
      if [ ! -e "${dotfile}" ]; then
        echo "[$(tput bold)$(tput setaf 1)✘$(tput sgr0)] ${orig}"
        continue
      fi

      if [ -e "${orig}" ]; then                 # if the file already exists:
        if [ -L "${orig}" ]; then               #   if it is a symbolic-link:
          linkto="$(readlink "${orig}")"

          # if the link has already be set: do nothing
          if [ "${linkto}" = "${dotfile}" ]; then
            echo "[$(tput bold)$(tput setaf 2)✔$(tput sgr0)] ${orig}"
          else
            echo "[$(tput bold)$(tput setaf 1)✘$(tput sgr0)] ${orig}"
          fi
        else                                    #   if it is a file or a dir:
          echo "[$(tput bold)$(tput setaf 1)✘$(tput sgr0)] ${orig}"
        fi
      else                                      # else:
        echo "[$(tput bold)$(tput setaf 1)✘$(tput sgr0)] ${orig}"
      fi
    done
  } #}}}

  for linkfile in "${linkfiles[@]}"; do
    echo "$(tput bold)$(tput setaf 4)From ${linkfile}$(tput sgr0)"
    _dot_list "${linkfile}"
  done

  unset -f _dot_list $0
  unset dotfile orig origdir

} 
