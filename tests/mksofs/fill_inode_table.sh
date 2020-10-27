source ./mksofs/test_function.sh
test_function 604 1000 1 4 -i
test_function 604 2000 1 8 -i

test_function 604 4 0 3 -x -z
test_function 604 20 0 19 -x -z
test_function 604 1000 0 999 -x -z

if [ "$1" != "complete" ]; then return; fi

for ((i = 4; i < 500; i++)); do
  if [ "$i" == "73" ]; then i=$((i + 1)); fi
  printf "\e[34m$i -> "
  test_function 604 $i 0 $(($i - 1)) -x
done