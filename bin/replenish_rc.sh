cd ../build
make -j
cd ../bin
./mksofs /tmp/dsk
for ((i = 0; i < 136; i++)); do
  printf "adb\nq\n" | ./testtool -b -r 441-444 -p 441-444 -q 2 /tmp/dsk
done
./testtool -b -r 441-444 -p 441-444 -q 0c /tmp/dsk