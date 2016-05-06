# vim: ft=sh
dot_update() {
  source "$DOT_SCRIPT_ROOTDIR/lib/dot_pull.sh"
  source "$DOT_SCRIPT_ROOTDIR/lib/dot_set.sh"
  dot_pull
  dot_set $@

  unset -f $0
}
