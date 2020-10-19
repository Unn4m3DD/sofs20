mkdir -p tmp
current_dir=$(pwd)
cd ../build 
cmake ../src > /dev/null
make -j > /dev/null
cd ..
cp -r bin/ tests/bin

cd $current_dir
set echo off
original_bin/createDisk /tmp/disk 1000 2> /dev/null
original_bin/mksofs /tmp/disk > /dev/null
original_bin/showblock -i 1 /tmp/disk > tmp/original_inode
rm /tmp/disk

original_bin/createDisk /tmp/disk 1000 2> /dev/null
bin/mksofs /tmp/disk > /dev/null
original_bin/showblock -i 1 /tmp/disk > tmp/inode
rm /tmp/disk
set echo on

diff tmp/original_inode tmp/inode -u

rm -rf bin
