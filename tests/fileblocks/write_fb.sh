source ./fileblocks/test_functions.sh
source ./free_inodes_and_db/inode_test_functions.sh
source ./create_disk.sh

# write_fb_test
# $1 inode number
# $2 fb index
# $3 pattern
# $4 disk size

create_disk 1000
alloc_inode_bin 10 1
for ((j = 1; j < 15; j += 1)); do
  alloc_fb_bin 1 $j
  write_fb_test 1 $j $RANDOM 1000
done

if [ "$1" == "complete" ]; then
  for ((j = 1; j < 150; j += 1)); do
    alloc_fb_bin 1 $j
    write_fb_test 1 $j $RANDOM 1000
  done
fi
