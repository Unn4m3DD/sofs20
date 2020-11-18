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
  SOInode* inode = soGetInodePointer(pih);
  inode->size -= sizeof(SODirentry);
  uint32_t dirDBIndex = getDirentryDBIndex(pih, name);
  uint32_t lastDirDBIndex = soGetFileBlock(pih, getLastUsedFileBlock(pih));
  SODirentry dir_entries_dest[DPB];
  SODirentry dir_entries_src[DPB];
  SODirentry* dir_entries_dest_ptr = dir_entries_dest;
  SODirentry* dir_entries_src_ptr = dir_entries_src;

  soReadDataBlock(dirDBIndex, dir_entries_dest);
  if (dirDBIndex == lastDirDBIndex) {
    dir_entries_src_ptr = dir_entries_dest_ptr;
  } else {
    soReadDataBlock(lastDirDBIndex, dir_entries_src);
  }

  uint32_t dest_idx;
  for (dest_idx = 0; dest_idx < DPB; dest_idx++)
    if (!strcmp(dir_entries_dest_ptr[dest_idx].name, name))
      break;
  uint32_t src_idx;
  for (src_idx = DPB - 1; src_idx >= 0; src_idx--)
    if (dir_entries_src_ptr[src_idx].name[0] != 0)
      break;
  uint32_t result = dir_entries_dest_ptr[dest_idx].in;

  memcpy(&dir_entries_dest_ptr[dest_idx], &dir_entries_src_ptr[src_idx], sizeof(SODirentry));
  memset(&dir_entries_src_ptr[src_idx], 0, sizeof(SODirentry));
  soWriteDataBlock(dirDBIndex, dir_entries_dest_ptr);
  soWriteDataBlock(lastDirDBIndex, dir_entries_src_ptr);

  /*
    Deletar fileblock qndo src_idx == 0
  */

  return result;
}
uint32_t getDirentryDBIndex(int pih, const char* name) {
  soProbe(201, "%s(%d, %s)\n", __FUNCTION__, pih, name);
  SOInode* inode = soGetInodePointer(pih);

  //This loop will search the directory in direct references
  for (int i = 0; i < N_DIRECT; i++) {
    SODirentry dir_entries[DPB];
    if (inode->d[i] == BlockNullReference) continue;
    soReadDataBlock(inode->d[i], dir_entries);
    for (uint32_t dir_idx = 0; dir_idx < DPB; dir_idx++) {
      if (!strcmp(dir_entries[dir_idx].name, name))
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
        if (!strcmp(dir_entries[dir_idx].name, name))
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
          if (!strcmp(dir_entries[dir_idx].name, name))
            return ref_block[j];
        }
      }
    }
  }
  return InodeNullReference;
}
};  // namespace sofs20
