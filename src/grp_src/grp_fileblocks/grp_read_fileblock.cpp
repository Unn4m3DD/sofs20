#include <inttypes.h>
#include <string.h>

#include "core.h"
#include "daal.h"
#include "devtools.h"
#include "fileblocks.h"

namespace sofs20 {
void grpReadFileBlock(int ih, uint32_t fbn, void* buf) {
  soProbe(331, "%s(%d, %u, %p)\n", __FUNCTION__, ih, fbn, buf);

  /* replace the following line with your code */
  //binReadFileBlock(ih, fbn, buf);
  uint32_t current_data_block = soGetFileBlock(ih, fbn);
  soReadDataBlock(current_data_block, buf);
}
};  // namespace sofs20
