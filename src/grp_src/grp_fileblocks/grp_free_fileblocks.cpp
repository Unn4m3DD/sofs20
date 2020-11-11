#include <assert.h>
#include <errno.h>
#include <inttypes.h>

#include <cmath>

#include "core.h"
#include "daal.h"
#include "devtools.h"
#include "fileblocks.h"
#include "freedatablocks.h"
namespace sofs20 {
SOInode* inode;
uint32_t to_free_count, free_count = 0;
void free_rec(uint32_t* reference, uint32_t depth) {
  if (*reference == BlockNullReference) {
    free_count += pow(RPB, depth);
  }
  if (depth != 0) {
    uint32_t ref_block[RPB];
    soReadDataBlock(*reference, ref_block);
    for (uint32_t i = 0; i < RPB; i++) {
      if (free_count > to_free_count) return;
      free_rec(&ref_block[i], depth - 1);
    }
    soWriteDataBlock(*reference, ref_block);
  }
  if (*reference != BlockNullReference) {
    inode->blkcnt--;
    *reference = BlockNullReference;
  }
  if (depth == 0) {
    free_count++;
  }
}

void grpFreeFileBlocks(int ih, uint32_t ffbn) {
  soProbe(303, "%s(%d, %u)\n", __FUNCTION__, ih, ffbn);
  inode = soGetInodePointer(ih);
  to_free_count = N_DIRECT + N_INDIRECT * RPB + N_DOUBLE_INDIRECT * RPB * RPB - ffbn;
  uint8_t depths[N_DIRECT + N_INDIRECT + N_DOUBLE_INDIRECT];
  //poderia ser substituído pelos valores mas deixaria de depender das macros definidas
  //uint8_t depths[] = {0, 0, 0, 0, 1, 1, 1, 2};
  int i = 0;
  while (i++ < N_DIRECT)
    depths[i] = 0;
  while (i++ < N_INDIRECT)
    depths[i] = 1;
  while (i++ < N_DOUBLE_INDIRECT)
    depths[i] = 2;

  for (
      uint32_t current = N_DIRECT + N_INDIRECT + N_DOUBLE_INDIRECT - ffbn;
      free_count < to_free_count;
      current--) {
    free_rec(inode->d + current, depths[current]);
  }
}

};  // namespace sofs20
