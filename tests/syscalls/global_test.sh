source ./create_disk.sh
source ./syscalls/populate_fs.sh
create_disk 2000
mkdir -p tmp/mount_bin
mkdir -p tmp/mount_grp
tree tmp

bin/sofsmount -b tmp/original_disk tmp/mount_bin
tree tmp

bin/sofsmount -w -a 202-202 tmp/disk tmp/mount_grp
tree tmp

sleep 2
populate_fs tmp/mount_bin
populate_fs tmp/mount_grp

sleep 1
sudo umount tmp/mount_bin
sudo umount tmp/mount_grp

bin/showblock -s 0-0 tmp/original_disk >>tmp/inodes_bin
bin/showblock -s 0-0 tmp/disk >>tmp/inodes_grp

bin/showblock -i 1-9 tmp/original_disk | grep -v "atime" >>tmp/inodes_bin
bin/showblock -i 1-9 tmp/disk | grep -v "atime" >>tmp/inodes_grp

bin/showblock -d 9-1992 tmp/original_disk >>tmp/inodes_bin
bin/showblock -d 9-1992 tmp/disk >>tmp/inodes_grp


bin/showblock -r 1992-1999 tmp/original_disk >>tmp/inodes_bin
bin/showblock -r 1992-1999 tmp/disk >>tmp/inodes_grp

bin/showblock -x 0-0 tmp/original_disk >>tmp/disk_bin
bin/showblock -x 0-0 tmp/disk >>tmp/disk_grp

bin/showblock -x 9-1999 tmp/original_disk >>tmp/disk_bin
bin/showblock -x 9-1999 tmp/disk >>tmp/disk_grp

diff tmp/disk_bin tmp/disk_grp >> diff_bin.log
diff tmp/inodes_bin tmp/inodes_grp >>  diff.log
