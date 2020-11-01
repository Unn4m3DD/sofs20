source ./create_disk.sh
source ./ilayer/cache_test_functions.sh
source ./ilayer/db_test_functions.sh
# alloc_db_test
# $1 db count
# $2 analysis block range begin
# $3 analysis block range end
# $4 disk size
# test for copy from insertion to retrieval cache
create_disk 40
alloc_db_bin 36
printf "fdb\n1\nq\n" | bin/testtool -q 2 -b tmp/original_disk >/dev/null
printf "fdb\n1\nq\n" | bin/testtool -q 2 -p 444-444 -b -r 444-444 tmp/disk | grep "444" | grep "31m" >/dev/null
printf "fdb\n2\nq\n" | bin/testtool -q 2 -b tmp/original_disk >/dev/null
printf "fdb\n2\nq\n" | bin/testtool -q 2 -p 444-444 -b -r 444-444 tmp/disk | grep "444" | grep "31m" >/dev/null
alloc_db_test_replenish 1 30 39 40
alloc_db_test_replenish 1 30 39 40
return
create_disk 150
replenish_test 150 2 140 149
create_disk 75
replenish_test 75 1 65 72
create_disk 1000
replenish_test 1000 10 992 999
create_disk 500
replenish_test 500 2 492 499
create_disk 982
replenish_test 982 2 972 981
create_disk 10000
replenish_test 10000 2 9980 9999

if [ "$1" != "complete" ]; then return; fi
for ((j = 10; j < 500; j += 10)); do
  printf "$j -> \n"
  create_disk $j
  replenish_test $j 2 $((j - 8)) $((j - 1)) 2>/dev/null
done
