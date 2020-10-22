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
    bin/mksofs -p $1-$1 -0 -b -r $1-$1 tmp/disk | grep "$1" | grep "31m" >/dev/null
  fi
  if [ $? == 0 ]; then
    echo "binary form of $1 beeing called" >>bin_detect_tmp.log
  fi
  if [ "$5" != "" ]; then
    bin/showblock $5 "$3-$4" tmp/original_disk >>tmp/original_inode
    bin/showblock $5 "$3-$4" tmp/disk >>tmp/inode
  fi
  bin/showblock -x "$3-$4" tmp/original_disk >>tmp/original_inode_bin
  bin/showblock -x "$3-$4" tmp/disk >>tmp/inode_bin
  diff tmp/original_inode tmp/inode -d >>diff_tmp.log
  diff tmp/original_inode_bin tmp/inode_bin -d >>diff_bin_tmp.log
  rm -rf tmp

  errors="$(cat diff_bin_tmp.log)$(cat diff_tmp.log)$(cat bin_detect_tmp.log)"
  if [ "$errors" != "" ]; then
    echo -e "\e[31mErrors detected during $1 test"
  else
    echo -e "\e[34m$1 tests passed"
  fi
  cat diff_bin_tmp.log >>diff_bin.log && rm -f diff_bin_tmp.log
  cat diff_tmp.log >>diff.log && rm -f diff_tmp.log
  cat bin_detect_tmp.log >>bin_detect.log && rm -f bin_detect_tmp.log
}
