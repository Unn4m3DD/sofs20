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

    /* replace the following line with your code */
    //binRenameDirentry(pih, name, newName);
    uint32_t dirDBIndex = getDirentryDBIndex(pih, name);
    SODirentry dir_entries[DPB];
    soReadDataBlock(dirDBIndex, dir_entries);
    strcpy(dir_entries[dirDBIndex].name, newName);
    soWriteDataBlock(dirDBIndex, dir_entries);
  }  
};  // namespace sofs20
