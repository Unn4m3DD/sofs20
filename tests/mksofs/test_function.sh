# $1 = function_number
# $2 = disk_size
# $3 = block_range_start
# $4 = block_range_end
# $5 = block_type
# $6 = mksofs_flags
test_function() {
  mkdir -p tmp
  touch bin_detect_tmp.log
  bin/createDisk tmp/original_disk $2 2>/dev/null
  cp tmp/original_disk tmp/disk

  if [ "$6" != "" ]; then
    bin/mksofs "$6" -0 -b tmp/original_disk >/dev/null
    bin/mksofs "$6" -p $1-$1 -0 -b -r $1-$1 tmp/disk | grep "$1" | grep "31m" >/dev/null
  else
    bin/mksofs -0 -b tmp/original_disk >/dev/null
    bin/mksofs -p $1-$1 -0 -b -r $1-$1 tmp/disk 
  fi
  if [ $? == 0 ]; then
    echo "binary form of $1 beeing called" >>bin_detect_tmp.log
  fi
  isPerm=0
  if [ "$5" != "" ]; then
    bin/showblock $5 "$3-$4" tmp/original_disk | grep -v "permissions" >tmp/original_inode
    bin/showblock $5 "$3-$4" tmp/disk | grep -v "permissions" >tmp/inode
    if [ $? == 0 ]; then isPerm=1; fi
  fi
  bin/showblock -s 0-0 tmp/original_disk >a
  bin/showblock -s 0-0 tmp/disk >b
  touch tmp/original_inode_bin
  touch tmp/inode_bin
  if [ isPerm == 1 ]; then
    bin/showblock -x "$3-$4" tmp/original_disk >>tmp/original_inode_bin
    bin/showblock -x "$3-$4" tmp/disk >>tmp/inode_bin
  fi
  diff tmp/original_inode tmp/inode -d >>diff_tmp.log
  diff tmp/original_inode_bin tmp/inode_bin -d >>diff_bin_tmp.log
  rm -rf tmp

  test_tmp_diff_and_append $1
}
