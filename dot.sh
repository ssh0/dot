# vim: ft=zsh
# dot - dotfiles management framework

# Version:    1.2
# Repository: https://github.com/ssh0/dotfiles.git
# Author:     ssh0 (Shotaro Fujimoto)
# License:    MIT

DOT_SCRIPT_ROOTDIR="$(cd "$(dirname "${BASH_SOURCE:-${(%):-%N}}")" && pwd)"
readonly DOT_SCRIPT_ROOTDIR
export DOT_SCRIPT_ROOTDIR


dot_main() { #{{{

  # ---------------------------------------------------------------------------
  # Local variables                                                         {{{
  # ---------------------------------------------------------------------------

  local clone_repository dotdir dotlink linkfiles home_pattern dotdir_pattern
  local dotset_interactive dotset_verbose diffcmd edit2filecmd
  local dot_edit_default_editor
  local black red green yellow blue purple cyan white
  local color_message color_error color_notice dotrc columns hrule

  # ------------------------------------------------------------------------}}}
  # Default settings                                                        {{{
  # ---------------------------------------------------------------------------

  clone_repository="${DOT_REPO:-"https://github.com/ssh0/dotfiles.git"}"

  dotdir="${DOT_DIR:-"$HOME/.dotfiles"}"
  dotlink="${DOT_LINK:-"$dotdir/dotlink"}"
  linkfiles=("${dotlink}")

  home_pattern="s@$HOME/@@p"
  dotdir_pattern="s@${dotdir}/@@p"

  dotset_interactive=true
  dotset_verbose=false

  if hash colordiff 2>/dev/null; then
    diffcmd="colordiff -u"
  else
    diffcmd='diff -u'
  fi

  if hash vimdiff 2>/dev/null; then
    edit2filecmd='vimdiff'
  else
    edit2filecmd=${diffcmd}
  fi

  dot_edit_default_editor=''

  # color palette
  black=30
  red=31
  green=32
  yellow=33
  blue=34
  purple=35
  cyan=36
  white=37

  color_message=${blue}
  color_error=${red}
  color_notice=${yellow}

  # ------------------------------------------------------------------------}}}
  # Load user configuration                                                 {{{
  # ---------------------------------------------------------------------------


  dotbundle() {
    if [ -e "$1" ]; then
      source "$1"
    fi
  }

  # path to the config file
  dotrc="$dotdir/dotrc"
  dotbundle "${dotrc}"

  # ------------------------------------------------------------------------}}}

  usage() { #{{{
    cat << EOF

NAME
      dot - manages symbolic links for dotfiles.

USAGE
      dot [-h|--help][-c <configfile>] <command> [<args>]

COMMAND
      clone     Clone dotfile repository on your computer with git.

      pull      Pull remote dotfile repository (by git).

      set       Make symbolic link interactively.
                This command sets symbolic links configured in '$dotlink'.

      add       Move the file to the dotfile dir and make an symbolic link.

      edit      Edit dotlink file '$dotlink'.

      unlink    Unlink the selected symbolic link and copy its original file
                from the dotfile repository.

      clear     Remove the all symbolic link in the config file '$dotlink'.

      config    Edit (or create) rcfile '$dotrc'.

OPTION
      -h,--help 
                Show this help message.
      -c <configfile>
                Specify the configuration file to overload.

COMMAND OPTIONS
      clone [<dir>]
          Clone ${clone_repository} onto the specified direction.
          default: ~/.dotfiles

      pull [--self]
          With --self option, update this script itself.

      set [-i][-v]
          -i: No interaction mode(skip all conflicts and do nothing).
          -v: Print verbose messages.

      add [-m <message>] original_file [dotfile_direction]
          -m <message>: Add your message for dotlink file.

EOF
  } #}}}


  cecho() { #{{{
    local color=$1
    shift
    echo -e "\033[${color}m"$@"\033[00m"
  } #}}}


  # makeline {{{

  columns=$(tput cols)
  if [[ $columns -gt 70 ]]; then
    columns=70
  fi
  hrule="$( printf '%*s\n' "$columns" '' | tr ' ' - )"

  #}}}


  get_fullpath() { #{{{
    echo "$(cd "$(dirname "$1")" && pwd)"/"$(basename "$1")"
  } #}}}


  path_without_home() { #{{{
    get_fullpath "$1" | sed -ne "${home_pattern}"
  } #}}}


  path_without_dotdir() { #{{{
    get_fullpath "$1" | sed -ne "${dotdir_pattern}"
  } #}}}


  dot_clone() { #{{{
    local cloneto confirm
    cloneto="${1:-"${dotdir}"}"
    cecho ${color_message} "\ngit clone --recursive ${clone_repository} ${cloneto}"
    echo "${hrule}"
    echo "Continue? [y/N]"
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
  } #}}}


  dot_pull() { #{{{
    local cwd="$(pwd)"
    if [ "$1" = "--self" ]; then
      cd "${DOT_SCRIPT_ROOTDIR}" && git pull
    else
      # git pull
      cecho ${color_message} "\ncd ${dotdir} && git pull"
      echo "${hrule}"
      cd "${dotdir}" && git pull
    fi
    cd "$cwd"
  } #}}}


  dot_set() { #{{{
    # option handling
    local linkfile
    local mklink

    while getopts iv OPT
    do
      case $OPT in
        "i" ) dotset_interactive=false ;;
        "v" ) dotset_verbose=true ;;
      esac
    done

    if ${dotset_verbose}; then
      mklink="ln -sv"
    else
      mklink="ln -s"
    fi


    info() { #{{{
      if ${dotset_verbose}; then
        # verbose message
        echo ""
        echo "${1} -> ${2}"
      fi
    } #}}}


    check_dir() { #{{{
      local orig="$1"
      local dotfile="$2"

      origdir="${orig%/*}"

      if [ -d "${origdir}" ]; then
        return 0
      fi

      info "${orig}" "${dotfile}"
      cecho ${color_error} "'${origdir}' doesn't exist."
      if ! ${dotset_interactive}; then
        return 0
      fi

      echo "[message] mkdir '${origdir}'? (Y/n):"
      echo -n ">>> "; read confirm
      if [ "$confirm" != "n" ]; then
        mkdir -p "${origdir}" &&
        return 0
      else
        echo "Aborted."
        return 1
      fi
    } #}}}


    if_islink() { #{{{
      local orig="$1"
      local dotfile="$2"
      local linkto="$(readlink "${orig}")"
      local yn

      info "${orig}" "${dotfile}"

      # if the link has already be set: do nothing
      if [ "${linkto}" = "${dotfile}" ]; then
        ${dotset_verbose} && cecho ${color_message} "link '${orig}' already exists."
        return 0
      fi

      # if the link is not refer to: unlink or re-link
      cecho ${color_error} "link '${orig}' is NOT the link of '${dotfile}'."
      cecho ${color_error} "'${orig}' is link of '${linkto}'."

      if ! ${dotset_interactive}; then
        return 0
      fi

      echo "[message] unlink and re-link for '${orig}'? (y/n):"
      while echo -n ">>> "; read yn; do
        case $yn in
          [Yy] ) unlink "${orig}"
                 eval "${mklink}" "${dotfile}" "${orig}"
                 break
                 ;;
          [Nn] ) break
                 ;;
             * ) echo "Please answer with y or n." ;;
        esac
      done

      return 0
    } #}}}


    if_exist() { #{{{
      local line
      local orig="$1"
      local dotfile="$2"
      info "${orig}" "${dotfile}"

      if ! ${dotset_interactive}; then
        return 0
      fi

      while true; do
        cecho ${color_notice} "'${orig}' already exists."
        echo "(d):show diff, (e):edit files, (f):overwrite, (b):make backup, (n):do nothing"
        echo -n ">>> "; read line
        case $line in
          [Dd] ) echo "${diffcmd} '${dotfile}' '${orig}'"
                 eval "${diffcmd}" "${dotfile}" "${orig}"
                 echo ""
                 ;;
          [Ee] ) echo "${edit2filecmd} '${dotfile}' '${orig}'"
                 eval "${edit2filecmd}" "${dotfile}" "${orig}"
                 ;;
          [Ff] ) if [ -d "${orig}" ]; then
                   rm -r "${orig}"
                 else
                   rm "${orig}"
                 fi
                 eval "${mklink}" "${dotfile}" "${orig}"
                 break
                 ;;
          [Bb] ) eval "${mklink}" -b --suffix '.bak' "${dotfile}" "${orig}"
                 break
                 ;;
          [Nn] ) break
                 ;;
              *) echo "Please answer with [d/e/f/b/n]."
                 ;;
        esac
      done

      return 0
    } #}}}


    _dot_set() { #{{{
      local l

      for l in $(grep -Ev '^#' "$1" | grep -Ev '^$'); do
        dotfile="$(echo "$l" | awk 'BEGIN {FS=","; }  { print $1; }')"
        orig="$(echo "$l" | awk 'BEGIN {FS=","; }  { print $2; }')"

        if [ "$(echo $dotfile | cut -c 1)" != "/" ]; then
          dotfile="${dotdir}/$dotfile"
        fi

        if [ "$(echo $orig | cut -c 1)" != "/" ]; then
          orig="$HOME/$orig"
        fi

        # if dotfile doesn't exist, print error message and pass
        if [ ! -e "${dotfile}" ]; then
          echo ""
          cecho ${color_error} "dotfile '${dotfile}' doesn't exist."
          continue
        fi

        # if the targeted directory doesn't exist,
        # ask whether make directory or not.
        check_dir "${orig}" "${dotfile}" || continue

        if [ -e "${orig}" ]; then                 # if the file already exists:
          if [ -L "${orig}" ]; then               #   if it is a symbolic-link:
            if_islink "${orig}" "${dotfile}"          #      do nothing or relink
          else                                    #   if it is a file or a dir:
            if_exist "${orig}" "${dotfile}"           #      ask user what to do
          fi
        else                                      # else:
          eval "${mklink}" "${dotfile}" "${orig}" #   make symbolic link
        fi
      done
    } #}}}

    for linkfile in "${linkfiles[@]}"; do
      echo
      cecho ${green} "From the link file '${linkfile}'"
      echo "${hrule}"
      _dot_set "${linkfile}"
      cecho ${green} "Done."
    done

    unset -f info check_dir if_islink if_exist _dot_set
    unset dotfile orig origdir

  } #}}}


  dot_add() { #{{{
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
      cecho ${color_error} "'$1' doesn't exist."
      echo "Aborted."
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
      dotfile="${dotfile:="$(get_fullpath "$2")"}"
      linkto="$(path_without_home "$1")"
      linkto="${linkto:="$(get_fullpath "$1")"}"

      echo "${dotfile},${linkto}" >> "${dotlink}"
    } #}}}


    if_islink() { #{{{
      # write to dotlink
      local f abspath

      for f in "$@"; do
        if [ ! -L "$f" ]; then
          echo "'$f' is not symbolic link."
          continue
        fi

        # get the absolute path
        abspath="$(readlink "$f")"

        if [ ! -e "${abspath}" ]; then
          cecho ${color_error} "Target path (${abspath}) doesn't exist."
          echo "Aborted."
          return 1
        fi

        # write to dotlink
        add_to_dotlink "$f" "${abspath}"
      done
    } #}}}


    suggest() { #{{{
      local confirm

      cecho ${color_message} "Suggestion:"
      echo "dot add -m '${message}' $1 ${dotdir}/$(path_without_home "$1")"
      echo ""
      echo "Continue? [y/N]"
      read confirm
      if [ "$confirm" != "y" ]; then
        echo "Aborted."
        return 1
      fi

      dot_add_main "$1" "${dotdir}/$(path_without_home $1)"
    } #}}}


    check_dir() { #{{{
      local yn

      if [ -d "${1%/*}" ]; then
        return 0
      fi

      cecho ${color_error} "'${1%/*}' doesn't exist."
      echo "[message] mkdir '${1%/*}'? (y/n):"
      while echo -n ">>> "; read yn; do
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
      echo "Aborted."
      echo "Usage: 'dot add file'"
      echo "       'dot add file ${dotdir}/any/path/to/the/file'"

      return 1
    } #}}}

    dot_add_main "$@"

    unset -f orig_to_dot add_to_dotlink if_islink suggest check_dir
  } #}}}


  dot_edit() { #{{{
    # init
    if [ ! -e "${dotlink}" ]; then
      cecho ${color_error} "'${dotlink}' doesn't exist."
      echo "[message] make dotlink file ? (Y/n)"
      echo "${hrule}"
      echo -n ">>> "; read confirm
      if [ "${confirm}" != "n" ]; then
        echo "cp ${DOT_SCRIPT_ROOTDIR}/examples/dotlink ${dotlink}"
        cp "${DOT_SCRIPT_ROOTDIR}/examples/dotlink" "${dotlink}"
      else
        echo "Aborted."
        return 1
      fi
      unset -v confirm
    fi

    # open dotlink file
    if [ -n "${dot_edit_default_editor}" ];then
      eval ${dot_edit_default_editor} "${dotlink}"
    elif hash "$EDITOR" 2>/dev/null; then
      $EDITOR "${dotlink}"
    else
      xdg-open "${dotlink}"
    fi
  } #}}}


  dot_unlink() { #{{{
    local f

    for f in "$@"; do
      if [ ! -L "$f" ]; then
        echo "'$f' is not symbolic link."
      else
        # get the file's path
        local currentpath="$(get_fullpath "$f")"

        # get the absolute path
        local abspath="$(readlink "$f")"

        # unlink the file
        unlink "$currentpath"

        # copy the file
        cp "$abspath" "$currentpath"
      fi
    done
  } #}}}


  dot_clear() { #{{{
    local linkfile

    _dot_clear() { #{{{
      local l

      for l in $(grep -Ev '^#' "$1" | grep -Ev '^$'); do
        local orig="$(echo "$l" | awk 'BEGIN {FS=","; }  { print $2; }')"
        if [ "$(echo $orig | cut -c 1)" != "/" ]; then
          orig="$HOME/$orig"
        fi
        if [ -L "${orig}" ]; then
          echo "unlink ${orig}"
          unlink "${orig}"
        fi
      done
    } #}}}

    for linkfile in "${linkfiles[@]}"; do
      _dot_clear "${linkfile}"
    done

    unset -f _dot_clear
  } #}}}


  dot_config() { #{{{
    # init
    if [ ! -e "${dotrc}" ]; then
      cecho ${color_error} "'${dotrc}' doesn't exist."
      echo "[message] make configuration file ? (Y/n)"
      echo "${hrule}"
      echo -n ">>> "; read confirm
      if [ "${confirm}" != "n" ]; then
        echo "cp ${DOT_SCRIPT_ROOTDIR}/examples/dotrc ${dotrc}"
        cp "${DOT_SCRIPT_ROOTDIR}/examples/dotrc" "${dotrc}"
      else
        echo "Aborted."
        return 1
      fi
      unset -v confirm
    fi

    # open dotrc file
    if [ ! "${dot_edit_default_editor}" = "" ];then
      eval ${dot_edit_default_editor} "${dotrc}"
    elif hash "$EDITOR"; then
      $EDITOR "${dotrc}"
    else
      xdg-open "${dotrc}"
    fi
  } #}}}


 cleanup_namespace() { #{{{
  unset -f dotbundle usage cecho
  unset -f get_fullpath path_without_home path_without_dotdir
  unset -f dot_clone dot_pull dot_set dot_add
  unset -f dot_edit dot_unlink dot_clear dot_config
  unset -f $0
 } #}}}


  # Option handling {{{
  optstr="c:h -help"
  while getopts ${optstr} OPT
  do
    case $OPT in
      "c")
        dotrc="$OPTARG"
        source "$dotrc"
        ;;
      "h"|"-help" )
        usage
        cleanup_namespace
        return 0
        ;;
      * ) usage
        cleanup_namespace
        return 1
        ;;
    esac
  done

  shift $((OPTIND-1))

  # }}}

  # main command handling {{{
  case "$1" in
    "clone")
      shift 1; dot_clone "$@"
      ;;
    "pull")
      shift 1; dot_pull "$@"
      ;;
    "set")
      shift 1; dot_set "$@"
      ;;
    "add")
      shift 1; dot_add "$@"
      ;;
    "edit")
      shift 1; dot_edit
      ;;
    "unlink")
      shift 1; dot_unlink "$@"
      ;;
    "clear")
      shift 1; dot_clear
      ;;
    "config")
      shift 1; dot_config
      ;;
    *)
      echo "command '$1' not found."
      usage
      ;;
  esac
  # }}}


} #}}}


eval "alias ${DOT_COMMAND:="dot"}=dot_main"
export DOT_COMMAND

