# vim:ft=sh
dot_clear() {
  local linkfile

  _dot_clear() { #{{{
    local l

    for l in $(grep -Ev '^#' "$1" | grep -Ev '^$'); do
      local orig="$(eval echo "$l" | awk 'BEGIN {FS=","; }  { print $2; }')"
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
  unset -f $0
}
