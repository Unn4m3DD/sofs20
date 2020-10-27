# $1 = function_number
# $2 = disk_size
# $3 = block_range_start
# $4 = block_range_end
source ./mksofs/test_function.sh
test_function 606 1000 5 5 -d
test_function 606 2000 9 9 -d

test_function 606 4 0 3 -x -z
test_function 606 20 0 19 -x -z
test_function 606 1000 0 999 -x -z


if [ "$1" != "complete" ]; then return; fi

for ((i = 4; i < 500; i++)); do
  if [ "$i" == "73" ]; then i=$((i + 1)); fi
  printf "\e[34m$i -> "
  test_function 606 $i 0 $(($i - 1)) -x
done