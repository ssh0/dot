# vim: ft=sh
dot_list() {
  local linkfile l

  for linkfile in "${linkfiles[@]}"; do
    echo "$(prmpt 4 "From ${linkfile}")"
    grep -Ev '^\s*#|^\s*$' "${linkfile}"
  done

  unset -f $0
}
