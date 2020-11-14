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
    //This code handles the case where there is no ref table, it copies directly from the insertion cache to the retrieval
    for (uint i = 1; i < sb->insertion_cache.idx + 1; i++) {
      sb->retrieval_cache.ref[REF_CACHE_SIZE - i] = sb->insertion_cache.ref[sb->insertion_cache.idx - i];
      sb->insertion_cache.ref[sb->insertion_cache.idx - i] = BlockNullReference;
    }
    sb->insertion_cache.idx = 0;
  } else {
    soOpenReferenceTable();
    uint32_t* ref_table = soGetReferenceBlockPointer(sb->reftable.blk_idx);
    uint offset = 0;
    bool out_of_references = false;
    //this loop finds out where do the references to blocks start calculating an offset to the start of the ref_idx
    for (uint i = sb->reftable.ref_idx; i < sb->reftable.ref_idx + REF_CACHE_SIZE && i < RPB; i++) {
      if (ref_table[i] == BlockNullReference) {
        out_of_references = true;
        break;
      }
      offset++;
    }

    //There are offset blocks to copy
    for (uint i = 0; i < offset; i++) {
      sb->retrieval_cache.ref[REF_CACHE_SIZE - offset + i] = ref_table[i + sb->reftable.ref_idx];
      ref_table[i + sb->reftable.ref_idx] = BlockNullReference;
      sb->reftable.count--;
    }
    //The following code updates metadata related to the reftable
    if (sb->reftable.ref_idx + REF_CACHE_SIZE >= RPB) {
      sb->reftable.blk_idx = (sb->reftable.blk_idx + 1) % sb->rt_size;
      sb->reftable.ref_idx = 0;
    } else if (out_of_references)
      sb->reftable.ref_idx = 0;
    else
      sb->reftable.ref_idx += REF_CACHE_SIZE;

    sb->retrieval_cache.idx = REF_CACHE_SIZE - offset;
    soSaveReferenceBlock();
    soCloseReferenceTable();
  }
  soSaveSuperblock();
}
};  // namespace sofs20
