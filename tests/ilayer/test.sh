function test_ilayer() {
  if [[ $1 == "" || $1 == "alloc_inode" ]]; then
    source ilayer/alloc_inode.sh $2
  fi

  if [[ $1 == "" || $1 == "free_inode" ]]; then
    source ilayer/free_inode.sh $2
  fi

  if [[ $1 == "" || $1 == "alloc_db" ]]; then
    source ilayer/alloc_db.sh $2
  fi

  if [[ $1 == "" || $1 == "free_db" ]]; then
    source ilayer/free_db.sh $2
  fi

  if [[ $1 == "" || $1 == "replenish_retrieval" ]]; then
    source ilayer/replenish_retrieval.sh $2
  fi

  if [[ $1 == "" || $1 == "deplete_insertion" ]]; then
    source ilayer/deplete_insertion.sh $2
  fi
}
