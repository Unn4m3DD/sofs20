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

  /* replace the following line with your code */
  //binFillReferenceTable(ntotal, itotal, dbtotal);
  uint32_t rttotal = ntotal - itotal - dbtotal;
  uint32_t ref[RPB];
  for (int b = 0; b < rttotal; b++) {
    memset(ref, BlockNullReference, BlockSize);
    for (int i = 0; i < RPB; i++) {
      ref[i] = i + RPB * b + 69;
    }
    soWriteRawBlock(ntotal - rttotal + b, ref);
  }
}
};  // namespace sofs20
