#include <inttypes.h>
#include <string.h>

#include "bin_mksofs.h"
#include "core.h"
#include "devtools.h"
#include "grp_mksofs.h"
#include "rawdisk.h"

namespace sofs20 {

void grpFillRootDir(uint32_t itotal) {
  soProbe(606, "%s(%u)\n", __FUNCTION__, itotal);
  int8_t block[BlockSize];
  memset(block, 0, BlockSize);
  SODirentry* root_self = (SODirentry*)block;
  SODirentry* root_parent = (SODirentry*)(block + sizeof(SODirentry));
  root_self->in = 0;
  strcpy(root_self->name, ".");
  root_parent->in = 0;
  strcpy(root_parent->name, "..");
  soWriteRawBlock(1 + (itotal + IPB - 1) / IPB, block);
}
};  // namespace sofs20
