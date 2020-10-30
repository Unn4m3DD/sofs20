# free_db_test
# $1 db number begin
# $2 db number end
# $3 analysis block range begin
# $4 analysis block range end
# $5 disk size
function free_db_test() {
  # FUCKIN TODO
  touch bin_detect_tmp.log

  for ((i = $1; i < $2; i++)); do
    printf "fi\n$i\nq\n" | bin/testtool -q 2 -b tmp/original_disk >/dev/null
    printf "fi\n$i\nq\n" | bin/testtool -q 2 -p 442-442 -b -r 442-442 tmp/disk | grep "442" | grep "31m" >/dev/null
  done
  if [ $? == 0 ]; then
    echo "binary form of 442 beeing called" >>bin_detect_tmp.log
  fi
  bin/showblock -s 0 tmp/original_disk | grep -v "atime" >>tmp/original_db
  bin/showblock -s 0 tmp/disk | grep -v "atime" >>tmp/db
  bin/showblock -i $3-$4 tmp/original_disk | grep -v "atime" >>tmp/original_db
  bin/showblock -i $3-$4 tmp/disk | grep -v "atime" >>tmp/db
  touch tmp/original_db_bin
  touch tmp/db_bin
  if [ $? != 0 ]; then
    bin/showblock -x "0-$(($5 - 1))" tmp/original_disk | grep -v "atime" >>tmp/original_db_bin
    bin/showblock -x "0-$(($5 - 1))" tmp/disk | grep -v "atime" >>tmp/db_bin
  fi
  diff tmp/original_db tmp/db -d >>diff_tmp.log
  diff tmp/original_db_bin tmp/db_bin -d >>diff_bin_tmp.log
  test_tmp_diff_and_append 442
}

# alloc_db
# $1 db count
# $2 db type (0 - random, 1 - file, 2 - dir, 3 - link)
function alloc_db_bin() {
  # FUCKIN TODO
  db_type="$2"
  declare -a permissions_array=(0 644 755 777)
  permission=${permissions_array[db_type]}

  for ((i = 0; i < $1; i++)); do
    if [ "$2" == "0" ]; then
      db_type=$(($RANDOM % 3 + 1))
      declare -a permissions_array=(0 644 755 777)
      permission=${permissions_array[db_type]}
    fi
    printf "ai\n$db_type\n$permission\nq\n" | bin/testtool -q 2 -b tmp/original_disk >/dev/null
    printf "ai\n$db_type\n$permission\nq\n" | bin/testtool -q 2 -b tmp/disk >/dev/null
  done
}

# alloc_db_test
# $1 db count
# $2 analysis block range begin
# $3 analysis block range end
# $4 disk size
function alloc_db_test() {
  touch bin_detect_tmp.log

  for ((i = 0; i < $1; i++)); do
    printf "adb\nq\n" | bin/testtool -q 2 -b tmp/original_disk >/dev/null
    printf "adb\nq\n" | bin/testtool -q 2 -p 441-441 -b -r 441-441 tmp/disk | grep "441" | grep "31m" >/dev/null
  done
  if [ $? == 0 ]; then
    echo "binary form of 441 beeing called" >>bin_detect_tmp.log
  fi
  bin/showblock -s 0 tmp/original_disk | grep -v "atime" >>tmp/original_db
  bin/showblock -s 0 tmp/disk | grep -v "atime" >>tmp/db
  bin/showblock -r $2-$3 tmp/original_disk | grep -v "atime" >>tmp/original_db
  bin/showblock -r $2-$3 tmp/disk | grep -v "atime" >>tmp/db
  touch tmp/original_db_bin
  touch tmp/db_bin
  if [ $? != 0 ]; then
    bin/showblock -x "0-$(($4 - 1))" tmp/original_disk | grep -v "atime" >>tmp/original_db_bin
    bin/showblock -x "0-$(($4 - 1))" tmp/disk | grep -v "atime" >>tmp/db_bin
  fi
  diff tmp/original_db tmp/db -d >>diff_tmp.log
  diff tmp/original_db_bin tmp/db_bin -d >>diff_bin_tmp.log
  test_tmp_diff_and_append 441
}
