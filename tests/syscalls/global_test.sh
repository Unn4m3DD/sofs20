source ./create_disk.sh
source ./syscalls/populate_fs.sh

# [401] - Alloc Inode
# [402] - Free Inode
# [441] - Alloc Data Block
# [442] - Free Data Block
# [443] - Replenish Retrieval cache
# [444] - Deplete Insertion cache
# [301] - Get File Block
# [302] - Alloc File Block
# [303] - Free File Blocks
# [331] - Read File Block
# [332] - Write File Block
# [201] - Get Dir Entry // TODO test it
# [202] - Add Dir Entry
# [203] - Delete Dir Entry
# [204] - Rename Dir Entry
# [205] - Check Directory Emptiness
# [221] - Traverse Path
declare -a functions=(0 401 402 441 442 443 444 301 302 303 331 332 201 202 203 204 205 221)

for ((z = 0; z < ${#functions[@]}; z++)); do
  echo "all bin with ${functions[$z]}grp"
  create_disk 20000
  mkdir -p tmp/mount_bin
  mkdir -p tmp/mount_grp

  bin/sofsmount -b tmp/original_disk tmp/mount_bin

  bin/sofsmount -b -r ${functions[$z]}-${functions[$z]} tmp/disk tmp/mount_grp

  sleep 1
  populate_fs tmp/mount_bin
  populate_fs tmp/mount_grp

  sleep 2
  sudo umount tmp/mount_bin
  sudo umount tmp/mount_grp

  bin/showblock -s 0-0 tmp/original_disk >>tmp/inodes_bin
  bin/showblock -s 0-0 tmp/disk >>tmp/inodes_grp

  bin/showblock -i 1-80 tmp/original_disk | grep -v "atime" >>tmp/inodes_bin
  bin/showblock -i 1-80 tmp/disk | grep -v "atime" >>tmp/inodes_grp

  bin/showblock -d 81-1992 tmp/original_disk >>tmp/inodes_bin
  bin/showblock -d 81-1992 tmp/disk >>tmp/inodes_grp

  bin/showblock -r 1992-1999 tmp/original_disk >>tmp/inodes_bin
  bin/showblock -r 1992-1999 tmp/disk >>tmp/inodes_grp

  bin/showblock -x 0-0 tmp/original_disk >>tmp/disk_bin
  bin/showblock -x 0-0 tmp/disk >>tmp/disk_grp

  bin/showblock -x 81-1999 tmp/original_disk >>tmp/disk_bin
  bin/showblock -x 81-1999 tmp/disk >>tmp/disk_grp

  diff tmp/disk_bin tmp/disk_grp >>diff_bin_tmp.log
  diff tmp/inodes_bin tmp/inodes_grp >>diff_tmp.log
  touch bin_detect_tmp.log
  test_tmp_diff_and_append global
done

for ((z = 0; z < ${#functions[@]}; z++)); do
  echo "all grp with ${functions[$z]}bin ->"
  create_disk 20000
  mkdir -p tmp/mount_bin
  mkdir -p tmp/mount_grp

  bin/sofsmount -b tmp/original_disk tmp/mount_bin

  bin/sofsmount -w -a 303-303 -a ${functions[$z]}-${functions[$z]} tmp/disk tmp/mount_grp

  sleep 1
  populate_fs tmp/mount_bin
  populate_fs tmp/mount_grp

  sleep 2
  sudo umount tmp/mount_bin
  sudo umount tmp/mount_grp

  bin/showblock -s 0-0 tmp/original_disk >>tmp/inodes_bin
  bin/showblock -s 0-0 tmp/disk >>tmp/inodes_grp

  bin/showblock -i 1-80 tmp/original_disk | grep -v "atime" >>tmp/inodes_bin
  bin/showblock -i 1-80 tmp/disk | grep -v "atime" >>tmp/inodes_grp

  bin/showblock -d 81-1992 tmp/original_disk >>tmp/inodes_bin
  bin/showblock -d 81-1992 tmp/disk >>tmp/inodes_grp

  bin/showblock -r 1992-1999 tmp/original_disk >>tmp/inodes_bin
  bin/showblock -r 1992-1999 tmp/disk >>tmp/inodes_grp

  bin/showblock -x 0-0 tmp/original_disk >>tmp/disk_bin
  bin/showblock -x 0-0 tmp/disk >>tmp/disk_grp

  bin/showblock -x 81-1999 tmp/original_disk >>tmp/disk_bin
  bin/showblock -x 81-1999 tmp/disk >>tmp/disk_grp

  diff tmp/disk_bin tmp/disk_grp >>diff_bin_tmp.log
  diff tmp/inodes_bin tmp/inodes_grp >>diff_tmp.log
  touch bin_detect_tmp.log
  test_tmp_diff_and_append global
done