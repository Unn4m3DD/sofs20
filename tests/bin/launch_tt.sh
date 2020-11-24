cd ../build
make -j
cd ../bin
./createDisk /tmp/dsk 2000
./mksofs /tmp/dsk 
./testtool /tmp/dsk -b -r 221-221
