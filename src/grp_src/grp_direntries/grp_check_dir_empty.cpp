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
bool grpCheckDirEmpty(int ih) {
  soProbe(205, "%s(%d)\n", __FUNCTION__, ih);
  SODirentry dirEntries[DPB];
  soReadFileBlock(ih, 0, dirEntries);
  return dirEntries[2].name[0] == 0;
}
};  // namespace sofs20
