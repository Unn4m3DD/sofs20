# $1 -> function
# $2 -> complete
source ./test_tmp_diff_and_append.sh
function compile() {
  current_dir=$(pwd)
  rm -rf bin
  mkdir -p tmp
  cd ../build
  cmake ../src >/dev/null
  make -j >/dev/null
  cd ..
  cp -r bin/ tests/bin
  cd $current_dir
}

compile
rm -f *.log
touch bin_detect.log

if [[ $1 == "-h" ]]; then
  echo "mksofs CS"
  echo "mksofs FIT"
  echo "mksofs FSB"
  echo "mksofs FRD"
  echo "mksofs FRT"
  echo "mksofs RFDB"
  echo "------"
  echo "free_inodes_and_db alloc_inode"
  echo "free_inodes_and_db alloc_db"
  echo "free_inodes_and_db free_db"
  echo "free_inodes_and_db replenish_retrieval"
  echo "free_inodes_and_db deplete_insertion"
  echo "------"
  echo "fileblocks alloc_fb"
  echo "fileblocks free_fb"
  echo "fileblocks get_fb"
  echo "fileblocks write_fb"
  echo "fileblocks read_fb"
  echo "------"
  echo "direntries add_direntry"
  echo "direntries delete_direntry"
  echo "direntries check_direntry"
  echo "direntries get_direntry"
  echo "direntries rename_direntry"
  echo "direntries traverse_direntry"
  echo "------"
  echo "global"
fi
if [[ $1 == "" || $1 == "mksofs" ]]; then
  source mksofs/test.sh 
  test_mksoft $2 $3
fi
if [[ $1 == "" || $1 == "free_inodes_and_db" ]]; then
  source free_inodes_and_db/test.sh 
  free_inodes_and_db $2 $3
fi
if [[ $1 == "" || $1 == "fileblocks" ]]; then
  source fileblocks/test.sh 
  fileblocks $2 $3
fi
if [[ $1 == "" || $1 == "direntries" ]]; then
  source direntries/test.sh 
  direntries $2 $3
fi
if [[ $1 == "" || $1 == "global" ]]; then
  source global/global_test.sh 
fi

errors="$(cat diff_bin.log)$(cat diff.log)$(cat bin_detect.log)"

if [ "$errors" != "" ]; then
  echo -e "\e[31mErrors detected during tests"
else
  echo -e "\e[34mAll tests passed"
fi
rm -rf bin
rm -rf tmp
