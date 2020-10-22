# $1 = function_number
# $2 = disk_size
# $3 = block_range_start
# $4 = block_range_end
source ./mksofs/test_function.sh
test_function 607 4 0 3 -x
test_function 607 20 0 19 -x
test_function 607 50 0 49 -x
test_function 607 100 0 99 -x
test_function 607 10000 0 9999 -x
test_function 607 1000 0 999 -x
test_function 607 2000 0 1999 -x
