function free_inodes_and_db() {
  if [[ $1 == "" || $1 == "alloc_inode" ]]; then
    source free_inodes_and_db/alloc_inode.sh $2
  fi

  if [[ $1 == "" || $1 == "free_inode" ]]; then
    source free_inodes_and_db/free_inode.sh $2
  fi

  if [[ $1 == "" || $1 == "alloc_db" ]]; then
    source free_inodes_and_db/alloc_db.sh $2
  fi

  if [[ $1 == "" || $1 == "free_db" ]]; then
    source free_inodes_and_db/free_db.sh $2
  fi

  if [[ $1 == "" || $1 == "replenish_retrieval" ]]; then
    source free_inodes_and_db/replenish_retrieval.sh $2
  fi

  if [[ $1 == "" || $1 == "deplete_insertion" ]]; then
    source free_inodes_and_db/deplete_insertion.sh $2
  fi
}
