source ./direntries/test_functions.sh
source ./free_inodes_and_db/inode_test_functions.sh
source ./create_disk.sh

# add_direntry_bin
# $1 parent inode number
# $2 name
# $3 child inode number

# delete_direntry_test
# $1 parent inode number
# $2 name
# $3 analysis block range begin
# $4 analysis block range end
# $5 disk size

create_disk 5000
alloc_inode_bin 200 2
for ((j = 1; j < 200; j++)); do
  add_direntry_bin $(($j - 1)) "d$j" $j
done
for ((j = 1; j < 200; j++)); do
  delete_direntry_test $(($j - 1)) "d$j" 9 $((9 + 201 - $j)) 5000
done
return

create_disk 5000
alloc_inode_bin 200 2
for ((j = 1; j < 200; j++)); do
  add_direntry_bin 0 "d$j" $j
done
for ((j = 1; j < 200; j++)); do
  delete_direntry_test 0 "d$j" 9 $((9 + (200 - $j + 15) / 16)) 5000
done
