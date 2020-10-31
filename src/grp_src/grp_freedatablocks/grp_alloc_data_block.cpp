/*
 *  \author António Rui Borges - 2012-2015
 *  \authur Artur Pereira - 2009-2020
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
#include "freedatablocks.h"

namespace sofs20 {
uint32_t grpAllocDataBlock() {
  soProbe(441, "%s()\n", __FUNCTION__);
  SOSuperblock* sb = soGetSuperblockPointer();
  if (sb->dbfree == 0) throw SOException(ENOSPC, __FUNCTION__);
  if (sb->retrieval_cache.idx == REF_CACHE_SIZE) {
    soReplenishRetrievalCache();
    sb->retrieval_cache.idx = 0;
  }
  int result = sb->retrieval_cache.ref[sb->retrieval_cache.idx];
  sb->retrieval_cache.ref[sb->retrieval_cache.idx++] = BlockNullReference;
  sb->dbfree--;
  soSaveSuperblock();
  return result;
}
};  // namespace sofs20
