source ./direntries/test_functions.sh
source ./free_inodes_and_db/inode_test_functions.sh
source ./create_disk.sh
# traverse_path_test
# $1 path

# get_dir_entry_test
# $1 parent inode number
# $2 dir name

# delete_direntry_bin
# $1 parent inode number
# $2 


create_disk 1000
alloc_inode_bin 50 2
for ((j = 1; j < 10; j++)); do
  add_direntry_bin $(($j - 1)) "dd$j" $j 
done
traverse_path_test "/"
traverse_path_test "/dd1"
traverse_path_test "/dd1/dd2"
traverse_path_test "/dd1/dd2/dd3/dd4/dd5/dd6/dd7/dd8/dd9"
traverse_path_test "/dd1/dd2/dd3/dd4/dd5/dd6/dd8/dd9"
return
create_disk 1000
alloc_inode_bin 50 2
for ((j = 1; j < 10; j++)); do
  add_direntry_bin $(($j - 1)) "d$j" $j 
done
create_disk 1000
alloc_inode_bin 50 2
for ((j = 1; j < 10; j++)); do
  add_direntry_bin $(($j - 1)) "d$j" $j 
done

