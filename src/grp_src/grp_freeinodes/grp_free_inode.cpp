/*
 *  \author António Rui Borges - 2012-2015
 *  \authur Artur Pereira - 2016-2020
 */

#include <errno.h>
#include <inttypes.h>
#include <stdio.h>
#include <sys/types.h>
#include <time.h>
#include <unistd.h>

#include "core.h"
#include "daal.h"
#include "devtools.h"
#include "freeinodes.h"
#include "string.h"

namespace sofs20 {

void set_freed_inode_index(uint32_t* ibitmap, uint32_t current_inode) {
  //ands the ibitmap with a 0 in the current_inodeth place
  ibitmap[current_inode / 32] = ibitmap[current_inode / 32] & (~(0b01 << (current_inode % 32)));
}
void grpFreeInode(uint16_t in) {
  soProbe(402, "%s(%u)\n", __FUNCTION__, in);

  //The following code sets all fields of the freed inode to its default
  if (in >= MAX_INODES || in < 0) throw SOException(EINVAL, __FUNCTION__);
  SOSuperblock* super_block = soGetSuperblockPointer();
  int inodeHandler = soOpenInode(in);
  SOInode* toFree = soGetInodePointer(inodeHandler);
  memset(toFree, 0, sizeof(SOInode));
  memset((int8_t*)(toFree) + sizeof(SOInode) - N_DIRECT * 4 - N_INDIRECT * 4 - N_DOUBLE_INDIRECT * 4,
         BlockNullReference, N_DIRECT * 4 + N_INDIRECT * 4 + N_DOUBLE_INDIRECT * 4);
  set_freed_inode_index(super_block->ibitmap, in);
  super_block->ifree++;
  soSaveSuperblock();
  soSaveInode(inodeHandler);
  soCloseInode(inodeHandler);
}

};  // namespace sofs20
