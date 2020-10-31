./mksofs /tmp/dsk
for ((i = 0; i < 67; i++)); do
  printf "adb\nq\n" | ./testtool -b -r 443-443 -p 443-443 -q 2 /tmp/dsk
done
./testtool -b -r 443-443 -p 443-443 -q 0 /tmp/dsk