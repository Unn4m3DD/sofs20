#include <inttypes.h>

#include <iostream>

#include "bin_mksofs.h"
#include "core.h"
#include "devtools.h"
#include "grp_mksofs.h"
using namespace std;
namespace sofs20 {
uint32_t round_to(uint to_round, uint rounder) {
  return ((to_round + rounder - 1) / rounder) * rounder;
}
uint32_t round_up_div(uint num, uint den) {
  return ((num + den - 1) / den);
}
void grpComputeStructure(uint32_t ntotal, uint32_t& itotal, uint32_t& dbtotal) {
  soProbe(601, "%s(%u, %u, ...)\n", __FUNCTION__, ntotal, itotal);
  if (itotal == 0) itotal = ntotal / 16;

  if (itotal < IPB) itotal = IPB;

  if (itotal > round_up_div(ntotal, 8))
    itotal = round_up_div(ntotal, 8);
  itotal = round_to(itotal, 32);
  itotal = round_to(itotal, IPB);

  // ntotal - (ref_table_count + 1 + itotal / IPB) =  + dbtotal
  // (REF_CACHE_SIZE + RPB * (ntotal - (1 + itotal / IPB)) + 1)/(1 + RPB) > dbtotal
  uint ref_table_block_count;

  for (ref_table_block_count = 0;; ref_table_block_count++) {
    dbtotal = ntotal - (ref_table_block_count + 1 + itotal / IPB);
    if (dbtotal - 1 <= REF_CACHE_SIZE + ref_table_block_count * RPB) break;
  }

  dbtotal = ref_table_block_count * RPB + 1;
  if (ref_table_block_count + 1 + itotal / IPB + dbtotal < ntotal) {
    itotal += IPB;
  }
}
}  // namespace sofs20
