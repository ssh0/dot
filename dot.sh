# vim: ft=zsh
# dot - dotfiles management framework

# Version:    1.2
# Repository: https://github.com/ssh0/dotfiles.git
# Author:     ssh0 (Shotaro Fujimoto)
# License:    MIT

DOT_SCRIPT_ROOTDIR="$(builtin cd "$(dirname "${BASH_SOURCE:-${(%):-%N}}")" && pwd)"
readonly DOT_SCRIPT_ROOTDIR
export DOT_SCRIPT_ROOTDIR


dot_main() {

  dot_usage() { #{{{
    cat << EOF

NAME
      dot - manages symbolic links for dotfiles.

USAGE
      dot [-h|--help][-c|--config <configfile>] <command> [<args>]

COMMAND
      clone     Clone dotfile repository on your computer with git.

      pull      Pull remote dotfile repository (by git).

      list      Show the list which files will be managed by dot.

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
      -c,--config <configfile>
                Specify the configuration file to overload.

COMMAND OPTIONS
      clone [<dir>]
          Clone \$DOT_REPO onto the specified direction.
          default: ~/.dotfiles

      pull [--self]
          With --self option, update this script itself.

      set [-i][-v]
          -i: No interaction mode(skip all conflicts and do nothing).
          -v: Print verbose messages.

      add [-m <message>] original_file [dotfile_direction]
          -m <message>: Add your message for dotlink file.

EOF

  unset -f $0
  } #}}}

  # Option handling {{{
  local arg
  for arg in "$@"; do
    shift
    case "$arg" in
      "--help") set -- "$@" "-h" ;;
      "--config") set -- "$@" "-c" ;;
      *)        set -- "$@" "$arg" ;;
    esac
  done

  OPTIND=1
  while getopts "c:h" OPT
  do
    case $OPT in
      "c")
        dotrc="$OPTARG"
        ;;
      "h")
        dot_usage
        return 0
        ;;
      * )
        dot_usage
        return 1
        ;;
    esac
  done

  source "$DOT_SCRIPT_ROOTDIR/lib/common.sh"
  trap cleanup_namespace EXIT

  shift $((OPTIND-1))

  # }}}

  # main command handling {{{
  case "$1" in
    "clone")
      shift 1
      source "$DOT_SCRIPT_ROOTDIR/lib/dot_clone.sh"
      dot_clone "$@"
      ;;
    "pull")
      shift 1
      source "$DOT_SCRIPT_ROOTDIR/lib/dot_pull.sh"
      dot_pull "$@"
      ;;
    "list")
      shift 1
      source "$DOT_SCRIPT_ROOTDIR/lib/dot_list.sh"
      dot_list
      ;;
    "set")
      shift 1
      source "$DOT_SCRIPT_ROOTDIR/lib/dot_set.sh"
      dot_set "$@"
      ;;
    "add")
      shift 1
      source "$DOT_SCRIPT_ROOTDIR/lib/dot_add.sh"
      dot_add "$@"
      ;;
    "edit")
      shift 1
      source "$DOT_SCRIPT_ROOTDIR/lib/dot_edit.sh"
      dot_edit
      ;;
    "unlink")
      shift 1
      source "$DOT_SCRIPT_ROOTDIR/lib/dot_unlink.sh"
      dot_unlink "$@"
      ;;
    "clear")
      shift 1
      source "$DOT_SCRIPT_ROOTDIR/lib/dot_clear.sh"
      dot_clear
      ;;
    "config")
      shift 1
      source "$DOT_SCRIPT_ROOTDIR/lib/dot_config.sh"
      dot_config
      ;;
    *)
      echo -n "[$(tput bold)$(tput setaf 1)error$(tput sgr0)] "
      echo "command $(tput bold)$1$(tput sgr0) not found."
      dot_usage
      ;;
  esac

  # }}}

}


eval "alias ${DOT_COMMAND:="dot"}=dot_main"
export DOT_COMMAND

