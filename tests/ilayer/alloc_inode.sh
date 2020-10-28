function create_disk() { #$1 -> disk size
  rm -rf tmp
  mkdir -p tmp
  bin/createDisk tmp/original_disk $1 2>/dev/null
  bin/mksofs -0 -b tmp/original_disk >/dev/null
  cp tmp/original_disk tmp/disk
}

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

  for ((i = 0; i < $1; i++)); do
    if [ "$2" == "0" ]; then
      inode_type=$(($RANDOM % 3 + 1))
      declare -a permissions_array=(0 644 755 777)
      permission=${permissions_array[inode_type]}
    fi
    printf "ai\n$inode_type\n$permission\nq\n" | bin/testtool -q 2 -b tmp/original_disk >/dev/null
    printf "ai\n$inode_type\n$permission\nq\n" | bin/testtool -q 2 -p 401-401 -b -r 401-401 tmp/disk | grep "401" | grep "31m" >/dev/null
  done
  if [ $? == 0 ]; then
    echo "binary form of $1 beeing called" >>bin_detect_tmp.log
  fi
  bin/showblock -s 0 tmp/original_disk >>tmp/original_inode
  bin/showblock -s 0 tmp/disk >>tmp/inode
  bin/showblock -i $3-$4 tmp/original_disk >>tmp/original_inode
  bin/showblock -i $3-$4 tmp/disk >>tmp/inode
  bin/showblock -x "0-$(($5 - 1))" tmp/original_disk >>tmp/original_inode_bin
  bin/showblock -x "0-$(($5 - 1))" tmp/disk >>tmp/inode_bin
  diff tmp/original_inode tmp/inode -d >>diff_tmp.log
  diff tmp/original_inode_bin tmp/inode_bin -d >>diff_bin_tmp.log
  test_tmp_diff_and_append 401

}
#$1 -> disk size
create_disk 1000
# $1 inode count
# $2 inode type (0 - random, 1 - file, 2 - dir, 3 - link)
# $3 analysis block range begin
# $4 analysis block range end
# $5 disk size
alloc_inode_test 63 0 1 4 1000
create_disk 1000
alloc_inode_test 10 1 1 4 1000
alloc_inode_test 10 2 1 4 1000
alloc_inode_test 10 3 1 4 1000
alloc_inode_test 30 0 1 4 1000

for ((j = 10; j < 500; j += 10)); do
  printf "$j -> \n"
  create_disk $j
  alloc_inode_test 5 1 1 4 $j;
  alloc_inode_test 5 2 1 4 $j;
  alloc_inode_test 5 3 1 4 $j;
  alloc_inode_test 5 0 1 4 $j;
done
