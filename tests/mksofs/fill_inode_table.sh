source ./mksofs/test_function.sh
test_function 604 1000 1 4 -i
test_function 604 2000 1 8 -i

test_function 604 4 0 3 -x -z
test_function 604 20 0 19 -x -z
test_function 604 1000 0 999 -x -z