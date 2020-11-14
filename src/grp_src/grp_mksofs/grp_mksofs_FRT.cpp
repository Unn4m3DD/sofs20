#include <inttypes.h>
#include <string.h>

#include "bin_mksofs.h"
#include "core.h"
#include "devtools.h"
#include "grp_mksofs.h"
#include "rawdisk.h"

namespace sofs20 {
void grpFillReferenceTable(uint32_t ntotal, uint32_t itotal, uint32_t dbtotal) {
  soProbe(605, "%s(%u, %u, %u)\n", __FUNCTION__, ntotal, itotal, dbtotal);
  uint32_t rbtotal = ntotal - itotal / IPB - dbtotal - 1;
  uint32_t ref[RPB];
  //the following loop fills the reference table starting at REF_CACHE_SIZE
  for (uint current_block = 0; current_block < rbtotal; current_block++) {
    memset(ref, BlockNullReference, BlockSize);
    for (uint i = 0; i < RPB; i++) {
      if (i + RPB * current_block + REF_CACHE_SIZE + 1 < dbtotal)
        ref[i] = i + RPB * current_block + REF_CACHE_SIZE + 1;
      else
        ref[i] = BlockNullReference;
    }
    soWriteRawBlock(ntotal - rbtotal + current_block, ref);
  }
}
};  // namespace sofs20
