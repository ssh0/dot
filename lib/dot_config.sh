# vim: ft=sh
dot_config() {
  # init
  if [ ! -e "${dotrc}" ]; then
    echo "$(prmpt 1 error)$(bd_ ${dotrc}) doesn't exist."
    echo -n "make configuration file ? "
    if __confirm y; then
      echo "cp ${DOT_SCRIPT_ROOTDIR}/examples/dotrc ${dotrc}"
      cp "${DOT_SCRIPT_ROOTDIR}/examples/dotrc" "${dotrc}"
    else
      echo "Aborted."; return 1
    fi
  fi

  # open dotrc file
  if [ ! "${dot_edit_default_editor}" = "" ];then
    eval ${dot_edit_default_editor} "${dotrc}"
  elif hash "$EDITOR"; then
    $EDITOR "${dotrc}"
  else
    xdg-open "${dotrc}"
  fi

  unset -f $0
}
