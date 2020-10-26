mkdir -p tmp
bin/createDisk tmp/original_disk 1000 2>/dev/null
bin/mksofs -0 -b tmp/original_disk >/dev/null
cp tmp/original_disk tmp/disk
t=1
permissions=644
printf "ai\n$t\n$permissions\nq\n" | bin/testtool -q 2 -p 401-401 -b tmp/original_disk
printf "ai\n$t\n$permissions\nq\n" | bin/testtool -q 2 -p 401-401 -b -r 401-401 tmp/disk
bin/showblock -s 0 tmp/original_disk >>tmp/original_inode
bin/showblock -s 0 tmp/disk >>tmp/inode
bin/showblock -i 1-4 tmp/original_disk >>tmp/original_inode
bin/showblock -i 1-4 tmp/disk >>tmp/inode
bin/showblock -x 0-999 tmp/original_disk >>tmp/original_inode_bin
bin/showblock -x 0-999 tmp/disk >>tmp/inode_bin
diff tmp/original_inode tmp/inode -d >>diff.log
diff tmp/original_inode_bin tmp/inode_bin -d >>diff_bin.log
rm -rf tmp
