#include <inttypes.h>
#include <string.h>

#include "bin_mksofs.h"
#include "core.h"
#include "devtools.h"
#include "grp_mksofs.h"
#include "rawdisk.h"

namespace sofs20 {
/*
       filling in the contents of the root directory:
       the first 2 entries are filled in with "." and ".." references
       the other entries are empty.
       If rdsize is 2, a second block exists and should be filled as well.
       */
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
