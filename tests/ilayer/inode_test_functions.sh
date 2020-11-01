# free_inode_test
# $1 inode number begin
# $2 inode number end
# $3 analysis block range begin
# $4 analysis block range end
# $5 disk size
function free_inode_test() {
  touch bin_detect_tmp.log
  e=0
  for ((i = $1; i < $2; i++)); do
    printf "fi\n$i\nq\n" | bin/testtool -q 2 -b tmp/original_disk >/dev/null
    printf "fi\n$i\nq\n" | bin/testtool -q 2 -p 402-402 -b -r 402-402 tmp/disk | grep "402" | grep "31m" >/dev/null
    if [ $? == 0 ]; then e=1; fi
  done
  if [ $e == 1 ]; then
    echo "binary form of 443 beeing called" >>bin_detect_tmp.log
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
  test_tmp_diff_and_append 402
}

# alloc_inode
# $1 inode count
# $2 inode type (0 - random, 1 - file, 2 - dir, 3 - link)
function alloc_inode_bin() {
  inode_type="$2"
  declare -a permissions_array=(0 644 755 777)
  permission=${permissions_array[inode_type]}

  for ((i = 0; i < $1; i++)); do
    if [ "$2" == "0" ]; then
      inode_type=$(($RANDOM % 3 + 1))
      declare -a permissions_array=(0 644 755 777)
      permission=${permissions_array[inode_type]}
    fi
    printf "ai\n$inode_type\n$permission\nq\n" | bin/testtool -q 2 -b tmp/original_disk >/dev/null
    printf "ai\n$inode_type\n$permission\nq\n" | bin/testtool -q 2 -b tmp/disk >/dev/null
  done
}

# alloc_inode_test
# $1 inode count
# $2 inode type (0 - random, 1 - file, 2 - dir, 3 - link)
# $3 analysis block range begin
# $4 analysis block range end
# $5 disk size
function alloc_inode_test() {
  touch bin_detect_tmp.log
  inode_type="$2"
  declare -a permissions_array=(0 644 755 777)
  permission=${permissions_array[inode_type]}
  e=0
  for ((i = 0; i < $1; i++)); do
    if [ "$2" == "0" ]; then
      inode_type=$(($RANDOM % 3 + 1))
      declare -a permissions_array=(0 644 755 777)
      permission=${permissions_array[inode_type]}
    fi
    printf "ai\n$inode_type\n$permission\nq\n" | bin/testtool -q 2 -b tmp/original_disk >/dev/null
    printf "ai\n$inode_type\n$permission\nq\n" | bin/testtool -q 2 -p 401-401 -b -r 401-401 tmp/disk | grep "401" | grep "31m" >/dev/null
    if [ $? == 0 ]; then e=1; fi
  done
  if [ $e == 1 ]; then
    echo "binary form of 443 beeing called" >>bin_detect_tmp.log
  fi
  bin/showblock -s 0 tmp/original_disk | grep -v "atime" >>tmp/original_inode
  bin/showblock -s 0 tmp/disk | grep -v "atime" >>tmp/inode
  bin/showblock -i $3-$4 tmp/original_disk | grep -v "atime" >>tmp/original_inode
  bin/showblock -i $3-$4 tmp/disk | grep -v "atime" >>tmp/inode
  touch tmp/original_inode_bin
  touch tmp/inode_bin
  if [ $? != 0 ]; then
    bin/showblock -x "0-$(($5 - 1))" tmp/original_disk | grep -v "atime" >>tmp/original_inode_bin
    bin/showblock -x "0-$(($5 - 1))" tmp/disk | grep -v "atime" >>tmp/inode_bin
  fi
  diff tmp/original_inode tmp/inode -d >>diff_tmp.log
  diff tmp/original_inode_bin tmp/inode_bin -d >>diff_bin_tmp.log
  test_tmp_diff_and_append 401
}
