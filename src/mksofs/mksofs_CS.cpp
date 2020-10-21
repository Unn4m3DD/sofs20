/*
 *  \authur Artur Pereira - 2009-2020
 */

#include "mksofs.h"

#include "core.h"
#include "devtools.h"

#include <inttypes.h>

namespace sofs20
{
    /* see mksofs.h for a description */
    void soComputeStructure(uint32_t ntotal, uint32_t & itotal, uint32_t & dbtotal)
    {
        if (soBinSelected(601))
            binComputeStructure(ntotal, itotal, dbtotal);
        else
            grpComputeStructure(ntotal, itotal, dbtotal);
    }

};
