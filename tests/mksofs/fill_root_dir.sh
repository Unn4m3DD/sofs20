# $1 = function_number
# $2 = disk_size
# $3 = block_range_start
# $4 = block_range_end
source ./mksofs/test_function.sh
test_function 606 1000 5 5 -d
test_function 606 2000 9 9 -d
