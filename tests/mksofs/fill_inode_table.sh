mkdir -p tmp
bin/createDisk tmp/original_disk 1000 2>/dev/null
bin/createDisk tmp/disk 1000 2>/dev/null
bin/mksofs -0 -b tmp/original_disk >/dev/null
bin/mksofs -p 604-604 -0 -b -r 604-604 tmp/disk | grep 604
for i in $(seq 1 4); do
  bin/showblock -i $i tmp/original_disk >>tmp/original_inode
  bin/showblock -i $i tmp/disk >>tmp/inode
done
diff tmp/original_inode tmp/inode -d >>diff.log

if [ "$(diff tmp/original_disk tmp/disk)" != "" ] 
then
  printf "fill_inode_table failed on test 1\n" >> bin_diff.log 
fi

rm -rf tmp

mkdir -p tmp
bin/createDisk tmp/original_disk 2000 2>/dev/null
bin/createDisk tmp/disk 2000 2>/dev/null
bin/mksofs -0 -b tmp/original_disk >/dev/null
bin/mksofs -p 604-604 -0 -b -r 604-604 tmp/disk | grep 604
for i in $(seq 1 8); do
  bin/showblock -i $i tmp/original_disk >>tmp/original_inode
  bin/showblock -i $i tmp/disk >>tmp/inode
done
diff tmp/original_inode tmp/inode -d >>diff.log
diff tmp/original_disk tmp/disk
if [ "$(diff tmp/original_disk tmp/disk)" != "" ] 
then
  printf "fill_inode_table failed on test 2\n" >> bin_diff.log 
fi
rm -rf tmp
