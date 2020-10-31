/*
 *  \author António Rui Borges - 2012-2015
 *  \authur Artur Pereira - 2016-2020
 */

#include <errno.h>
#include <string.h>

#include <iostream>

#include "core.h"
#include "daal.h"
#include "devtools.h"
#include "freedatablocks.h"

namespace sofs20 {
void grpReplenishRetrievalCache(void) {
  soProbe(443, "%s()\n", __FUNCTION__);

  SOSuperblock* sb = soGetSuperblockPointer();
  if (sb->retrieval_cache.idx != REF_CACHE_SIZE) return;
  if (sb->reftable.count == 0) {
    for (uint i = sb->insertion_cache.idx; i < REF_CACHE_SIZE; i++) {
      sb->retrieval_cache.ref[REF_CACHE_SIZE - sb->insertion_cache.idx + i] = sb->insertion_cache.ref[i];
      sb->insertion_cache.ref[i] = BlockNullReference;
    }
    sb->insertion_cache.idx = 0;
    return;
  }
  soOpenReferenceTable();
  uint32_t* ref_table = soGetReferenceBlockPointer(sb->reftable.blk_idx);
  uint offset = RPB - sb->reftable.ref_idx;
  if (offset > REF_CACHE_SIZE) offset = REF_CACHE_SIZE;
  for (uint i = 0; i < offset; i++) {
    sb->retrieval_cache.ref[REF_CACHE_SIZE - offset + i] = ref_table[i + sb->reftable.ref_idx];
    ref_table[i + sb->reftable.ref_idx] = BlockNullReference;
    sb->reftable.count--;
  }
  if (sb->reftable.ref_idx + REF_CACHE_SIZE >= RPB) {
    sb->reftable.blk_idx = (sb->reftable.blk_idx + 1) % sb->rt_size;
    sb->reftable.ref_idx = 0;
  } else
    sb->reftable.ref_idx += REF_CACHE_SIZE;
  sb->retrieval_cache.idx = 0;
  soSaveReferenceBlock();
  soCloseReferenceTable();

  soSaveSuperblock();
}
};  // namespace sofs20
