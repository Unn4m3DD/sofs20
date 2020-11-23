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
uint32_t getDirentryDBIndex(int pih, const char* name);
void grpRenameDirentry(int pih, const char* name, const char* newName) {
  soProbe(204, "%s(%d, %s, %s)\n", __FUNCTION__, pih, name, newName);
  uint32_t dirDBIndex = getDirentryDBIndex(pih, name);
  SODirentry dir_entries[DPB];
  soReadDataBlock(dirDBIndex, dir_entries);
  uint32_t dir_idx;
  for (dir_idx = 0; dir_idx < DPB; dir_idx++)
    if (!strcmp(dir_entries[dir_idx].name, name))
      break;
  memset(dir_entries[dir_idx].name, 0, (SOFS20_FILENAME_LEN + 1) * sizeof(char));
  strcpy(dir_entries[dir_idx].name, newName);
  soWriteDataBlock(dirDBIndex, dir_entries);
}
};  // namespace sofs20
