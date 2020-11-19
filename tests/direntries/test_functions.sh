# traverse_path_test
# $1 inode number
# $2 analysis block range begin
# $3 analysis block range end
# $4 disk size
function traverse_path_test() {
  touch bin_detect_tmp.log
  e=0
  printf "tp\n$1\nq\n" | bin/testtool -q 2 -b tmp/original_disk >>tmp/original_inode
  printf "tp\n$1\nq\n" | bin/testtool -q 2 -p 221-221 -b -r 221-221 tmp/disk | grep "inode number = " >>tmp/inode
  bin/showblock -i $2-$3 tmp/original_disk | grep -v "atime" >>tmp/original_inode
  bin/showblock -i $2-$3 tmp/disk | grep -v "atime" >>tmp/inode
  touch tmp/original_inode_bin
  touch tmp/inode_bin

  bin/showblock -x "0-$(($4 - 1))" tmp/original_disk | grep -v "atime" >>tmp/original_inode_bin
  bin/showblock -x "0-$(($4 - 1))" tmp/disk | grep -v "atime" >>tmp/inode_bin

  diff tmp/original_inode tmp/inode -d >>diff_tmp.log
  diff tmp/original_inode_bin tmp/inode_bin -d >>diff_bin_tmp.log
  test_tmp_diff_and_append 221
}

# add_direntry_test
# $1 parent inode number
# $2 name
# $3 child inode number
# $4 analysis block range begin
# $5 analysis block range end
# $6 disk size
function add_direntry_test() {
  touch bin_detect_tmp.log
  e=0
  printf "ade\n$1\n$2\n$3\nq\n" | bin/testtool -q 2 -b tmp/original_disk >/dev/null
  printf "ade\n$1\n$2\n$3\nq\n" | bin/testtool -q 2 -p 202-202 -b -r 202-202 tmp/disk | grep "202" | grep "31m" >/dev/null
  if [ $? == 0 ]; then e=1; fi
  if [ $e == 1 ]; then
    echo "binary form of 202 beeing called" >>bin_detect_tmp.log
  fi
  bin/showblock -d $4-$5 tmp/original_disk | grep -v "atime" >>tmp/original_inode
  bin/showblock -d $4-$5 tmp/disk | grep -v "atime" >>tmp/inode
  bin/showblock -i 1-4 tmp/original_disk | grep -v "atime" >>tmp/original_inode
  bin/showblock -i 1-4 tmp/disk | grep -v "atime" >>tmp/inode
  touch tmp/original_inode_bin
  touch tmp/inode_bin

  bin/showblock -x "$4-$(($6 - 1))" tmp/original_disk >>tmp/original_inode_bin
  bin/showblock -x "$4-$(($6 - 1))" tmp/disk >>tmp/inode_bin

  diff tmp/original_inode tmp/inode -d >>diff_tmp.log
  diff tmp/original_inode_bin tmp/inode_bin -d >>diff_bin_tmp.log
  test_tmp_diff_and_append 202
}

# add_direntry_bin
# $1 parent inode number
# $2 name
# $3 child inode number
function add_direntry_bin() {
  printf "ade\n$1\n$2\n$3\nq\n" | bin/testtool -q 2 -b tmp/original_disk >/dev/null
  printf "ade\n$1\n$2\n$3\nq\n" | bin/testtool -q 2 -b tmp/disk >/dev/null
}

# delete_direntry_test
# $1 parent inode number
# $2 name
# $3 analysis block range begin
# $4 analysis block range end
# $5 disk size
function delete_direntry_test() {
  touch bin_detect_tmp.log
  e=0
  printf "dde\n$1\n$2\nq\n" | bin/testtool -q 2 -b tmp/original_disk >/dev/null
  printf "dde\n$1\n$2\nq\n" | bin/testtool -q 2 -p 203-203 -b -r 203-203 tmp/disk | grep "203" | grep "31m" >/dev/null
  if [ $? == 0 ]; then e=1; fi
  if [ $e == 1 ]; then
    echo "binary form of 203 beeing called" >>bin_detect_tmp.log
  fi
  bin/showblock -d $3-$4 tmp/original_disk | grep -v "atime" >>tmp/original_inode
  bin/showblock -d $3-$4 tmp/disk | grep -v "atime" >>tmp/inode
  bin/showblock -i 1-9 tmp/original_disk | grep -v "atime" >>tmp/original_inode
  bin/showblock -i 1-9 tmp/disk | grep -v "atime" >>tmp/inode
  touch tmp/original_inode_bin
  touch tmp/inode_bin

  bin/showblock -x "$3-$(($5 - 1))" tmp/original_disk >>tmp/original_inode_bin
  bin/showblock -x "$3-$(($5 - 1))" tmp/disk >>tmp/inode_bin

  diff tmp/original_inode tmp/inode -d >>diff_tmp.log
  diff tmp/original_inode_bin tmp/inode_bin -d >>diff_bin_tmp.log
  test_tmp_diff_and_append 203
}

# delete_direntry_bin
# $1 parent inode number
# $2 name
function delete_direntry_bin() {
  printf "dde\n$1\n$2\nq\n" | bin/testtool -q 2 -b tmp/original_disk >/dev/null
  printf "dde\n$1\n$2\nq\n" | bin/testtool -q 2 -b tmp/disk >/dev/null
}

# check_dir_empty_test
# $1 parent inode number
function check_dir_empty_test() {
  touch bin_detect_tmp.log
  e=0
  printf "cde\n$1\nq\n" | bin/testtool -q 2 -b tmp/original_disk | grep "Directory" >>tmp/original_inode
  printf "cde\n$1\nq\n" | bin/testtool -q 2 -p 203-203 -b -r 203-203 tmp/disk | grep "Directory" >>tmp/inode
  touch tmp/original_inode_bin
  touch tmp/inode_bin

  diff tmp/original_inode tmp/inode -d >>diff_tmp.log
  diff tmp/original_inode_bin tmp/inode_bin -d >>diff_bin_tmp.log
  test_tmp_diff_and_append 203
}



# get_dir_entry_test
# $1 parent inode number
# $2 dir name
function get_dir_entry_test() {
  touch bin_detect_tmp.log
  e=0
  printf "gde\n$1\n$2\nq\n" | bin/testtool -q 1 -b tmp/original_disk | grep "Child inode number\|does not exist" >>tmp/original_inode
  printf "gde\n$1\n$2\nq\n" | bin/testtool -q 1 -p 201-201 -b -r 201-201 tmp/disk | grep "Child inode number\|does not exist" >>tmp/inode
  touch tmp/original_inode_bin
  touch tmp/inode_bin

  diff tmp/original_inode tmp/inode -d >>diff_tmp.log
  diff tmp/original_inode_bin tmp/inode_bin -d >>diff_bin_tmp.log
  test_tmp_diff_and_append 201
}



# rename_direntry_test
# $1 parent inode number
# $2 old name
# $3 new name
# $4 analysis block range begin
# $5 analysis block range end
# $6 disk size
function rename_direntry_test() {
  touch bin_detect_tmp.log
  e=0
  printf "rde\n$1\n$2\n$3\nq\n" | bin/testtool -q 2 -b tmp/original_disk >/dev/null
  printf "rde\n$1\n$2\n$3\nq\n" | bin/testtool -q 2 -p 204-204 -b -r 204-204 tmp/disk | grep "204" | grep "31m" >/dev/null
  if [ $? == 0 ]; then e=1; fi
  if [ $e == 1 ]; then
    echo "binary form of 204 beeing called" >>bin_detect_tmp.log
  fi
  bin/showblock -d $4-$5 tmp/original_disk | grep -v "atime" >>tmp/original_inode
  bin/showblock -d $4-$5 tmp/disk | grep -v "atime" >>tmp/inode
  bin/showblock -i 1-4 tmp/original_disk | grep -v "atime" >>tmp/original_inode
  bin/showblock -i 1-4 tmp/disk | grep -v "atime" >>tmp/inode
  touch tmp/original_inode_bin
  touch tmp/inode_bin

  bin/showblock -x "$4-$(($6 - 1))" tmp/original_disk >>tmp/original_inode_bin
  bin/showblock -x "$4-$(($6 - 1))" tmp/disk >>tmp/inode_bin

  diff tmp/original_inode tmp/inode -d >>diff_tmp.log
  diff tmp/original_inode_bin tmp/inode_bin -d >>diff_bin_tmp.log
  test_tmp_diff_and_append 204
}
