function fileblocks() {
  if [[ $1 == "" || $1 == "alloc_fb" ]]; then
    source fileblocks/alloc_fb.sh $2
  fi
  if [[ $1 == "" || $1 == "free_fb" ]]; then
    source fileblocks/free_fb.sh $2
  fi
  if [[ $1 == "" || $1 == "get_fb" ]]; then
    source fileblocks/get_fb.sh $2
  fi
  if [[ $1 == "" || $1 == "write_fb" ]]; then
    source fileblocks/write_fb.sh $2
  fi
  if [[ $1 == "" || $1 == "read_fb" ]]; then
    source fileblocks/read_fb.sh $2
  fi
}
