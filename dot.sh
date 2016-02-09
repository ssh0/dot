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
dot - manages symbolic links for dotfiles.

USAGE:  dot [OPTIONS] <COMMANDS> [<args>]

COMMANDS:
      clone      Clone dotfile repository on your computer with git.
      pull       Pull the directory from the remote dotfiles repository.
      cd         Change directory to 'dotdir'.
      list       Show the list which files will be managed by dot.
      set        Set the symbolic links interactively.
      add        Move the file to the dotfiles directory and make its symbolic link to that place.
      edit       Edit dotlink file.
      unlink     Unlink the selected symbolic links and copy from its original.
      clear      Remove the all symbolic links in 'dotlink'.
      config     Edit (or create if it doesn't exist) rcfile 'dotrc'.

OPTIONS:
      -h,--help  Show this help message.
      -H,--help-all
                 Show man page.
      -c,--config <configfile>
                 Specify the configuration file to load.
                 default: ''

If you want to know more about dot,
    dot --help-all

EOF

  unset -f $0
  } #}}}

  # Option handling {{{
  local arg
  for arg in "$@"; do
    shift
    case "$arg" in
      "--help") set -- "$@" "-h" ;;
      "--help-all") set -- "$@" "-H" ;;
      "--config") set -- "$@" "-c" ;;
      *)        set -- "$@" "$arg" ;;
    esac
  done

  OPTIND=1
  while getopts "c:hH" OPT
  do
    case $OPT in
      "c")
        dotrc="$OPTARG"
        ;;
      "h")
        dot_usage
        return 0
        ;;
      "H")
        man "${DOT_SCRIPT_ROOTDIR}/doc/dot.1"
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
    "cd")
      source "$DOT_SCRIPT_ROOTDIR/lib/dot_cd.sh"
      dot_cd
      ;;
    *)
      echo -n "[$(tput bold)$(tput setaf 1)error$(tput sgr0)] "
      echo "command $(tput bold)$1$(tput sgr0) not found."
      dot_usage
      return 1
      ;;
  esac

  # }}}

}


eval "alias ${DOT_COMMAND:="dot"}=dot_main"
export DOT_COMMAND

