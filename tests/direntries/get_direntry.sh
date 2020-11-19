source ./direntries/test_functions.sh
source ./free_inodes_and_db/inode_test_functions.sh
source ./create_disk.sh
source ./direntries/test_functions.sh
source ./free_inodes_and_db/inode_test_functions.sh
source ./create_disk.sh

# add_direntry_bin
# $1 parent inode number
# $2 name
# $3 child inode number

# delete_direntry_bin
# $1 parent inode number
# $2 name

# get_dir_entry_test
# $1 parent inode number
# $2 dir name

create_disk 5000
alloc_inode_bin 200 2
add_direntry_bin $(($j - 1)) "d1" $j
get_dir_entry_test 0 "d1"

create_disk 5000
alloc_inode_bin 200 2
for ((j = 1; j < 50; j++)); do
  add_direntry_bin $(($j - 1)) "d$j" $j
  get_dir_entry_test $j "d$(($j + ($RANDOM % 2)))"
done
for ((j = 1; j < 49; j++)); do
  delete_direntry_bin $j "d$(($j + 1))"
  get_dir_entry_test $j "d$(($j + ($RANDOM % 2)))"
done

create_disk 5000
alloc_inode_bin 200 2
for ((j = 1; j < 200; j++)); do
  add_direntry_bin $(($j - 1)) "d$j" $j
  get_dir_entry_test 0 "d$(($RANDOM % 200))"
done
for ((j = 1; j < 200; j++)); do
  delete_direntry_bin $(($j - 1)) "d$j"
  get_dir_entry_test 0 "d$(($RANDOM % 200))"
done
