#include <inttypes.h>

#include <iostream>

#include "bin_mksofs.h"
#include "core.h"
#include "devtools.h"
#include "grp_mksofs.h"

namespace sofs20 {
void grpComputeStructure(uint32_t ntotal, uint32_t& itotal, uint32_t& dbtotal) {
  soProbe(601, "%s(%u, %u, ...)\n", __FUNCTION__, ntotal, itotal);
  if (itotal == 0)
    itotal = ntotal / 16;
  if (itotal < IPB)
    itotal = IPB;
  if (itotal > (ntotal + 7) / 8)
    itotal = (ntotal + 7) / 8;
  itotal = ((itotal + 32 - 1) / 32) * 32;
  itotal = ((itotal + IPB - 1) / IPB) * IPB;
  //the conditions above are described on the documentation
  uint ref_table_block_count;
  //the following loop will test different ref_ref_table_block_count until there are enough references for each block
  for (ref_table_block_count = 0;; ref_table_block_count++) {
    dbtotal = ntotal - (ref_table_block_count + 1 + itotal / IPB);
    if (dbtotal - 1 <= REF_CACHE_SIZE + ref_table_block_count * RPB) break;
  }
  //the following code detects the case where
  //if we add a ref block it will be empty and if we add a data
  //block there will be no space to store a reference to it
  dbtotal = ntotal - (1 + itotal / IPB + ref_table_block_count);
  if (dbtotal - 1 == REF_CACHE_SIZE + (ref_table_block_count - 1) * RPB) {
    itotal += 2 * IPB;
    dbtotal--;
  }
}
}  // namespace sofs20
