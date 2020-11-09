#include <assert.h>
#include <errno.h>
#include <inttypes.h>

#include "core.h"
#include "daal.h"
#include "devtools.h"
#include "fileblocks.h"
#include "freedatablocks.h"

namespace sofs20 {
void grpFreeFileBlocks(int ih, uint32_t ffbn) {
  soProbe(303, "%s(%d, %u)\n", __FUNCTION__, ih, ffbn);

}
};  // namespace sofs20
