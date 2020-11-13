source ./free_inodes_and_db/db_test_functions.sh
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

for ((j = 300; j < 500; j += 10)); do
  if [ "$j" == "73" ]; then j=$((j + 1)); fi
  printf "$j -> \n"
  create_disk $j
  alloc_db_test 50 $(($j - 8)) $(($j - 1)) $j
  alloc_db_test 50 $(($j - 8)) $(($j - 1)) $j
  alloc_db_test 50 $(($j - 8)) $(($j - 1)) $j
done

if [ "$1" != "complete" ]; then return; fi
for ((j = 10; j < 500; j++)); do
  if [ "$j" == "73" ]; then j=$((j + 1)); fi
  printf "$j -> \n"
  create_disk $j
  alloc_db_test 5 $(($j - 8)) $(($j - 1)) $j
  alloc_db_test 5 $(($j - 8)) $(($j - 1)) $j
  alloc_db_test 5 $(($j - 8)) $(($j - 1)) $j
done


