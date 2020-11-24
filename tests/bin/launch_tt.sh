cd ../build
make -j
cd ../bin
./createDisk /tmp/dsk 20000
./mksofs /tmp/dsk 
./testtool /tmp/dsk -b -r 221-221
