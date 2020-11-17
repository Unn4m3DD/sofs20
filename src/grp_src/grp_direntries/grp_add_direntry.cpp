#include <errno.h>
#include <string.h>
#include <sys/stat.h>

#include "bin_direntries.h"
#include "core.h"
#include "daal.h"
#include "devtools.h"
#include "direntries.h"
#include "fileblocks.h"

namespace sofs20 {
uint32_t getLastUsedFileBlock(int ih) {
  //It is know that there are no holes in a directory so the loop searches for the last used block
  uint32_t result = -1;
  while (soGetFileBlock(ih, ++result) != BlockNullReference)
    ;
  return result;
}
void grpAddDirentry(int pih, const char* name, uint16_t cin) {
  soProbe(202, "%s(%d, %s, %u)\n", __FUNCTION__, pih, name, cin);
  uint32_t last_used_file_block = getLastUsedFileBlock(pih);
  SODirentry direntries[DPB];
  soReadDataBlock(last_used_file_block, direntries);
  for (uint32_t i; i < DPB; i++) {
    if (direntries[i].in == InodeNullReference) {
      direntries[i].in = cin;
      strcpy(direntries[i].name, name);
      soWriteDataBlock(last_used_file_block, direntries);
      return;
    }
  }

  uint32_t new_block_number = soAllocFileBlock(pih, last_used_file_block + 1);
  memset(direntries, 0, DPB * sizeof(uint32_t));
  soWriteDataBlock(new_block_number, direntries);
}
};  // namespace sofs20
