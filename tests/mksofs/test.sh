function test_mksoft() {
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
}
