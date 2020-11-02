#include <assert.h>
#include <errno.h>
#include <inttypes.h>

#include "core.h"
#include "daal.h"
#include "devtools.h"
#include "fileblocks.h"
#include "freedatablocks.h"

namespace sofs20 {

/* free all blocks between positions ffbn and RPB - 1
     * existing in the block of references given by i1.
     * Return true if, after the operation, all references become BlockNullReference.
     * It assumes i1 is valid.
     */
static bool grpFreeIndirectFileBlocks(SOInode* ip, uint32_t i1, uint32_t ffbn) {
  if (ffbn > RPB - 1) return false;
  for (uint32_t i = 0; i < RPB - 1; i++)
    ip->i1[i] = BlockNullReference;
  return true;
}

/* free all blocks between positions ffbn and RPB**2 - 1
     * existing in the block of indirect references given by i2.
     * Return true if, after the operation, all references become BlockNullReference.
     * It assumes i2 is valid.
     */
static bool grpFreeDoubleIndirectFileBlocks(SOInode* ip, uint32_t i2, uint32_t ffbn) {
  if (ffbn > RPB * RPB - 1) return false;
  for (uint32_t i = 0; i < RPB * RPB - 1; i++)
    ip->i1[i] = BlockNullReference;
  return true;
}

/* ********************************************************* */

void grpFreeFileBlocks(int ih, uint32_t ffbn) {
  soProbe(303, "%s(%d, %u)\n", __FUNCTION__, ih, ffbn);
  (void)grpFreeDoubleIndirectFileBlocks;
  (void)grpFreeIndirectFileBlocks;
  /* replace the following line with your code */
  //binFreeFileBlocks(ih, ffbn);
}

#if false
    static bool grpFreeDoubleIndirectFileBlocks(SOInode * ip, uint32_t i2, uint32_t ffbn)
    {
        soProbe(303, "%s(..., %u, %u)\n", __FUNCTION__, i2, ffbn);

        /* replace the following line with your code */
        throw SOException(ENOSYS, __FUNCTION__); 
    }
#endif

/* ********************************************************* */
};  // namespace sofs20
