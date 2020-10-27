#include <inttypes.h>

#include <iostream>

#include "bin_mksofs.h"
#include "core.h"
#include "devtools.h"
#include "grp_mksofs.h"

namespace sofs20 {
void grpComputeStructure(uint32_t ntotal, uint32_t& itotal, uint32_t& dbtotal) {
  soProbe(601, "%s(%u, %u, ...)\n", __FUNCTION__, ntotal, itotal);
  /* replace the following line with your code */
  //binComputeStructure(ntotal, itotal, dbtotal);
  //return;
  if (itotal == 0)
    itotal = ntotal / 16;
  if (itotal < IPB)
    itotal = IPB;
  if (itotal > (ntotal + 7) / 8)
    itotal = (ntotal + 7) / 8;
  itotal = ((itotal + 32 - 1) / 32) * 32;
  itotal = ((itotal + IPB - 1) / IPB) * IPB;
  //ref_table_block_count = (dbtotal - REF_CACHE_SIZE) / RPB
  //dbtotal = ntotal - (2 + itotal / IPB + 1 + ref_table_block_count)

  uint ref_table_block_count =
      ((ntotal - 2 - itotal / IPB + REF_CACHE_SIZE / RPB) / (1 + 1 / RPB) - REF_CACHE_SIZE + RPB - 1) / RPB;

  dbtotal = ntotal - 1 - itotal / IPB - ref_table_block_count;

  if (1 + itotal / IPB + dbtotal + ref_table_block_count < ntotal)
    itotal += IPB;
}
}  // namespace sofs20
