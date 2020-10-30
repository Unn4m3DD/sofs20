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

  /* replace the following line with your code */
  //return binAllocDataBlock();
  SOSuperblock* sb = soGetSuperblockPointer();
  if (sb->dbfree == 0) throw SOException(ENOSPC, __FUNCTION__);
  if (sb->retrieval_cache.idx == REF_CACHE_SIZE - 1)
    soReplenishRetrievalCache();
  int idx = 0;
  for (;sb->retrieval_cache.ref[idx] == BlockNullReference; idx++);
  int res = sb->retrieval_cache.ref[idx];
  sb->retrieval_cache.ref[idx] = BlockNullReference;
  soSaveSuperblock();
  return res;
}
};  // namespace sofs20
