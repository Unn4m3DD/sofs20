# $1 = function_number
# $2 = disk_size
# $3 = block_range_start
# $4 = block_range_end
source ./mksofs/test_function.sh
test_function 602 1000 0 0 -s
test_function 602 2000 0 0 -s
