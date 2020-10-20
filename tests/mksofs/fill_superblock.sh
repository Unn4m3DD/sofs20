mkdir -p tmp
bin/createDisk tmp/original_disk 1000 2>/dev/null
bin/createDisk tmp/disk 1000 2>/dev/null
bin/mksofs -0 -b tmp/original_disk >/dev/null
bin/mksofs -p 602-602 -0 -b -r 602-602 tmp/disk | grep 602
bin/showblock -s 0 tmp/original_disk >>tmp/original_superblock
bin/showblock -s 0 tmp/disk >>tmp/superblock
diff tmp/original_superblock tmp/superblock -d >>diff.log
rm -rf tmp

mkdir -p tmp
bin/createDisk tmp/original_disk 2000 2>/dev/null
bin/createDisk tmp/disk 2000 2>/dev/null
bin/mksofs -0 -b tmp/original_disk >/dev/null
bin/mksofs -p 602-602 -0 -b -r 602-602 tmp/disk | grep 602
bin/showblock -s 0 tmp/original_disk >>tmp/original_superblock
bin/showblock -s 0 tmp/disk >>tmp/superblock
diff tmp/original_superblock tmp/superblock -d >>diff.log
rm -rf tmp
