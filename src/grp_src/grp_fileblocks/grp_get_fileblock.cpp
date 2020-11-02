#include <errno.h>

#include "core.h"
#include "daal.h"
#include "devtools.h"
#include "fileblocks.h"

namespace sofs20 {

static uint32_t grpGetIndirectFileBlock(SOInode* ip, uint32_t fbn);
static uint32_t grpGetDoubleIndirectFileBlock(SOInode* ip, uint32_t fbn);

uint32_t grpGetFileBlock(int ih, uint32_t fbn) {
  soProbe(301, "%s(%d, %u)\n", __FUNCTION__, ih, fbn);
  SOInode* current_inode = soGetInodePointer(ih);
  if (fbn < N_DIRECT)
    return current_inode->d[fbn];
  else if (fbn - N_DIRECT < N_INDIRECT)
    return grpGetIndirectFileBlock(current_inode, fbn - N_DIRECT);
  else if (fbn - N_DIRECT - N_INDIRECT < N_DOUBLE_INDIRECT)
    return grpGetDoubleIndirectFileBlock(current_inode, fbn - N_DIRECT - N_INDIRECT);
  throw SOException(EINVAL, __FUNCTION__);
}

static uint32_t grpGetIndirectFileBlock(SOInode* ip, uint32_t afbn) {
  soProbe(301, "%s(%d, ...)\n", __FUNCTION__, afbn);
  
  return 0;
}
static uint32_t grpGetDoubleIndirectFileBlock(SOInode* ip, uint32_t afbn) {
  soProbe(301, "%s(%d, ...)\n", __FUNCTION__, afbn);

  /* replace the following two lines with your code */
  throw SOException(ENOSYS, __FUNCTION__);
  return 0;
}
};  // namespace sofs20
