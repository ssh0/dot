# vim: ft=sh
dot_config() {
  # init
  if [ ! -e "${dotrc}" ]; then
    echo -n "[$(tput bold)$(tput setaf 1)error$(tput sgr0)] "
    echo "$(tput bold)${dotrc}$(tput sgr0) doesn't exist."
    echo -n "[$(tput bold)$(tput setaf 6)message$(tput sgr0)] "
    echo -n "make configuration file ? (Y/n)"
    read confirm
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

  unset -f $0
}
