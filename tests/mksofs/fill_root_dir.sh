mkdir -p tmp
bin/createDisk tmp/original_disk 1000 2>/dev/null
bin/createDisk tmp/disk 1000 2>/dev/null
bin/mksofs -0 -b tmp/original_disk >/dev/null
bin/mksofs -p 606-606 -0 -b -r 606-606 tmp/disk | grep 606
bin/showblock -d 5 tmp/original_disk >>tmp/original_rootdir
bin/showblock -d 5 tmp/disk >>tmp/rootdir
diff tmp/original_rootdir tmp/rootdir -d >>diff.log
bin/showblock -x 5 tmp/original_disk >>tmp/original_rootdir_hex
bin/showblock -x 5 tmp/disk >>tmp/rootdir_hex
diff tmp/original_rootdir_hex tmp/rootdir_hex -d >>diff.log

rm -rf tmp/*
bin/createDisk tmp/original_disk 2000 2>/dev/null
bin/createDisk tmp/disk 2000 2>/dev/null
bin/mksofs -0 -b tmp/original_disk >/dev/null
bin/mksofs -p 606-606 -0 -b -r 606-606 tmp/disk | grep 606
bin/showblock -d 9 tmp/original_disk >>tmp/original_rootdir
bin/showblock -d 9 tmp/disk >>tmp/rootdir
diff tmp/original_rootdir tmp/rootdir -d >>diff.log
bin/showblock -x 9 tmp/original_disk >>tmp/original_rootdir_hex
bin/showblock -x 9 tmp/disk >>tmp/rootdir_hex
diff tmp/original_rootdir_hex tmp/rootdir_hex -d >>diff.log
rm -rf tmp