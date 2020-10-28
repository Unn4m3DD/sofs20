/*
 *  \author António Rui Borges - 2012-2015
 *  \authur Artur Pereira - 2016-2020
 */

#include <errno.h>
#include <inttypes.h>
#include <pwd.h>
#include <stdio.h>
#include <string.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <time.h>
#include <unistd.h>

#include <iostream>

#include "core.h"
#include "daal.h"
#include "devtools.h"
#include "freeinodes.h"

namespace sofs20 {

uint get_i_bit_map_pos(uint32_t* ibitmap, uint pos) {
  return (ibitmap[pos / 32] >> (pos % 32)) & 0b01;
}

uint32_t get_free_inode_index(SOSuperblock* super_block) {
  uint result = super_block->iidx;
  for (; result < MAX_INODES + super_block->iidx; result++)
    if (!get_i_bit_map_pos(super_block->ibitmap, result % MAX_INODES))
      break;
  result %= MAX_INODES;
  return result;
}

void set_used_inode_index(uint32_t* ibitmap, uint32_t current_inode) {
  ibitmap[current_inode / 32] = ibitmap[current_inode / 32] | (0b01 << (current_inode % 32));
}

uint16_t grpAllocInode(uint32_t mode) {
  soProbe(401, "%s(0x%x)\n", __FUNCTION__, mode);
  if (
      (mode % 01000) < 0 || 0777 < (mode % 01000) ||
      !((mode | S_IFREG) ||
        (mode | S_IFDIR) ||
        (mode | S_IFLNK))) throw SOException(EINVAL, __FUNCTION__);
  SOSuperblock* super_block = soGetSuperblockPointer();

  if (super_block->ifree <= 0) throw SOException(ENOSPC, __FUNCTION__);

  uint32_t current_inode_number = get_free_inode_index(super_block);
  set_used_inode_index(super_block->ibitmap, current_inode_number);
  super_block->iidx = (current_inode_number) % MAX_INODES;
  super_block->ifree--;
  soSaveSuperblock();

  int ih = soOpenInode(current_inode_number);
  SOInode* current_inode = soGetInodePointer(ih);
  current_inode->mode = mode;
  current_inode->owner = getuid();
  current_inode->group = getgid();
  uint32_t timestamp = time(NULL);
  current_inode->atime = timestamp;
  current_inode->mtime = timestamp;
  current_inode->ctime = timestamp;
  memset((int8_t*)(current_inode) + sizeof(SOInode) - N_DIRECT * 4 - N_INDIRECT * 4 - N_DOUBLE_INDIRECT * 4,
         BlockNullReference, N_DIRECT * 4 + N_INDIRECT * 4 + N_DOUBLE_INDIRECT * 4);
  soSaveInode(ih);
  soCloseInode(ih);
  return current_inode_number;
}
};  // namespace sofs20