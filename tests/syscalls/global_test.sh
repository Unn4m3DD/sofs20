source ./create_disk.sh
source ./syscalls/populate_fs.sh
create_disk 2000
mkdir tmp/mount_bin
mkdir tmp/mount_grp

bin/sofsmount -b -r 303-303 tmp/original_disk tmp/mount_bin
bin/sofsmount -b -r 303-303 tmp/disk tmp/mount_grp

populate_fs tmp/mount/bin
populate_fs tmp/mount/mount_grp

umount tmp/mount_bin
umount tmp/mount_grp

bin/showblock -x 0-2000 tmp/original_disk >>tmp/original_inode_bin
bin/showblock -x 0-2000 tmp/disk >>tmp/inode_bin
diff tmp/original_inode_bin tmp/inode_bin
