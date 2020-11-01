cd ../build
make -j
cd ../bin
./mksofs /tmp/dsk
for ((i = 0; i < 70; i++)); do
  printf "adb\nq\n" | ./testtool -b -r 441-444 -p 441-444 -q 2 /tmp/dsk
done
for ((i = 1; i < 69; i++)); do
  printf "fdb\n$i\nq\n" | ./testtool -b -r 441-444 -p 441-444 -q 2 /tmp/dsk
done
./testtool -b -r 441-444 -p 441-444 -q 0 /tmp/dsk