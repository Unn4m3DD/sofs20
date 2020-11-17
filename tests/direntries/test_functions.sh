# traverse_path_test
# $1 inode number
# $2 analysis block range begin
# $3 analysis block range end
# $4 disk size
function traverse_path_test() {
  touch bin_detect_tmp.log
  e=0
  printf "tp\n$1\nq\n" | bin/testtool -q 2 -b tmp/original_disk >>tmp/original_inode
  printf "tp\n$1\nq\n" | bin/testtool -q 2 -p 221-221 -b -r 221-221 tmp/disk | grep "inode number = " >>tmp/inode
  bin/showblock -i $2-$3 tmp/original_disk | grep -v "atime" >>tmp/original_inode
  bin/showblock -i $2-$3 tmp/disk | grep -v "atime" >>tmp/inode
  touch tmp/original_inode_bin
  touch tmp/inode_bin

  bin/showblock -x "0-$(($4 - 1))" tmp/original_disk | grep -v "atime" >>tmp/original_inode_bin
  bin/showblock -x "0-$(($4 - 1))" tmp/disk | grep -v "atime" >>tmp/inode_bin

  diff tmp/original_inode tmp/inode -d >>diff_tmp.log
  diff tmp/original_inode_bin tmp/inode_bin -d >>diff_bin_tmp.log
  test_tmp_diff_and_append 221
}

# add_direntry_test
# $1 parent inode number
# $2 name
# $3 child inode number
# $4 analysis block range begin
# $5 analysis block range end
# $6 disk size
function add_direntry_test() {
  touch bin_detect_tmp.log
  e=0
  printf "ade\n$1\n$2\n$3\nq\n" | bin/testtool -q 2 -b tmp/original_disk # >/dev/null
  printf "ade\n$1\n$2\n$3\nq\n" | bin/testtool -q 2 -p 202-202 -b -r 202-202 tmp/disk | grep "303" | grep "31m" >/dev/null
  if [ $? == 0 ]; then e=1; fi
  if [ $e == 1 ]; then
    echo "binary form of 202 beeing called" >>bin_detect_tmp.log
  fi
  bin/showblock -d $4-$5 tmp/original_disk | grep -v "atime" >>tmp/original_inode
  bin/showblock -d $4-$5 tmp/disk | grep -v "atime" >>tmp/inode
  touch tmp/original_inode_bin
  touch tmp/inode_bin

  bin/showblock -x "0-$(($6 - 1))" tmp/original_disk | grep -v "atime" >>tmp/original_inode_bin
  bin/showblock -x "0-$(($6 - 1))" tmp/disk | grep -v "atime" >>tmp/inode_bin

  diff tmp/original_inode tmp/inode -d >>diff_tmp.log
  diff tmp/original_inode_bin tmp/inode_bin -d >>diff_bin_tmp.log
  test_tmp_diff_and_append 202
}
