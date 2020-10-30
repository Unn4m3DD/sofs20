source ./ilayer/inode_test_functions.sh
source ./create_disk.sh

#------------------------------------------------------------------
# create_disk
# $1 -> disk size
#------------------------------------------------------------------
# alloc_inode
# $1 inode count
# $2 inode type (0 - random, 1 - file, 2 - dir, 3 - link)
#------------------------------------------------------------------
# free_inode_test
# $1 inode number begin
# $2 inode number end
# $3 analysis block range begin
# $4 analysis block range end
# $5 disk size
#------------------------------------------------------------------

create_disk 1000
alloc_inode_bin 63 0
free_inode_test 0 10 1 4 1000
free_inode_test 10 20 4 63 1000
create_disk 1000
alloc_inode_bin 10 1
alloc_inode_bin 10 2
free_inode_test 0 10 1 4 1000
alloc_inode_bin 10 3
alloc_inode_bin 30 0
free_inode_test 0 10 1 4 1000

if [ "$1" != "complete" ]; then return; fi
for ((j = 11; j < 500; j += 1)); do
  if [ "$j" == "73" ]; then j=$((j + 1)); fi
  printf "$j -> \n"
  create_disk $j
  alloc_inode_bin 5 1 
  alloc_inode_bin 5 2 
  alloc_inode_bin 5 3 
  alloc_inode_bin 5 0 
  free_inode_test 0 10 1 10 $j
  free_inode_test 10 20 1 10 $j
done
