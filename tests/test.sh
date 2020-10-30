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
if [[ $1 == "" || $1 == "CS" ]]; then
  source mksofs/compute_structure.sh $2
fi
if [[ $1 == "" || $1 == "FIT" ]]; then
  source mksofs/fill_inode_table.sh $2
fi
if [[ $1 == "" || $1 == "FSB" ]]; then
  source mksofs/fill_superblock.sh $2
fi
if [[ $1 == "" || $1 == "FRD" ]]; then
  source mksofs/fill_root_dir.sh $2
fi
if [[ $1 == "" || $1 == "FRT" ]]; then
  source mksofs/fill_reference_table.sh $2
fi
if [[ $1 == "" || $1 == "RFDB" ]]; then
  source mksofs/reset_free_data_blocks.sh $2
fi

if [[ $1 == "" || $1 == "alloc_inode" ]]; then
  source ilayer/alloc_inode.sh $2
fi

if [[ $1 == "" || $1 == "free_inode" ]]; then
  source ilayer/free_inode.sh $2
fi

if [[ $1 == "" || $1 == "alloc_db" ]]; then
  source ilayer/alloc_db.sh $2
fi

errors="$(cat diff_bin.log)$(cat diff.log)$(cat bin_detect.log)"

if [ "$errors" != "" ]; then
  echo -e "\e[31mErrors detected during tests"
else
  echo -e "\e[34mAll tests passed"
fi
rm -rf bin
