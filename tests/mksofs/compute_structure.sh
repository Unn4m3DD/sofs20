# $1 = function_number
# $2 = disk_size
# $3 = block_range_start
# $4 = block_range_end
# $5 = block_type
source ./mksofs/test_function.sh
echo "This size is probably not correctly handled by the binaries given"
test_function 601 73 0 0 -s
return
test_function 601 330 0 0 -s

test_function 601 72 0 0 -s
test_function 601 328 0 0 -s



test_function 601 329 0 0 -s
test_function 601 4 0 0 -s
test_function 601 20 0 0 -s
test_function 601 50 0 0 -s
test_function 601 100 0 0 -s
test_function 601 10000 0 0 -s

test_function 601 2000 0 0 -s
test_function 601 1000 1 4 -i
test_function 601 2000 1 8 -i
test_function 601 1000 996 999 -r
test_function 601 2000 992 999 -r

test_function 601 4 0 3 -x -z
test_function 601 20 0 19 -x -z
test_function 601 1000 0 999 -x -z

if [ "$1" != "complete" ]; then return; fi

for ((i = 4; i < 500; i++)); do
  printf "\e[34m$i -> "
  test_function 601 $i 0 $(($i - 1)) -x
done
