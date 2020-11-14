#include <inttypes.h>
#include <string.h>

#include "bin_mksofs.h"
#include "core.h"
#include "devtools.h"
#include "grp_mksofs.h"
#include "rawdisk.h"

namespace sofs20 {
void grpResetFreeDataBlocks(uint32_t ntotal, uint32_t itotal, uint32_t dbtotal) {
  soProbe(607, "%s(%u, %u, %u)\n", __FUNCTION__, ntotal, itotal, dbtotal);
  int first_data_block = 1 + itotal / IPB + 1;  //super + inode + root
  int8_t empty_block[BlockSize];
  memset(empty_block, 0, BlockSize);
  for (uint32_t i = 0; i < dbtotal - 1; i++)
    soWriteRawBlock(i + first_data_block, empty_block);
}
};  // namespace sofs20
