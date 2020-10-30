function create_disk() { #$1 -> disk size
  rm -rf tmp
  mkdir -p tmp
  bin/createDisk tmp/original_disk $1 2>/dev/null
  bin/mksofs -0 -b tmp/original_disk >/dev/null
  cp tmp/original_disk tmp/disk
}