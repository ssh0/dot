# vim: ft=sh
dot_dialog() {
  # * use "dialog" command
  # * choose operation interactively

  dialog --backtitle "dot 1.3.0 - Your dotfiles manager" --hfile testing \
    --no-shadow --scrollbar --colors \
    --menu "\ZbChoose the operation\ZB" 18 80 11 \
    "add" "Move the file to the dotfiles directory and make its symbolic link to that place." \
    "cd" "Change directory to 'dotdir'." \
    "check" "Check the files are correctly linked to the right places." \
    "clear" "Remove the all symbolic links in 'dotlink'." \
    "config" "Edit (or create if it does not exist) rcfile 'dotrc'." \
    "edit" "Edit dotlink file." \
    "list" "Show the list which files will be managed by dot." \
    "pull" "Pull the directory from the remote dotfiles repository." \
    "set" "Set the symbolic links interactively." \
    "unlink" "Unlink the selected symbolic links and copy from its original." \
    "update" "Combined command of 'pull' and 'set' commands." \
    && clear
}
