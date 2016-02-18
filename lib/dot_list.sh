# vim: ft=sh
dot_list() { 
  local linkfile l

  _dot_list() { #{{{
    local dotfile orig origdir linkto message
    local delimiter=","
    # extract environment variables
    dotfile="$(echo $1 | cut -d, -f1)"
    dotfile="$(eval echo ${dotfile})"
    orig="$(echo $1 | cut -d, -f2)"
    orig="$(eval echo ${orig})"

    # path completion
    [ "${dotfile:0:1}" = "/" ] || dotfile="${dotdir}/$dotfile"
    [ "${orig:0:1}" = "/" ] || orig="$HOME/$orig"
    message="${dotfile}${delimiter}${orig}"

    # if dotfile doesn't exist
    if [[ -e "${dotfile}" || -e "${orig}" || -L "${orig}" ]]; then
      :
    else
      echo "$(prmpt 1 ✘)${message}"
      return 1
    fi

    linkto="$(readlink "${orig}")"

    if [ "${linkto}" = "${dotfile}" ]; then
      echo "$(prmpt 2 ✔)${message}"
    else
      echo "$(prmpt 1 ✘)${message}"
    fi
    return 0
  } #}}}

  for linkfile in "${linkfiles[@]}"; do
    echo "$(prmpt 4 "From ${linkfile}")"
    for l in $(grep -Ev '^#|^$' "${linkfile}"); do
      _dot_list "$l"
    done
  done

  unset -f _dot_list $0

} 
