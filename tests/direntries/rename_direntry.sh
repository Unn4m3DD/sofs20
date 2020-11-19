source ./direntries/test_functions.sh
source ./free_inodes_and_db/inode_test_functions.sh
source ./create_disk.sh

# rename_direntry_test
# $1 parent inode number
# $2 old name
# $3 new name
# $4 analysis block range begin
# $5 analysis block range end
# $6 disk size

create_disk 1000
alloc_inode_bin 50 2
for ((j = 1; j < 10; j++)); do
  add_direntry_bin $(($j - 1)) "dd$j" $j 
  rename_direntry_test $(($j - 1)) "dd$j" "r$j"  5 $((5 + ($j - 3) / 16)) 1000
done
create_disk 1000
alloc_inode_bin 50 2
for ((j = 1; j < 10; j++)); do
  add_direntry_bin $(($j - 1)) "d$j" $j 
  rename_direntry_test $(($j - 1)) "d$j" "r$j"  5 $((5 + ($j - 3) / 16)) 1000
done
create_disk 1000
alloc_inode_bin 50 2
for ((j = 1; j < 10; j++)); do
  add_direntry_bin $(($j - 1)) "d$j" $j 
  rename_direntry_test $(($j - 1)) "d$j" "rr$j"  5 $((5 + ($j - 3) / 16)) 1000
done

