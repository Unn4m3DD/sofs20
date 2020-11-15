#include <errno.h>
#include <string.h>

#include <iostream>

#include "core.h"
#include "daal.h"
#include "devtools.h"
#include "fileblocks.h"
#include "freedatablocks.h"
namespace sofs20 {

static uint32_t grpAllocIndirectFileBlock(SOInode* ip, uint32_t afbn);
static uint32_t grpAllocDoubleIndirectFileBlock(SOInode* ip, uint32_t afbn);

//The retrieved block from memory can be filled with garbage so it gets cleaned before it is used to store references
uint32_t getCleanDataBlock() {
  uint32_t result = soAllocDataBlock();
  uint32_t ref_table[RPB];
  memset(ref_table, BlockNullReference, RPB * sizeof(uint32_t));
  soWriteDataBlock(result, ref_table);
  return result;
}

uint32_t grpAllocFileBlock(int ih, uint32_t fbn) {
  soProbe(302, "%s(%d, %u)\n", __FUNCTION__, ih, fbn);
  //soCheckInodeHandler(ih, __FUNCTION__); //this throws an exception when called even if the ih is valid...
  SOInode* current_inode = soGetInodePointer(ih);
  //the logic to select the fileblock in use is the same as in getFileBlock
  if (fbn < N_DIRECT) {
    //as the given block is guaranteed to be a BlockNullReference no check is made an its given the alloced db
    uint32_t new_block = soAllocDataBlock();
    current_inode->d[fbn] = new_block;
    current_inode->blkcnt++;
    return current_inode->d[fbn];
  } else if (fbn - N_DIRECT < N_INDIRECT * RPB)
    return grpAllocIndirectFileBlock(current_inode, fbn - N_DIRECT);
  else if (fbn - N_DIRECT - N_INDIRECT * RPB < N_DOUBLE_INDIRECT * RPB * RPB)
    return grpAllocDoubleIndirectFileBlock(current_inode, fbn - N_DIRECT - N_INDIRECT);
  throw SOException(EINVAL, __FUNCTION__);
}

static uint32_t grpAllocIndirectFileBlock(SOInode* ip, uint32_t afbn) {
  soProbe(302, "%s(%d, ...)\n", __FUNCTION__, afbn);
  uint32_t ref_table[RPB];
  //in the case that there is no reference block associated with the i1[x] entry it is
  //cleanly alloced and attributed to i[x]
  if (ip->i1[afbn / RPB] == BlockNullReference) {
    ip->i1[afbn / RPB] = getCleanDataBlock();
    ip->blkcnt++;
  }
  memset(ref_table, BlockNullReference, sizeof(uint32_t) * RPB);
  soReadDataBlock(ip->i1[afbn / RPB], ref_table);
  uint32_t new_block = getCleanDataBlock();
  ref_table[afbn % RPB] = new_block;
  ip->blkcnt++;
  soWriteDataBlock(ip->i1[afbn / RPB], ref_table);
  return ref_table[afbn % RPB];
}

static uint32_t grpAllocDoubleIndirectFileBlock(SOInode* ip, uint32_t afbn) {
  soProbe(302, "%s(%d, ...)\n", __FUNCTION__, afbn);
  uint32_t ref_table_first[RPB];
  memset(ref_table_first, BlockNullReference, sizeof(uint32_t) * RPB);
  //here the logic of the function above is applied twice
  if (ip->i1[afbn / (RPB * RPB)] == BlockNullReference) {
    ip->i1[afbn / (RPB * RPB)] = getCleanDataBlock();
    ip->blkcnt++;
  }
  soReadDataBlock(ip->i2[afbn / (RPB * RPB)], ref_table_first);
  uint32_t ref_table[RPB];
  if (ip->i1[afbn / RPB] == BlockNullReference) {
    ip->i1[afbn / RPB] = getCleanDataBlock();
    ip->blkcnt++;
  }
  memset(ref_table, BlockNullReference, sizeof(uint32_t) * RPB);
  soReadDataBlock(ref_table_first[afbn / (RPB)], ref_table);
  uint32_t new_block = soAllocDataBlock();
  ref_table[afbn % RPB] = new_block;
  ip->blkcnt++;
  soWriteDataBlock(ref_table_first[afbn / (RPB)], ref_table);
  return ref_table[afbn % RPB];
}
};  // namespace sofs20
