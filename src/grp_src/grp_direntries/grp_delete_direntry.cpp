#include <errno.h>
#include <string.h>
#include <sys/stat.h>

#include "bin_direntries.h"
#include "core.h"
#include "daal.h"
#include "devtools.h"
#include "direntries.h"
#include "fileblocks.h"

namespace sofs20 {
uint32_t getDirentryDBIndex(int pih, const char* name);
uint32_t getLastUsedFileBlock(int ih);
uint16_t grpDeleteDirentry(int pih, const char* name) {
  soProbe(203, "%s(%d, %s)\n", __FUNCTION__, pih, name);
  uint32_t dirDBIndex = getDirentryDBIndex(pih, name);
  uint32_t lastDirDBIndex = getLastUsedFileBlock(pih);
  SODirentry dir_entries[DPB];
  soReadDataBlock(dirDBIndex, dir_entries);
  uint32_t dirIndex;
  for (dirIndex = 0; dirIndex < DPB; dirIndex++) {
    if (strcmp(dir_entries[dirIndex].name, name))
      break;
  }
  if (dirDBIndex == lastDirDBIndex) {
    memset(&dir_entries[dirIndex], 0, sizeof(SODirentry));
    soWriteDataBlock(dirDBIndex, dir_entries);
  }  // When dirIndex is in the last position
  else {
    uint32_t firstFree;
    SODirentry lastDir_entries[DPB];
    soReadDataBlock(dirDBIndex, lastDir_entries);
    for (firstFree = dirIndex; firstFree < DPB; firstFree++)
      if (strcmp(lastDir_entries[firstFree].name, ""))
        break;
    dir_entries[dirIndex] = lastDir_entries[firstFree - 1];
    memset(&lastDir_entries[firstFree - 1], 0, sizeof(SODirentry));
    soWriteDataBlock(dirDBIndex, dir_entries);
    soWriteDataBlock(lastDirDBIndex, lastDir_entries);
  }  //delete dirIndex and move dir (firstFree - 1) to it's place

  return dirIndex;
}
uint32_t getDirentryDBIndex(int pih, const char* name) {
  soProbe(201, "%s(%d, %s)\n", __FUNCTION__, pih, name);
  SOInode* inode = soGetInodePointer(pih);
  inode->size -= sizeof(SODirentry);

  //This loop will search the directory in direct references
  for (int i = 0; i < N_DIRECT; i++) {
    SODirentry dir_entries[DPB];
    if (inode->d[i] == BlockNullReference) continue;
    soReadDataBlock(inode->d[i], dir_entries);
    for (uint32_t dir_idx = 0; dir_idx < DPB; dir_idx++) {
      if (strcmp(dir_entries[dir_idx].name, name))
        return inode->d[i];
    }
  }

  //This loop will search the directory in indirect references
  for (int i = 0; i < N_INDIRECT; i++) {
    uint32_t ref_block[RPB];
    if (inode->i1[i] == BlockNullReference) continue;
    soReadDataBlock(inode->i1[i], ref_block);
    for (uint32_t j = 0; j < RPB; j++) {
      SODirentry dir_entries[DPB];
      if (ref_block[j] == BlockNullReference) continue;
      soReadDataBlock(ref_block[j], ref_block);
      for (uint32_t dir_idx = 0; dir_idx < DPB; dir_idx++) {
        if (strcmp(dir_entries[dir_idx].name, name))
          return ref_block[j];
      }
    }
  }

  //This loop will search the directory in double indirect references
  for (int i = 0; i < N_DOUBLE_INDIRECT; i++) {
    uint32_t outer_ref_block[RPB];
    if (inode->i2[i] == BlockNullReference) continue;
    soReadDataBlock(inode->i2[i], outer_ref_block);
    for (uint32_t k = 0; k < RPB; k++) {
      uint32_t ref_block[RPB];
      if (outer_ref_block[k] == BlockNullReference) continue;
      soReadDataBlock(outer_ref_block[k], ref_block);
      for (uint32_t j = 0; j < RPB; j++) {
        SODirentry dir_entries[DPB];
        if (ref_block[j] == BlockNullReference) continue;
        soReadDataBlock(ref_block[j], dir_entries);
        for (uint32_t dir_idx = 0; dir_idx < DPB; dir_idx++) {
          if (strcmp(dir_entries[dir_idx].name, name))
            return ref_block[j];
        }
      }
    }
  }
  return InodeNullReference;
}
};  // namespace sofs20
