cd ../build
make -j
cd ../bin
./createDisk /tmp/dsk 1000
./mksofs /tmp/dsk 
./testtool /tmp/dsk -b -r 441-442 -p 441-442
