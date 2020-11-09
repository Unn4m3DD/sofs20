#include <assert.h>
#include <errno.h>
#include <inttypes.h>

#include "core.h"
#include "daal.h"
#include "devtools.h"
#include "fileblocks.h"
#include "freedatablocks.h"

namespace sofs20 {

typedef struct
{
  uint32_t idx0, idx1, idx2;
} location;

static void grpFreeIndirectFileBlocks(SOInode* ip, uint32_t fbn);
static void grpFreeDoubleIndirectFileBlocks(SOInode* ip, uint32_t fbn);

static void free_fileblock(SOInode* inode, uint32_t fbn) {
  if (fbn < N_DIRECT)
    inode->d[fbn];
  else if (fbn - N_DIRECT < N_INDIRECT * RPB)
    grpFreeIndirectFileBlocks(inode, fbn - N_DIRECT);
  else if (fbn - N_DIRECT - N_INDIRECT < N_DOUBLE_INDIRECT * RPB * RPB)
    grpFreeDoubleIndirectFileBlocks(inode, fbn - N_DIRECT - N_INDIRECT);
}

void grpFreeFileBlocks(int ih, uint32_t ffbn) {
  soProbe(303, "%s(%d, %u)\n", __FUNCTION__, ih, ffbn);
  SOInode* inode = soGetInodePointer(ih);
  while (ffbn < N_DIRECT + N_INDIRECT * RPB + N_DOUBLE_INDIRECT * RPB * RPB) {
    free_fileblock(inode, ffbn);
  }
}

static void grpFreeIndirectFileBlocks(SOInode* ip, uint32_t fbn) {
  soProbe(301, "%s(%d, ...)\n", __FUNCTION__, fbn);
  uint32_t ref_table[RPB];
  soReadDataBlock(ip->i1[fbn / RPB], ref_table);
  if (ref_table[fbn % RPB] != BlockNullReference) {
    ref_table[fbn % RPB] = BlockNullReference;
    ip->blkcnt--;
  }
  soWriteDataBlock(ip->i1[fbn / RPB], &ref_table);
}
static void grpFreeDoubleIndirectFileBlocks(SOInode* ip, uint32_t fbn) {
  soProbe(301, "%s(%d, ...)\n", __FUNCTION__, fbn);
  uint32_t ref_table_first[RPB];
  soReadDataBlock(ip->i2[fbn / (RPB * RPB)], ref_table_first);
  uint32_t ref_table[RPB];
  soReadDataBlock(ref_table_first[fbn / (RPB)], ref_table);
  ref_table[fbn % RPB];
}
};  // namespace sofs20
