#include <alloca.h>
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
  //soCheckInodeHandler(ih, __FUNCTION__);
  SOInode* current_inode = soGetInodePointer(ih);
  //the following conditional discover in which region of the memory the reference to the
  //required fileblock is
  if (fbn < N_DIRECT)
    return current_inode->d[fbn];  //if it is directly accessible return it
  else if (fbn - N_DIRECT < N_INDIRECT * RPB)
    //if it is indirectly accessible it reads the ref block from memory and return the required one
    return grpGetIndirectFileBlock(current_inode, fbn - N_DIRECT);
  else if (fbn - N_DIRECT - N_INDIRECT < N_DOUBLE_INDIRECT * RPB * RPB)
    //if it is indirectly accessible it reads the ref block from memory twice and return the required one
    return grpGetDoubleIndirectFileBlock(current_inode, fbn - N_DIRECT - N_INDIRECT);
  throw SOException(EINVAL, __FUNCTION__);
}

static uint32_t grpGetIndirectFileBlock(SOInode* ip, uint32_t afbn) {
  soProbe(301, "%s(%d, ...)\n", __FUNCTION__, afbn);
  uint32_t ref_table[RPB];
  if (ip->i1[afbn / RPB] == BlockNullReference) return BlockNullReference;
  soReadDataBlock(ip->i1[afbn / RPB], ref_table);
  return ref_table[afbn % RPB];
}
static uint32_t grpGetDoubleIndirectFileBlock(SOInode* ip, uint32_t afbn) {
  soProbe(301, "%s(%d, ...)\n", __FUNCTION__, afbn);
  uint32_t ref_table_first[RPB];
  if (ip->i2[afbn / (RPB * RPB)] == BlockNullReference) return BlockNullReference;
  soReadDataBlock(ip->i2[afbn / (RPB * RPB)], ref_table_first);
  uint32_t ref_table[RPB];
  if (ref_table_first[afbn / (RPB)] == BlockNullReference) return BlockNullReference;
  soReadDataBlock(ref_table_first[afbn / (RPB)], ref_table);
  return ref_table[afbn % RPB];
}
};  // namespace sofs20
