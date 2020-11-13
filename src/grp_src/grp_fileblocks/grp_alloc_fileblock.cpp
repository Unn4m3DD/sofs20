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

uint32_t grpAllocFileBlock(int ih, uint32_t fbn) {
  soProbe(302, "%s(%d, %u)\n", __FUNCTION__, ih, fbn);
  //soCheckInodeHandler(ih, __FUNCTION__);
  SOInode* current_inode = soGetInodePointer(ih);
  if (fbn < N_DIRECT) {
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
  soProbe(301, "%s(%d, ...)\n", __FUNCTION__, afbn);
  uint32_t ref_table[RPB];
  if (ip->i1[afbn / RPB] == BlockNullReference) {
    ip->i1[afbn / RPB] = soAllocDataBlock();
    ip->blkcnt++;
  }
  memset(ref_table, 0, sizeof(uint32_t) * RPB);
  soReadDataBlock(ip->i1[afbn / RPB], ref_table);
  uint32_t new_block = soAllocDataBlock();
  ref_table[afbn % RPB] = new_block;
  ip->blkcnt++;
  soWriteDataBlock(ip->i1[afbn / RPB], ref_table);
  return ref_table[afbn % RPB];
}

static uint32_t grpAllocDoubleIndirectFileBlock(SOInode* ip, uint32_t afbn) {
  soProbe(301, "%s(%d, ...)\n", __FUNCTION__, afbn);
  uint32_t ref_table_first[RPB];
  memset(ref_table_first, 0, sizeof(uint32_t) * RPB);
  if (ip->i1[afbn / (RPB * RPB)] == BlockNullReference) {
    ip->i1[afbn / (RPB * RPB)] = soAllocDataBlock();
    ip->blkcnt++;
  }
  soReadDataBlock(ip->i2[afbn / (RPB * RPB)], ref_table_first);
  uint32_t ref_table[RPB];
  if (ip->i1[afbn / RPB] == BlockNullReference) {
    ip->i1[afbn / RPB] = soAllocDataBlock();
    ip->blkcnt++;
  }
  memset(ref_table, 0, sizeof(uint32_t) * RPB);
  soReadDataBlock(ref_table_first[afbn / (RPB)], ref_table);
  uint32_t new_block = soAllocDataBlock();
  ref_table[afbn % RPB] = new_block;
  ip->blkcnt++;
  soWriteDataBlock(ref_table_first[afbn / (RPB)], ref_table);
  return ref_table[afbn % RPB];
}
};  // namespace sofs20
