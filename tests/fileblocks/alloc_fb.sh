source ./fileblocks/test_functions.sh
source ./free_inodes_and_db/inode_test_functions.sh
source ./create_disk.sh
# alloc_inode_bin
# $1 inode count
# $2 inode type (0 - random, 1 - file, 2 - dir, 3 - link)

# alloc_fb_test
# $1 inode number
# $2 fb index
# $3 analysis block range begin
# $4 analysis block range end
# $5 disk size
create_disk 1000
alloc_inode_bin 10 1
for ((j = 5; j < 500; j += 1)); do
  alloc_fb_test 1 $j 1 5 1000
done
#create_disk 1000
#alloc_fb_test 10 990 999 1000
#alloc_fb_test 10 990 999 1000
#alloc_fb_test 10 990 999 1000
#alloc_fb_test 30 990 999 1000
