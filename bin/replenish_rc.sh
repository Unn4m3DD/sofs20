cd ../build
make -j
cd ../bin
./mksofs /tmp/dsk
for ((i = 0; i < 68; i++)); do
  printf "adb\nq\n" | ./testtool -b -r 441-443 -p 441-443 -q 2 /tmp/dsk
done
#./testtool -b -r 441-443 -p 441-443 -q 0 /tmp/dsk