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

errors="$(cat diff_bin.log)$(cat diff.log)$(cat bin_detect.log)"

if [ "$errors" != "" ]; then
  echo -e "\e[31mErrors detected during tests"
else
  echo -e "\e[34mAll tests passed"
fi
rm -rf bin
