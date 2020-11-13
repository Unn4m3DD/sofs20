# alloc_fb_test
# $1 inode number
# $2 fb index
# $3 analysis block range begin
# $4 analysis block range end
# $5 disk size
function alloc_fb_test() {
  touch bin_detect_tmp.log

  printf "afb\n$1\n$2\nq\n" | bin/testtool -q 2 -b tmp/original_disk >/dev/null
  printf "afb\n$1\n$2\nq\n" | bin/testtool -q 2 -p 302-302 -b -r 302-302 tmp/disk | grep "302" | grep "31m" >/dev/null
  if [ $? == 0 ]; then
    echo "binary form of 302 beeing called" >>bin_detect_tmp.log
  fi
  bin/showblock -s 0 tmp/original_disk | grep -v "atime" >>tmp/original_inode
  bin/showblock -s 0 tmp/disk | grep -v "atime" >>tmp/inode
  bin/showblock -i $3-$4 tmp/original_disk | grep -v "atime" >>tmp/original_inode
  bin/showblock -i $3-$4 tmp/disk | grep -v "atime" >>tmp/inode
  touch tmp/original_inode_bin
  touch tmp/inode_bin

  #bin/showblock -x "0-$(($5 - 1))" tmp/original_disk | grep -v "atime" >>tmp/original_inode_bin
  #bin/showblock -x "0-$(($5 - 1))" tmp/disk | grep -v "atime" >>tmp/inode_bin

  diff tmp/original_inode tmp/inode -d >>diff_tmp.log
  diff tmp/original_inode_bin tmp/inode_bin -d >>diff_bin_tmp.log
  test_tmp_diff_and_append 302
}

# alloc_fb_bin
# $1 inode number
# $2 fb index
function alloc_fb_bin() {
  printf "afb\n$1\n$2\nq\n" | bin/testtool -q 2 -b tmp/original_disk >/dev/null
  printf "afb\n$1\n$2\nq\n" | bin/testtool -q 2 -b tmp/disk >/dev/null
}


# free_fb_test
# $1 inode number
# $2 fb index
# $3 analysis block range begin
# $4 analysis block range end
# $5 disk size
function free_fb_test() {
  touch bin_detect_tmp.log
  e=0
  printf "ffb\n$1\n$2\nq\n" | bin/testtool -q 2 -b tmp/original_disk >/dev/null
  printf "ffb\n$1\n$2\nq\n" | bin/testtool -q 2 -p 303-303 -b -r 303-303 tmp/disk | grep "303" | grep "31m" >/dev/null
  if [ $? == 0 ]; then e=1; fi
  if [ $e == 1 ]; then
    echo "binary form of 303 beeing called" >>bin_detect_tmp.log
  fi
  bin/showblock -s 0 tmp/original_disk | grep -v "atime" >>tmp/original_inode
  bin/showblock -s 0 tmp/disk | grep -v "atime" >>tmp/inode
  bin/showblock -i $3-$4 tmp/original_disk | grep -v "atime" >>tmp/original_inode
  bin/showblock -i $3-$4 tmp/disk | grep -v "atime" >>tmp/inode
  touch tmp/original_inode_bin
  touch tmp/inode_bin

  bin/showblock -x "0-$(($5 - 1))" tmp/original_disk | grep -v "atime" >>tmp/original_inode_bin
  bin/showblock -x "0-$(($5 - 1))" tmp/disk | grep -v "atime" >>tmp/inode_bin

  diff tmp/original_inode tmp/inode -d >>diff_tmp.log
  diff tmp/original_inode_bin tmp/inode_bin -d >>diff_bin_tmp.log
  test_tmp_diff_and_append 303
}
