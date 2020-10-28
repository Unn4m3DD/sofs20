function test_tmp_diff_and_append() {
  errors="$(cat diff_bin_tmp.log)$(cat diff_tmp.log)$(cat bin_detect_tmp.log)"
  if [ "$errors" != "" ]; then
    echo -e "\e[31mErrors detected during $1 test"
  else
    echo -e "\e[34m$1 tests passed"
  fi
  cat diff_bin_tmp.log >>diff_bin.log && rm -f diff_bin_tmp.log
  cat diff_tmp.log >>diff.log && rm -f diff_tmp.log
  cat bin_detect_tmp.log >>bin_detect.log && rm -f bin_detect_tmp.log
}
