#include <inttypes.h>
#include <string.h>
#include <superblock.h>

#include "bin_mksofs.h"
#include "core.h"
#include "devtools.h"
#include "grp_mksofs.h"
#include "rawdisk.h"

namespace sofs20 {
void grpFillSuperblock(const char* name, uint32_t ntotal, uint32_t itotal, uint32_t dbtotal) {
  soProbe(602, "%s(%s, %u, %u, %u)\n", __FUNCTION__, name, ntotal, itotal, dbtotal);
  /* replace the following line with your code */
  //binFillSuperblock(name, ntotal, itotal, dbtotal);
  //return;
  SOSuperblock sb;
  memset(&sb, 0, sizeof(SOSuperblock));
  sb.magic = 0xFFFF;

  sb.version = VERSION_NUMBER;

  sb.mntstat = 0;

  strcpy(sb.name, name);

  sb.ntotal = ntotal;

  sb.itotal = itotal;

  sb.ifree = itotal - 1;

  sb.iidx = 0;

  sb.ibitmap[0] = 1;

  sb.dbp_start = 1 + (itotal + IPB - 1) / IPB;

  sb.dbtotal = dbtotal;

  sb.dbfree = dbtotal - 1;

  sb.rt_start = sb.dbp_start + sb.dbtotal;

  sb.rt_size = sb.ntotal - sb.rt_start;

  sb.reftable.blk_idx = 0;
  sb.reftable.ref_idx = 0;
  sb.reftable.count = sb.dbfree > REF_CACHE_SIZE ? sb.dbfree - REF_CACHE_SIZE : 0;

  sb.retrieval_cache.idx = REF_CACHE_SIZE > dbtotal - 1 ? REF_CACHE_SIZE - dbtotal + 1 : 0;
  uint current = 1;
  for (uint i = 0; i < REF_CACHE_SIZE; i++)
    if (i > REF_CACHE_SIZE - dbtotal || dbtotal > REF_CACHE_SIZE)
      sb.retrieval_cache.ref[i] = current++;
    else
      sb.retrieval_cache.ref[i] = BlockNullReference;

  //for (uint i = 0; i < dbtotal; i++)
  //  if (i < dbtotal)
  //    sb.insertion_cache.ref[REF_CACHE_SIZE - i] = -i + dbtotal;
  //  else
  //    sb.retrieval_cache.ref[i] = BlockNullReference;

  sb.insertion_cache.idx = 0;
  memset(sb.insertion_cache.ref, BlockNullReference, REF_CACHE_SIZE * 4);
  soWriteRawBlock(0, &sb);
}
};  // namespace sofs20
