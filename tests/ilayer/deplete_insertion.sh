source ./create_disk.sh
source ./ilayer/cache_test_functions.sh

# deplete_test
# $1 disk size
# $2 db start
# $3 db end
# $4 start check
# $5 end check
for ((j = 75; j < 76; j += 10)); do
  printf "$j -> \n"
  create_disk $j
  replenish_bin 2 2> /dev/null
  deplete_test $j 1 71 $((j - 8)) $((j - 1)) 2> /dev/null
done
return
for ((j = 75; j < 500; j += 10)); do
  printf "$j -> \n"
  create_disk $j
  replenish_bin 2 2> /dev/null
  deplete_test $j 1 71 $((j - 8)) $((j - 1)) #2> /dev/null
done
