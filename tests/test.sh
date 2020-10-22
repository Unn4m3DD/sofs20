rm diff.log 2>/dev/null

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
  source mksofs/compute_structure.sh
fi
if [[ $1 == "" || $1 == "FIT" ]]; then
  source mksofs/fill_inode_table.sh
fi
if [[ $1 == "" || $1 == "FSB" ]]; then
  source mksofs/fill_superblock.sh
fi
if [[ $1 == "" || $1 == "FRD" ]]; then
  source mksofs/fill_root_dir.sh
fi
if [[ $1 == "" || $1 == "FRT" ]]; then
  source mksofs/fill_reference_table.sh
fi
if [[ $1 == "" || $1 == "RFDB" ]]; then
  source mksofs/reset_free_data_blocks.sh
fi
errors="$(cat diff_bin.log)$(cat diff.log)$(cat bin_detect.log)"
if [ "$errors" != "" ]; then
  echo -e "\e[31mErrors detected during tests"
else
  echo -e "\e[34mAll tests passed"
fi
rm -rf bin
