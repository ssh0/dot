# vim: ft=sh
dot_add() {
  # default message
  local message=""

  # option handling
  while getopts m:h OPT
  do
    case $OPT in
      "m" ) message="${OPTARG}";;
    esac
  done

  shift $((OPTIND-1))

  if [ ! -e "$1" ]; then
    echo -n "[$(tput bold)$(tput setaf 1)error$(tput sgr0)] "
    echo "$(tput bold)$1$(tput sgr0) doesn't exist."
    return 1
  fi


  orig_to_dot() { #{{{
    # mv from original path to dotdir
    local orig dot

    orig="$(get_fullpath "$1")"
    dot="$(get_fullpath "$2")"

    mv -i "${orig}" "${dot}"

    # link to orig path from dotfiles
    ln -siv "${dot}" "${orig}"
  } #}}}


  add_to_dotlink() { #{{{
    local dotfile linkto
    # add the configration to the config file.
    [ -n "${message}" ] && echo "# ${message}" >> "${dotlink}"

    dotfile="$(path_without_dotdir "$2")"
    if [ "${dotfile}" = "" ]; then
      dotfile="$(path_without_home "$2")"
      if [ -n ${dotfile} ]; then
        dotfile="\$HOME/${dotfile}"
      else
        dotfile="$(get_fullpath "$2")"
      fi
    fi

    linkto="$(path_without_home "$1")"
    linkto="${linkto:="$(get_fullpath "$1")"}"

    echo "${dotfile},${linkto}" >> "${dotlink}"
  } #}}}


  if_islink() { #{{{
    # write to dotlink
    local f abspath

    for f in "$@"; do
      if [ ! -L "$f" ]; then
        echo -n "[$(tput bold)$(tput setaf 1)error$(tput sgr0)] "
        echo "$(tput bold)$1$(tput sgr0) is not the symbolic link."
        continue
      fi

      # get the absolute path
      abspath="$(readlink "$f")"

      if [ ! -e "${abspath}" ]; then
        echo -n "[$(tput bold)$(tput setaf 1)error$(tput sgr0)] "
        echo "Target path $(tput bold)${abspath}$(tput sgr0) doesn't exist."
        return 1
      fi

      # write to dotlink
      add_to_dotlink "$f" "${abspath}"
    done
  } #}}}


  suggest() { #{{{
    local confirm

    echo "[$(tput bold)$(tput setaf 6)suggestion$(tput sgr0)]"
    echo "    dot add -m '${message}' $1 ${dotdir}/$(path_without_home "$1")"
    echo -n "[$(tput bold)$(tput setaf 6)message$(tput sgr0)] "
    echo "Continue? [y/N]"
    read confirm
    if [ "$confirm" != "y" ]; then
      return 1
    fi

    dot_add_main "$1" "${dotdir}/$(path_without_home $1)"
  } #}}}


  check_dir() { #{{{
    local yn

    if [ -d "${1%/*}" ]; then
      return 0
    fi

    echo -n "[$(tput bold)$(tput setaf 1)error$(tput sgr0)] "
    echo "$(tput bold)${1%/*}$(tput sgr0) doesn't exist."
    echo -n "[$(tput bold)$(tput setaf 6)message$(tput sgr0)] "
    echo "mkdir $(tput bold)${1%/*}$(tput sgr0)? (y/n):"
    while true; read yn; do
      case $yn in
        [Yy] ) mkdir -p "${1%/*}"
                break
                ;;
        [Nn] ) unset yn
                return 1
                ;;
            * ) echo "Please answer with y or n."
                ;;
      esac
    done

    return 0
  } #}}}


  dot_add_main() { #{{{
    # if the first arugument is a symbolic link
    if [ -L "$1" ]; then
      if_islink "$@" || return 1
      return 0
    fi

    # if the second arguments is provided (default action)
    if [ $# = 2 ]; then

      # if the targeted directory doesn't exist,
      # ask whether make directory or not.
      check_dir "$2" || return 1

      orig_to_dot "$1" "$2"
      add_to_dotlink "$1" "$2"

      return 0
    fi

    # if the second arugument isn't provided, provide suggestion
    if [ $# = 1 ];then
      suggest "$1" && return 0 || return 1
    fi

    # else
    echo "[$(tput bold)$(tput setaf 1)error$(tput sgr0)] Aborted."
    echo "Usage: 'dot add file'"
    echo "       'dot add file ${dotdir}/any/path/to/the/file'"

    return 1
  } #}}}


  dot_add_main "$@"

  unset -f orig_to_dot add_to_dotlink if_islink suggest check_dir
  unset -f $0
}
