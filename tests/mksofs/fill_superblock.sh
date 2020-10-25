# $1 = function_number
# $2 = disk_size
# $3 = block_range_start
# $4 = block_range_end
source ./mksofs/test_function.sh
test_function 602 4 0 0 -s
test_function 602 10 0 0 -s
test_function 602 20 0 0 -s
test_function 602 50 0 0 -s
test_function 602 100 0 0 -s
test_function 602 10000 0 0 -s
test_function 602 1000 0 0 -s
test_function 602 2000 0 0 -s

test_function 602 4 0 3 -x -z
test_function 602 20 0 19 -x -z
test_function 602 1000 0 999 -x -z