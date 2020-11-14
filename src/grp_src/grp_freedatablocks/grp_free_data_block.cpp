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
#include "freedatablocks.h"

namespace sofs20 {
void grpFreeDataBlock(uint32_t bn) {
  soProbe(442, "%s(%u)\n", __FUNCTION__, bn);
  //The following code inserts a block from the insertion cache

  SOSuperblock* sb = soGetSuperblockPointer();
  if (bn < 0 || sb->dbtotal <= bn) throw SOException(EINVAL, __FUNCTION__);
  if (sb->insertion_cache.idx == REF_CACHE_SIZE) {
    soDepleteInsertionCache();
    sb->insertion_cache.idx = 0;
  }
  while (sb->insertion_cache.ref[sb->insertion_cache.idx] != BlockNullReference)
    sb->insertion_cache.idx++;
  sb->insertion_cache.ref[sb->insertion_cache.idx++] = bn;
  sb->dbfree++;
  soSaveSuperblock();
}
};  // namespace sofs20
