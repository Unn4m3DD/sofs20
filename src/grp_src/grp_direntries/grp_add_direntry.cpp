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
void grpAddDirentry(int pih, const char* name, uint16_t cin) {
  soProbe(202, "%s(%d, %s, %u)\n", __FUNCTION__, pih, name, cin);
  
  binAddDirentry(pih, name, cin);
}
};  // namespace sofs20
