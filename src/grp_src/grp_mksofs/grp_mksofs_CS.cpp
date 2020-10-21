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
  if (itotal % IPB != 0 ||
      itotal % IPB != 32 ||
      itotal > (ntotal + 7) / 8 ||
      itotal < IPB ||
      itotal == 0)

    itotal = ntotal / 16;
  uint32_t DBandRT = ntotal - itotal * IPB;
}
};  // namespace sofs20
