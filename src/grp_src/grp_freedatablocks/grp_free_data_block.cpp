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

  /* replace the following line with your code */
  
  SOSuperblock* sb = soGetSuperblockPointer();
  if (bn < 0 || sb->dbtotal <= bn) throw SOException(EINVAL, __FUNCTION__);
  if (sb->insertion_cache.idx == REF_CACHE_SIZE - 1)
    soDepleteInsertionCache();
  for (int idx = 0; idx < REF_CACHE_SIZE; idx++)
    if (sb->insertion_cache.ref[idx] == BlockNullReference) {
      sb->insertion_cache.ref[idx] = bn;
      break;
    }
  sb->dbfree++;
  soSaveSuperblock();
}
};  // namespace sofs20
