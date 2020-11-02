/*
 *  \author António Rui Borges - 2012-2015
 *  \authur Artur Pereira - 2016-2020
 */

#include <errno.h>
#include <stdio.h>
#include <string.h>

#include <iostream>

#include "core.h"
#include "daal.h"
#include "devtools.h"
#include "freedatablocks.h"
using namespace std;

namespace sofs20 {
/* only fill the current block to its end */
void grpDepleteInsertionCache(void) {
  soProbe(444, "%s()\n", __FUNCTION__);

  /* replace the following line with your code */
  //binDepleteInsertionCache();
  SOSuperblock* sb = soGetSuperblockPointer();
  soOpenReferenceTable();
  if (sb->insertion_cache.idx != REF_CACHE_SIZE) return;
  uint32_t* ref_table  = soGetReferenceBlockPointer(
      (sb->reftable.blk_idx + (sb->reftable.ref_idx + sb->reftable.count + 1) / RPB) % sb->rt_size);

  uint last_not_null;
  for (uint i = 0; i < RPB; i++)
    if (ref_table[i] != BlockNullReference) last_not_null = i;
  
  uint offset;
  for (offset = last_not_null; offset < RPB; offset++)
    if (ref_table[offset] == BlockNullReference) break;

  uint i;
  for (i = 0; i + offset < RPB && i < REF_CACHE_SIZE; i++) {
    ref_table[i + offset] = sb->insertion_cache.ref[i];
    cout << i + offset << endl;
    sb->insertion_cache.ref[i] = BlockNullReference;
    sb->reftable.count++;
  }
  sb->insertion_cache.idx = 0;
  if (i < REF_CACHE_SIZE) sb->reftable.blk_idx = (sb->reftable.blk_idx + 1) % sb->rt_size;
  for (uint j = 0; i < REF_CACHE_SIZE; j++) {
    sb->insertion_cache.ref[j] = sb->insertion_cache.ref[i];
    sb->insertion_cache.ref[i] = BlockNullReference;
    i++;
    sb->insertion_cache.idx++;
  }
  soSaveReferenceBlock();
  soCloseReferenceTable();
  soSaveSuperblock();
}
};  // namespace sofs20
