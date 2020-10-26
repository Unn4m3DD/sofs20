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
void grpFreeInode(uint16_t in) {
  soProbe(402, "%s(%u)\n", __FUNCTION__, in);

  /* replace the following line with your code */
  //binFreeInode(in);
  if (in >= MAX_INODES || in < 0) throw SOException(EINVAL, __FUNCTION__);
  SOSuperblock* super_block = soGetSuperblockPointer();
  int inodeHandler = soOpenInode(in);
  SOInode* toFree = soGetInodePointer(soOpenInode(inodeHandler));
  memset(toFree, 0, sizeof(SOInode));
  for(int i = 0; i < N_DIRECT; i++) toFree->d[i] = 0xFF;
  for(int i = 0; i < N_INDIRECT; i++) toFree->i1[i] = 0xFF;
  for(int i = 0; i < N_DOUBLE_INDIRECT; i++) toFree->i2[i] = 0xFF;
  set_used_inode_index(super_block->ibitmap, in);
  super_block->ifree++;
  soSaveSuperblock();
  soSaveInode(inodeHandler);
  soCloseInode(inodeHandler);

}

void set_used_inode_index(uint32_t* ibitmap, uint32_t current_inode) {
  ibitmap[current_inode / 32] = ibitmap[current_inode / 32] & (~(0b01 << (current_inode % 32)));
}
};  // namespace sofs20
