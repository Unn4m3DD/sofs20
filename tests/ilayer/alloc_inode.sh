function create_disk() { #$1 -> disk size
  rm -rf tmp
  mkdir -p tmp
  bin/createDisk tmp/original_disk $1 2>/dev/null
  bin/mksofs -0 -b tmp/original_disk >/dev/null
  cp tmp/original_disk tmp/disk
}

# $1 inode count
# $2 inode type (0 - random, 1 - file, 2 - dir, 3 - link)
# $3 analysis block range begin
# $4 analysis block range end
# $5 disk size
#------------------------------------------------------------------
# create_disk
# $1 -> disk size
#------------------------------------------------------------------
# alloc_inode_test
# $1 inode count
# $2 inode type (0 - random, 1 - file, 2 - dir, 3 - link)
# $3 analysis block range begin
# $4 analysis block range end
# $5 disk size
#------------------------------------------------------------------

create_disk 1000
alloc_inode_test 63 0 1 4 1000
create_disk 1000
alloc_inode_test 10 1 1 4 1000
alloc_inode_test 10 2 1 4 1000
alloc_inode_test 10 3 1 4 1000
alloc_inode_test 30 0 1 4 1000

for ((j = 10; j < 500; j += 10)); do
  printf "$j -> \n"
  create_disk $j
  alloc_inode_test 5 1 1 4 $j
  alloc_inode_test 5 2 1 4 $j
  alloc_inode_test 5 3 1 4 $j
  alloc_inode_test 5 0 1 4 $j
done
