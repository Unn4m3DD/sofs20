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
  return --result;
}
void grpAddDirentry(int pih, const char* name, uint16_t cin) {
  soProbe(202, "%s(%d, %s, %u)\n", __FUNCTION__, pih, name, cin);

  SOInode* inode = soGetInodePointer(pih);
  inode->size += sizeof(SODirentry);
  uint32_t last_used_file_block = getLastUsedFileBlock(pih);
  SODirentry direntries[DPB];
  if (last_used_file_block != UINT32_MAX) {
    soReadDataBlock(soGetFileBlock(pih, last_used_file_block), direntries);
    for (uint32_t i = 0; i < DPB; i++) {
      if (direntries[i].name[0] == 0) {
        direntries[i].in = cin;
        strcpy(direntries[i].name, name);
        soWriteDataBlock(soGetFileBlock(pih, last_used_file_block), direntries);
        return;
      }
    }
  }
  uint32_t new_block_number = soAllocFileBlock(pih, last_used_file_block + 1);
  soReadDataBlock(new_block_number, direntries);
  memset(direntries, 0, DPB * sizeof(SODirentry));
  if (last_used_file_block == 0) {
    direntries[0].in = cin;
    strcpy(direntries[0].name, ".");
    direntries[1].in = soGetInodeNumber(pih);
    strcpy(direntries[1].name, "..");
    direntries[2].in = cin;
    strcpy(direntries[2].name, name);
  } else {
    direntries[0].in = cin;
    strcpy(direntries[0].name, name);
  }
  soWriteDataBlock(new_block_number, direntries);
}
};  // namespace sofs20
