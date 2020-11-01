# replenish_test
# $1 disk size
# $2 replenish count
# $3 start check
# $4 end check
replenish_test() {
  touch bin_detect_tmp.log
  e=0
  for ((i = 0; i < (69 * $2); i++)); do
    printf "adb\nq\n" | bin/testtool -q 2 -b tmp/original_disk >/dev/null
    printf "adb\nq\n" | bin/testtool -q 2 -p 443-443 -b -r 443-443 tmp/disk | grep "443" | grep "31m" >/dev/null
    if [ $? == 0 ]; then e=1; fi
  done
  if [ $e == 1 ]; then
    echo "binary form of 443 beeing called" >>bin_detect_tmp.log
  fi
  bin/showblock -s 0 tmp/original_disk | grep -v "atime" >>tmp/original_inode
  bin/showblock -s 0 tmp/disk | grep -v "atime" >>tmp/inode
  bin/showblock -r $3-$4 tmp/original_disk | grep -v "atime" >>tmp/original_inode
  bin/showblock -r $3-$4 tmp/disk | grep -v "atime" >>tmp/inode
  touch tmp/original_inode_bin
  touch tmp/inode_bin

  bin/showblock -x "0-$(($1 - 1))" tmp/original_disk | grep -v "atime" >>tmp/original_inode_bin
  bin/showblock -x "0-$(($1 - 1))" tmp/disk | grep -v "atime" >>tmp/inode_bin

  diff tmp/original_inode tmp/inode -d >>diff_tmp.log
  diff tmp/original_inode_bin tmp/inode_bin -d >>diff_bin_tmp.log
  test_tmp_diff_and_append 443
}

# replenish_bin
# $1 replenish count
replenish_bin() {
  for ((i = 0; i < (69 * $1); i++)); do
    printf "adb\nq\n" | bin/testtool -q 2 -b tmp/original_disk &>/dev/null
    printf "adb\nq\n" | bin/testtool -q 2 -b tmp/disk &>/dev/null
  done
}

# deplete_test
# $1 disk size
# $2 db start
# $3 db end
# $4 start check
# $5 end check
deplete_test() {
  touch bin_detect_tmp.log
  e=0
  for ((i = $2; i < $3; i++)); do
    printf "fdb\n$i\nq\n" | bin/testtool -q 2 -b tmp/original_disk >/dev/null
    printf "fdb\n$i\nq\n" | bin/testtool -q 2 -p 444-444 -b -r 444-444 tmp/disk | grep "444" | grep "31m" >/dev/null
    if [ $? == 0 ]; then e=1; fi
  done
  if [ $e == 1 ]; then
    echo "binary form of 443 beeing called" >>bin_detect_tmp.log
  fi
  bin/showblock -s 0 tmp/original_disk | grep -v "atime" > a
  bin/showblock -s 0 tmp/disk | grep -v "atime" > b
  bin/showblock -r $4-$5 tmp/original_disk | grep -v "atime" >>tmp/original_inode
  bin/showblock -r $4-$5 tmp/disk | grep -v "atime" >>tmp/inode
  touch tmp/original_inode_bin
  touch tmp/inode_bin

  bin/showblock -x "0-$(($1 - 1))" tmp/original_disk | grep -v "atime" >>tmp/original_inode_bin
  bin/showblock -x "0-$(($1 - 1))" tmp/disk | grep -v "atime" >>tmp/inode_bin

  diff tmp/original_inode tmp/inode -d >>diff_tmp.log
  diff tmp/original_inode_bin tmp/inode_bin -d >>diff_bin_tmp.log
  test_tmp_diff_and_append 444
}
