# $1 = function_number
# $2 = disk_size
# $3 = block_range_start
# $4 = block_range_end
# $5 = block_type
test_function() {
  mkdir -p tmp
  bin/createDisk tmp/original_disk $2 2>/dev/null
  cp tmp/original_disk tmp/disk
  bin/mksofs -0 -b tmp/original_disk >/dev/null
  bin/mksofs -p $1-$1 -0 -b -r $1-$1 tmp/disk | grep "$1" | grep "31m" >/dev/null
  if [ $? == 0 ]; then
    echo "binary form of $1 beeing called" >>bin_detect.log
  fi
  if [ $5 != "" ]; then
    bin/showblock $5 "$3-$4" tmp/original_disk >>tmp/original_inode
    bin/showblock $5 "$3-$4" tmp/disk >>tmp/inode
  fi
  bin/showblock -x "$3-$4" tmp/original_disk >>tmp/original_inode_bin
  bin/showblock -x "$3-$4" tmp/disk >>tmp/inode_bin
  diff tmp/original_inode tmp/inode -d >>diff.log
  diff tmp/original_inode_bin tmp/inode_bin -d >>diff_bin.log
  rm -rf tmp
}
