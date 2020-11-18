source ./direntries/test_functions.sh
source ./free_inodes_and_db/inode_test_functions.sh
source ./create_disk.sh

# add_direntry_test
# $1 parent inode number
# $2 name
# $3 child inode number
# $4 analysis block range begin
# $5 analysis block range end
# $6 disk size

# alloc_inode_bin
# $1 inode count
# $2 inode type (0 - random, 1 - file, 2 - dir, 3 - link)

create_disk 5000
alloc_inode_bin 200 2
for ((j = 1; j < 200; j++)); do
  echo "$j -> "
  add_direntry_test 0 "d$j" $j 9 $((9 + ($j - 3) / 16)) 5000
done
