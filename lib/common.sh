# vim: ft=sh
# Local variables                                                           {{{
# -----------------------------------------------------------------------------

local clone_repository dotdir dotlink linkfiles home_pattern dotdir_pattern
local dotset_interactive dotset_verbose diffcmd edit2filecmd
local dot_edit_default_editor columns hrule tp_bold tp_reset

# --------------------------------------------------------------------------}}}
# Default settings                                                          {{{
# -----------------------------------------------------------------------------

clone_repository="${DOT_REPO:-"https://github.com/ssh0/dotfiles.git"}"

dotdir="${DOT_DIR:-"$HOME/.dotfiles"}"
dotlink="${DOT_LINK:-"$dotdir/dotlink"}"
linkfiles=("${dotlink}")

home_pattern="s@$HOME/@@p"
dotdir_pattern="s@${dotdir}/@@p"

dotset_interactive=true
dotset_verbose=false

if hash colordiff 2>/dev/null; then
  diffcmd='colordiff -u'
else
  diffcmd='diff -u'
fi

if hash vimdiff 2>/dev/null; then
  edit2filecmd='vimdiff'
else
  edit2filecmd="${diffcmd}"
fi

dot_edit_default_editor=''

# --------------------------------------------------------------------------}}}
# Load user configuration                                                   {{{
# -----------------------------------------------------------------------------


dotbundle() {
  if [ -e "$1" ]; then
    source "$1"
  fi
}

# path to the config file
dotrc="${dotrc:-"$HOME/.config/dot/dotrc"}"
dotbundle "${dotrc}"

# --------------------------------------------------------------------------}}}

# makeline {{{

columns=$(tput cols)
hrule="$( printf '%*s\n' "$columns" '' | tr ' ' - )"

#}}}


# tput {{{

tp_bold="$(tput bold)"
tp_reset="$(tput sgr0)"

#}}}


get_fullpath() { #{{{
  echo "$(builtin cd "$(dirname "$1")" && pwd)"/"$(basename "$1")"
} #}}}


path_without_home() { #{{{
  get_fullpath "$1" | sed -ne "${home_pattern}"
} #}}}


path_without_dotdir() { #{{{
  get_fullpath "$1" | sed -ne "${dotdir_pattern}"
} #}}}


__confirm() { #{{{
  # __confirm [ y | n ]
  local default="$1"
  local yn confirm
  if [ "${default}" = "y" ]; then
    yn="Y/n"
    default=0
  elif [ "${default}" = "n" ]; then
    yn="y/N"
    default=1
  else
    yn="y/n"
  fi

  echo -n "[$yn]> "
  read confirm
  if [ "${confirm}" = "" ]; then
    return $default
  elif [ "${confirm}" = "y" ]; then
    return 0
  elif [ "${confirm}" = "n" ]; then
    return 1
  else
    echo "Answer with 'y' or 'n'. Aborted."
    return 1
  fi

} #}}}


prmpt() { #{{{
  echo "[${tp_bold}$(tput setaf $1)$2${tp_reset}] "
} #}}}


bd_() { #{{{
  echo "${tp_bold}$@${tp_reset}"
} #}}}


cleanup_namespace() { #{{{
  unset -f dotbundle get_fullpath path_without_home path_without_dotdir
  unset -f __confirm prmpt bd_ $0
} #}}}

