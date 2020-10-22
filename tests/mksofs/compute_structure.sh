# $1 = function_number
# $2 = disk_size
# $3 = block_range_start
# $4 = block_range_end
# $5 = block_type
source ./mksofs/test_function.sh
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
