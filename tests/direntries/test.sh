function direntries() {
  if [[ $1 == "" || $1 == "add_direntry" ]]; then
    source direntries/add_direntry.sh $2
  fi
  if [[ $1 == "" || $1 == "delete_direntry" ]]; then
    source direntries/delete_direntry.sh $2
  fi
  if [[ $1 == "" || $1 == "check_direntry" ]]; then
    source direntries/check_direntry.sh $2
  fi
  if [[ $1 == "" || $1 == "get_direntry" ]]; then
    source direntries/get_direntry.sh $2
  fi
  if [[ $1 == "" || $1 == "rename_direntry" ]]; then
    source direntries/rename_direntry.sh $2
  fi
  if [[ $1 == "" || $1 == "traverse_direntry" ]]; then
    source direntries/traverse_direntry.sh $2
  fi
}
