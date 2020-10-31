source ./create_disk.sh
# replenish_test
# $1 disk size
# $2 replenish count
# $3 start check
# $4 end check
function replenish_test() {
  touch bin_detect_tmp.log

  for ((i = 0; i < (70 * $2); i++)); do
    printf "ai\nq\n" | bin/testtool -q 2 -b tmp/original_disk >/dev/null
    printf "ai\nq\n" | bin/testtool -q 2 -p 443-443 -b -r 443-443 tmp/disk | grep "443" | grep "31m" >/dev/null
  done
  if [ $? == 0 ]; then
    echo "binary form of 443 beeing called" >>bin_detect_tmp.log
  fi
  bin/showblock -s 0 tmp/original_disk | grep -v "atime" >>tmp/original_inode
  bin/showblock -s 0 tmp/disk | grep -v "atime" >>tmp/inode
  bin/showblock -i $3-$4 tmp/original_disk | grep -v "atime" >>tmp/original_inode
  bin/showblock -i $3-$4 tmp/disk | grep -v "atime" >>tmp/inode
  touch tmp/original_inode_bin
  touch tmp/inode_bin
  if [ $? != 0 ]; then
    bin/showblock -x "0-$(($1 - 1))" tmp/original_disk | grep -v "atime" >>tmp/original_inode_bin
    bin/showblock -x "0-$(($1 - 1))" tmp/disk | grep -v "atime" >>tmp/inode_bin
  fi
  diff tmp/original_inode tmp/inode -d >>diff_tmp.log
  diff tmp/original_inode_bin tmp/inode_bin -d >>diff_bin_tmp.log
  test_tmp_diff_and_append 443
}


create_disk 1000
replenish_test 1000 2 992 999