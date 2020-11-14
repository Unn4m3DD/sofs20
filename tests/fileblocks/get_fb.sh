source ./fileblocks/test_functions.sh
source ./free_inodes_and_db/inode_test_functions.sh
source ./create_disk.sh
# alloc_inode_bin
# $1 inode count
# $2 inode type (0 - random, 1 - file, 2 - dir, 3 - link)

# get_fb_test
# $1 inode number
# $2 fb index
create_disk 1000
alloc_inode_bin 10 1
alloc_fb_bin 1 random 1 5 1000
get_fb_test 1 0
get_fb_test 1 1
get_fb_test 1 2
get_fb_test 1 3
get_fb_test 1 10
for ((j = 1; j < 200; j += 1)); do
  random=$(($RANDOM % 1000))
  alloc_fb_bin 1 random 1 5 1000
  get_fb_test 1 random
  get_fb_test 1 $(($RANDOM % 100))
done
