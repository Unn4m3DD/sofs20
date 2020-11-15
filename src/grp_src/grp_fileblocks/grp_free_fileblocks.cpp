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
//depth means the number of "indirectness" of a reference,
// d has depth 0, i1 has depth 1 and i2 has depth 2
void free_rec(uint32_t* reference, uint32_t depth) {
  //if the content of the reference is BlockNullReference it means that every inner data block
  //has been virtually freed, RPB^depth blocks were freed
  if (*reference == BlockNullReference) {
    free_count += pow(RPB, depth);
    return;
  }
  //if the block is a references block every inner reference is free recursively
  if (depth != 0) {
    uint32_t ref_block[RPB];
    soReadDataBlock(*reference, ref_block);
    for (uint32_t i = 0; i < RPB; i++) {
      if (free_count > to_free_count) return;
      free_rec(&ref_block[i], depth - 1);
    }
    soWriteDataBlock(*reference, ref_block);
  }
  //the given reference is freed if it wasn't already
  if (*reference != BlockNullReference) {
    inode->blkcnt--;
    soFreeDataBlock(*reference);
    *reference = BlockNullReference;
  }
  //if the reference were to a data block free_count is incremented
  if (depth == 0)
    free_count++;
}

void grpFreeFileBlocks(int ih, uint32_t ffbn) {
  soProbe(303, "%s(%d, %u)\n", __FUNCTION__, ih, ffbn);
  //soGetFileBlock(ih, ffbn); // throws exception on invalid file block number, apparently we should not do it
  inode = soGetInodePointer(ih);
  //there are to_free_count blocks to free
  to_free_count = N_DIRECT + N_INDIRECT * RPB + N_DOUBLE_INDIRECT * RPB * RPB - ffbn;
  uint8_t depths[N_DIRECT + N_INDIRECT + N_DOUBLE_INDIRECT];
  //depths poderia ser substituído pelos valores mas deixaria de depender das macros definidas
  //poderia também ser definido com uma macro
  //uint8_t depths[] = {0, 0, 0, 0, 1, 1, 1, 2};
  int i = -1;
  while (++i < N_DIRECT)
    depths[i] = 0;
  do
    depths[i] = 1;
  while (++i < N_DIRECT + N_INDIRECT);
  do
    depths[i] = 2;
  while (++i < N_DIRECT + N_INDIRECT + N_DOUBLE_INDIRECT);

  for (
      uint32_t current = N_DIRECT + N_INDIRECT + N_DOUBLE_INDIRECT - 1;
      free_count < to_free_count;
      current--) {
    // all fileblocks are freed until the number of freed blocks is equal to the number
    // of blocks to free
    // as d i1 and i2 are continguos in memory and have the same size we can index each
    // one of them by adding to d pointer:
    // d + 0..3 are direct refs
    // d + 4..6 are indirect refs
    // d + 7 are double indirect refs
    free_rec(inode->d + current, depths[current]);
  }
  printf("%u\n", free_count);
}

};  // namespace sofs20
