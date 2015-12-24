# vim: ft=sh
# Local variables                                                           {{{
# -----------------------------------------------------------------------------

local clone_repository dotdir dotlink linkfiles home_pattern dotdir_pattern
local dotset_interactive dotset_verbose diffcmd edit2filecmd
local dot_edit_default_editor dotrc columns hrule

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
dotrc="${dotrc:-$dotdir/dotrc}"
dotbundle "${dotrc}"

# --------------------------------------------------------------------------}}}

# makeline {{{

columns=$(tput cols)
if [[ $columns -gt 70 ]]; then
  columns=70
fi
  hrule="$( printf '%*s\n' "$columns" '' | tr ' ' - )"

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


cleanup_namespace() { #{{{
  unset -f dotbundle get_fullpath path_without_home path_without_dotdir
  unset -f $0
} #}}}

