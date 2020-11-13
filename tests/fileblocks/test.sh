function fileblocks() {
  if [[ $1 == "" || $1 == "alloc_fb" ]]; then
    source fileblocks/alloc_fb.sh $2
  fi
  if [[ $1 == "" || $1 == "free_fb" ]]; then
    source fileblocks/free_fb.sh $2
  fi
}
