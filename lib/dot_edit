# vim: ft=sh
dot_edit() { 
  # init
  if [ ! -e "${dotlink}" ]; then
    echo "[$(tput bold)$(tput setaf 1)empty$(tput sgr0)] $(tput bold)${dotlink}$(tput sgr0)"
    echo -n "[$(tput bold)$(tput setaf 6)message$(tput sgr0)] "
    echo -n "make dotlink file ? (Y/n)"
    read confirm
    if [ "${confirm}" != "n" ]; then
      echo "cp ${DOT_SCRIPT_ROOTDIR}/examples/dotlink ${dotlink}"
      cp "${DOT_SCRIPT_ROOTDIR}/examples/dotlink" "${dotlink}"
    else
      echo "Aborted."
      return 1
    fi
    unset -v confirm
  fi

  # open dotlink file
  if [ -n "${dot_edit_default_editor}" ];then
    eval ${dot_edit_default_editor} "${dotlink}"
  elif hash "$EDITOR" 2>/dev/null; then
    $EDITOR "${dotlink}"
  else
    xdg-open "${dotlink}"
  fi

  unset -f $0
} 
