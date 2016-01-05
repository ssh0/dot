# vim:ft=sh
dot_clear() {
  local linkfile l

  _dot_clear() { #{{{
    local orig

    # extract environment variables
    orig="$(eval echo $2)"

    # path completion
    [ "${orig:0:1}" = "/" ] || orig="$HOME/$orig"

    if [ -L "${orig}" ]; then
      unlink "${orig}"
      echo "$(prmpt 1 unlink)${orig}"
    fi
  } #}}}

  for linkfile in "${linkfiles[@]}"; do
    echo "$(prmpt 4 "Loading ${linkfile} ...")"
    for l in $(grep -Ev '^#|^$' "${linkfile}"); do
      _dot_clear $(echo $l | tr ',' ' ')
    done
  done

  unset -f _dot_clear $0
}
