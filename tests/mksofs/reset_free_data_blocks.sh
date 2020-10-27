# $1 = function_number
# $2 = disk_size
# $3 = block_range_start
# $4 = block_range_end
# $5 = block_type
# $6 = mksofs_flags
source ./mksofs/test_function.sh
test_function 607 4 0 3 -x -z
test_function 607 20 0 19 -x -z
test_function 607 50 0 49 -x -z
test_function 607 100 0 99 -x -z
test_function 607 10000 0 9999 -x -z
test_function 607 1000 0 999 -x -z
test_function 607 2000 0 1999 -x -z



if [ "$1" != "complete" ]; then return; fi

for ((i = 4; i < 500; i++)); do
  if [ "$i" == "73" ]; then i=$((i + 1)); fi
  printf "\e[34m$i -> "
  test_function 607 $i 0 $(($i - 1)) -x
done