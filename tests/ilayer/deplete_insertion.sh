source ./create_disk.sh
source ./ilayer/cache_test_functions.sh

# deplete_test
# $1 disk size
# $2 db start
# $3 db end
# $4 start check
# $5 end check
for ((j = 10; j < 500; j += 10)); do
  printf "$j -> \n"
  create_disk $j
  replenish_bin 2
  deplete_test 0 150
done
