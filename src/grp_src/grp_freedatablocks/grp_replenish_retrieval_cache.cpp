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
  if (sb->reftable.count != 0) {
    //go get from insertion
  }
  soOpenReferenceTable();
  uint32_t* refT = soGetReferenceBlockPointer(sb->reftable.blk_idx);
  uint offset = RPB - sb->reftable.ref_idx;
  if (offset > REF_CACHE_SIZE) offset = REF_CACHE_SIZE;
  for (uint i = sb->reftable.ref_idx; i < sb->reftable.ref_idx + REF_CACHE_SIZE && i < RPB; i++) {
    sb->retrieval_cache.ref[REF_CACHE_SIZE - offset + i] = refT[i];
    refT[i] = BlockNullReference;
  }
  if (sb->reftable.ref_idx + REF_CACHE_SIZE >= RPB) {
    sb->reftable.blk_idx = (sb->reftable.blk_idx + 1) % sb->rt_size;
    sb->reftable.ref_idx = 0;
  } else
    sb->reftable.ref_idx += REF_CACHE_SIZE;
  sb->retrieval_cache.idx = 0;
  soSaveReferenceBlock();
  soCloseReferenceTable();
  soCloseSuperblock();
}
};  // namespace sofs20
