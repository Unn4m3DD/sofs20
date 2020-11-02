#include <inttypes.h>
#include <string.h>

#include "core.h"
#include "daal.h"
#include "devtools.h"
#include "fileblocks.h"

namespace sofs20 {
void grpWriteFileBlock(int ih, uint32_t fbn, void* buf) {
  soProbe(332, "%s(%d, %u, %p)\n", __FUNCTION__, ih, fbn, buf);
  //soCheckInodeHandler(ih, __FUNCTION__);
  uint32_t physical_block_number = soGetFileBlock(ih, fbn);
  if (physical_block_number == BlockNullReference)
    physical_block_number = soAllocFileBlock(ih, fbn);

  soWriteDataBlock(physical_block_number, buf);
}
};  // namespace sofs20
