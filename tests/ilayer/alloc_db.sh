source ./ilayer/db_test_functions.sh
source ./create_disk.sh

#------------------------------------------------------------------
# create_disk
# $1 -> disk size
#------------------------------------------------------------------
# alloc_db_test
# $1 db count
# $2 analysis block range begin
# $3 analysis block range end
# $4 disk size
#------------------------------------------------------------------

create_disk 1000
alloc_db_test 63 990 999 1000
create_disk 1000
alloc_db_test 10 990 999 1000
alloc_db_test 10 990 999 1000
alloc_db_test 10 990 999 1000
alloc_db_test 30 990 999 1000

if [ "$1" != "complete" ]; then return; fi
for ((j = 10; j < 500; j++)); do
  if [ "$i" == "73" ]; then i=$((i + 1)); fi
  printf "$j -> \n"
  create_disk $j
  alloc_db_test 5 $(($j - 8)) $(($j - 1)) $j
  alloc_db_test 5 $(($j - 8)) $(($j - 1)) $j
  alloc_db_test 5 $(($j - 8)) $(($j - 1)) $j
done
