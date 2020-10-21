#include <inttypes.h>

#include <iostream>

#include "bin_mksofs.h"
#include "core.h"
#include "devtools.h"
#include "grp_mksofs.h"

namespace sofs20 {
void grpComputeStructure(uint32_t ntotal, uint32_t& itotal, uint32_t& dbtotal) {
  soProbe(601, "%s(%u, %u, ...)\n", __FUNCTION__, ntotal, itotal);

  /* replace the following line with your code */
  //binComputeStructure(ntotal, itotal, dbtotal);
  //return;
  itotal = ((itotal + IPB - 1)/IPB) * IPB;
  if(itotal > (ntotal + 7)/8) {
    itotal = (ntotal + 7)/8;
  }
  if(itotal < IPB) {
    itotal = IPB;
  }
  /*if(itotal == 0) {
    itotal = ntotal/16;
  }*/
  
  // (dbtotal - REF_CACHE_SIZE * 8) / RPB = ntotal - 1 - itotal / IPB - dbtotal;
  // (dbtotal - REF_CACHE_SIZE * 8) / RPB + dbtotal = ntotal - 1 - itotal / IPB;
  // (dbtotal - REF_CACHE_SIZE * 8) + RPB * dbtotal/ RPB = ntotal - 1 - itotal / IPB;
  // (REF_CACHE_SIZE * 8 + RPB * dbtotal * (RPB + 1))/ RPB = ntotal - 1 - itotal / IPB;
  // REF_CACHE_SIZE * 8 + RPB * dbtotal * (RPB + 1) = RPB * (ntotal - 1 - itotal / IPB);
  // RPB * dbtotal * (RPB + 1)= RPB * (ntotal - 1 - itotal / IPB) - REF_CACHE_SIZE * 8;
  // dbtotal * (RPB + 1)= ntotal - 1 - itotal / IPB - (REF_CACHE_SIZE * 8) / RPB;
  dbtotal = (ntotal - 1 - itotal / IPB - (REF_CACHE_SIZE * 8) / RPB) / (RPB + 1);
  



  
}
}  // namespace sofs20
