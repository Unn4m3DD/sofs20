source ./free_inodes_and_db/db_test_functions.sh
source ./create_disk.sh

#------------------------------------------------------------------
# create_disk
# $1 -> disk size
#------------------------------------------------------------------
# alloc_db
# $1 db count
#------------------------------------------------------------------
# free_db_test
# $1 db number begin
# $2 db number end
# $3 analysis block range begin
# $4 analysis block range end
# $5 disk size
#------------------------------------------------------------------

create_disk 280
create_disk 1000
alloc_db_bin 63
free_db_test 0 10 1 4 1000
free_db_test 10 20 4 63 1000
create_disk 1000
alloc_db_bin 10
alloc_db_bin 10
free_db_test 0 10 1 4 1000
alloc_db_bin 10
alloc_db_bin 30
free_db_test 0 10 1 4 1000

for ((j = 100; j < 500; j += 10)); do
  if [ "$j" == "73" ]; then j=$((j + 1)); fi
  printf "$j -> \n"
  create_disk $j
  free_db_test 0 50 1 10 $j
  free_db_test 51 90 1 10 $j
done
if [ "$1" != "complete" ]; then return; fi

for ((j = 30; j < 500; j += 1)); do
  printf "$j -> \n"
  create_disk $j
  alloc_db_bin 5
  alloc_db_bin 5
  free_db_test 0 10 1 10 $j
  free_db_test 10 20 1 10 $j
done

for ((j = 0; j < 200; j += 1)); do
  printf "$j -> \n"
  free_db_test $j $((j + 1)) 1 10 280
done