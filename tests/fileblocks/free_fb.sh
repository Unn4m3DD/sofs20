source ./fileblocks/test_functions.sh
source ./free_inodes_and_db/inode_test_functions.sh
source ./create_disk.sh
# alloc_inode_bin
# $1 inode count
# $2 inode type (0 - random, 1 - file, 2 - dir, 3 - link)

# free_fb_test
# $1 inode number
# $2 fb index
# $3 analysis block range begin
# $4 analysis block range end
# $5 disk size

echo "free fileblock cannot be tested comparing to the binaries because they delete the blocks in a differente order"
return

create_disk 1000
alloc_inode_bin 10 1
for ((j = 1; j < 50; j += 1)); do
  alloc_fb_bin 1 $j
done
free_fb_test 1 3 1 8 1000

create_disk 1000
alloc_inode_bin 10 1
for ((j = 1; j < 5; j += 1)); do
  alloc_fb_bin 1 $j
done
free_fb_test 1 4 1 8 1000


create_disk 1000
alloc_inode_bin 10 1
for ((j = 1; j < 3; j += 1)); do
  alloc_fb_bin 1 $j
done
free_fb_test 1 1 1 8 1000

create_disk 1000
alloc_inode_bin 10 1
for ((j = 1; j < 200; j += 1)); do
  alloc_fb_bin 1 $j
done
for ((j = 200; j > 2; j -= 1)); do
  free_fb_test 1 $j 1 8 1000
done
