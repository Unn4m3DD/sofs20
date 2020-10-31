/*
 *  \author António Rui Borges - 2012-2015
 *  \authur Artur Pereira - 2016-2020
 */

#include "freedatablocks.h"

#include "core.h"
#include "devtools.h"
#include "daal.h"

#include <stdio.h>
#include <errno.h>
#include <string.h>
#include <iostream>
using namespace std;

namespace sofs20
{
    /* only fill the current block to its end */
    void grpDepleteInsertionCache(void)
    {
        soProbe(444, "%s()\n", __FUNCTION__);

        /* replace the following line with your code */
        //binDepleteInsertionCache();
        SOSuperblock* sb = soGetSuperblockPointer();
        soOpenReferenceTable();
        if(sb->insertion_cache.idx != REF_CACHE_SIZE) return;
        uint32_t* reft = soGetReferenceBlockPointer(sb->reftable.blk_idx);
        uint i;
        for(i = sb->reftable.ref_idx; i < RPB && i < sb->reftable.ref_idx + REF_CACHE_SIZE; i++) {
          reft[i] = sb->insertion_cache.ref[i - sb->reftable.ref_idx];
          sb->insertion_cache.ref[i - sb->reftable.ref_idx] = BlockNullReference;
        }
        sb->insertion_cache.idx = i - sb->reftable.ref_idx + 1;
        soSaveReferenceBlock();
        soCloseReferenceTable();
        soSaveSuperblock();
    }
};

