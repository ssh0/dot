# vim: ft=sh
dot_set() { 
  # option handling
  local linkfile l

  while getopts iv OPT
  do
    case $OPT in
      "i" ) dotset_interactive=false ;;
      "v" ) dotset_verbose=true ;;
    esac
  done

  check_dir() { #{{{
    local orig="$1"

    origdir="${orig%/*}"

    [ -d "${origdir}" ] && return 0

    echo "$(prmpt 1 error)$(bd_ ${origdir}) doesn't exist."

    ${dotset_interactive} || return 1

    echo -n "make directory $(bd_ ${origdir})?"
    if __confirm y; then
      mkdir -p "${origdir}" && return 0
    else
      echo "Aborted."; return 1
    fi
  } #}}}

  if_islink() { #{{{
    local orig="$1"
    local dotfile="$2"
    local linkto="$(readlink "${orig}")"

    # if the link has already be set: do nothing
    if [ "${linkto}" = "${dotfile}" ]; then
      ${dotset_verbose} &&
        echo "$(prmpt 2 done)${orig}"
      return 0
    fi

    echo "$(prmpt 1 conflict)Other link already exists at $(bd_ ${orig})"

    ${dotset_interactive} || return 0

    echo -n "  $(prmpt 2 now)"
    echo "${orig} $(tput bold)$(tput setaf 5)<--$(tput sgr0) ${linkto}"
    echo -n "  $(prmpt 3 try)"
    echo "${orig} $(tput bold)$(tput setaf 5)<--$(tput sgr0) ${dotfile}"
    echo "Unlink and re-link for $(bd_ ${orig}) ? "
    if __confirm n; then
      unlink "${orig}"
      ln -s "${dotfile}" "${orig}"
      echo "$(prmpt 2 done)${orig}"
    fi

    return 0
  } #}}}

  if_exist() { #{{{
    local line
    local orig="$1"
    local dotfile="$2"

    if ! ${dotset_interactive}; then
      echo "$(prmpt 1 conflict)File already exists at $(bd_ ${orig})."
      return 0
    fi

    while true; do
      echo "$(prmpt 1 conflict)File already exists at $(bd_ ${orig})."
      echo "Choose the operation:"
      echo "    ($(bd_ d)):show diff"
      echo "    ($(bd_ e)):edit files"
      echo "    ($(bd_ f)):replace"
      echo "    ($(bd_ b)):replace and make backup"
      echo "    ($(bd_ n)):do nothing"
      echo -n ">>> "; read line
      case $line in
        [Dd] )
          eval "${diffcmd}" "${dotfile}" "${orig}"
          echo ""
          ;;
        [Ee] )
          eval "${edit2filecmd}" "${dotfile}" "${orig}"
          ;;
        [Ff] )
          if [ -d "${orig}" ]; then
            rm -rf -- "${orig}"
          else
            rm -f -- "${orig}"
          fi
          ln -s "${dotfile}" "${orig}"
          echo "$(prmpt 2 done)${orig}"
          break
          ;;
        [Bb] )
          ln -sb --suffix '.bak' "${dotfile}" "${orig}"
          echo "$(prmpt 2 done)${orig}"
          echo "$(prmpt 2 "make backup")${orig}.bak"
          break
          ;;
        [Nn] )
          break
          ;;
        *)
          echo "Please answer with [d/e/f/b/n]."
          ;;
      esac
    done

    return 0
  } #}}}

  _dot_set() { #{{{
    local dotfile orig
    # extract environment variables
    dotfile="$(eval echo $1)"
    orig="$(eval echo $2)"

    # path completion
    [ "${dotfile:0:1}" = "/" ] || dotfile="${dotdir}/$dotfile"
    [ "${orig:0:1}" = "/" ] || orig="$HOME/$orig"

    # if dotfile doesn't exist, print error message and pass
    if [ ! -e "${dotfile}" ]; then
      echo "$(prmpt 1 "not found")${dotfile}"
      return 1
    fi

    # if the targeted directory doesn't exist,
    # ask whether make directory or not.
    check_dir "${orig}" || return 1

    if [ -e "${orig}" ]; then                 # if the file already exists:
      if [ -L "${orig}" ]; then               #   if it is a symbolic-link:
        if_islink "${orig}" "${dotfile}"      #      do nothing or relink
      else                                    #   if it is a file or a dir:
        if_exist "${orig}" "${dotfile}"       #      ask user what to do
      fi                                      #
    else                                      # else:
      ln -s "${dotfile}" "${orig}"            #   make symbolic link
      echo "$(prmpt 2 done)${orig}"
    fi

  } #}}}

  for linkfile in "${linkfiles[@]}"; do
    echo "$(prmpt 4 "Loading ${linkfile} ...")"
    for l in $(grep -Ev '^\s*#|^\s*$' "${linkfile}"); do
      _dot_set $(echo $l | tr ',' ' ')
    done
  done

  unset -f check_dir if_islink if_exist _dot_set $0

} 
