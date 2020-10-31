source ./create_disk.sh
source ./ilayer/cache_test_functions.sh
create_disk 1000
replenish_test 1000 2 992 999
create_disk 500
replenish_test 500 2 492 499
create_disk 4
replenish_test 4 2 0 0
create_disk 73
replenish_test 73 2 65 72
create_disk 982
replenish_test 982 2 972 981
create_disk 10000
replenish_test 10000 2 9980 9999

if [ "$1" != "complete" ]; then return; fi
for ((j = 10; j < 500; j += 10)); do
  printf "$j -> \n"
  create_disk $j
  replenish_test $j 2 $((j - 8)) $((j - 1))
done
