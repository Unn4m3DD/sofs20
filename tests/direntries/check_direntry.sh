source ./direntries/test_functions.sh
source ./free_inodes_and_db/inode_test_functions.sh
source ./create_disk.sh

# delete_direntry_bin
# $1 parent inode number
# $2 name

# add_direntry_bin
# $1 parent inode number
# $2 name
# $3 child inode number

# check_dir_empty_test
# $1 parent inode number

create_disk 5000
alloc_inode_bin 50 2
for ((j = 1; j < 50; j++)); do
  add_direntry_bin 0 "d$j" $j
  check_dir_empty_test "$(($RANDOM % (50 - $j)))"
done
for ((j = 1; j < 50; j++)); do
  delete_direntry_bin 0 "d$j"
  check_dir_empty_test "$(($RANDOM % (50 - $j)))"
done
