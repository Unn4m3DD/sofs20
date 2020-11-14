source ./fileblocks/test_functions.sh
source ./free_inodes_and_db/inode_test_functions.sh
source ./create_disk.sh

create_disk 1000
alloc_inode_bin 10 1
for ((j = 1; j < 15; j += 1)); do
  alloc_fb_bin 1 $j
  write_fb_bin 1 $j $RANDOM
  read_fb_test 1 $j
  read_fb_test 1 $(($RANDOM % 500))
done

if [ "$1" == "complete" ]; then
  for ((j = 1; j < 150; j += 1)); do
    alloc_fb_bin 1 $j
    write_fb_bin 1 $j $RANDOM
    read_fb_test 1 $j
    read_fb_test 1 $(($RANDOM % 500))
  done
fi
