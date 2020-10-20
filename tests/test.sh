rm diff.log 2> /dev/null

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
rm -f diff.log
rm -f bin_diff.log 
source mksofs/fill_inode_table.sh
source mksofs/fill_superblock.sh
source mksofs/fill_root_dir.sh
rm -rf bin
