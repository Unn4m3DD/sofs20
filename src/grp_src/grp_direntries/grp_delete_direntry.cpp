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
  uint32_t lastUsedFB = getLastUsedFileBlock(pih);
  uint32_t lastDirDBIndex = soGetFileBlock(pih, lastUsedFB);
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
  if(src_idx == 0) 
    soFreeFileBlocks(pih, lastUsedFB);

  return result;
}

uint32_t getDirentryDBIndex(int pih, const char* name) {
  SOInode* inode = soGetInodePointer(pih);

}

uint32_t getDirentryDBIndex(int pih, const char* name) {
  SOInode* inode = soGetInodePointer(pih);
  //Loop to search the direct refs
  for (uint32_t i = 0; i < N_DIRECT; i++) {
    if (inode->d[i] == BlockNullReference) continue;
    SODirentry dir_entries[DPB];
    soReadDataBlock(inode->d[i], dir_entries);            //Reads the db with dirs
    for (uint32_t dir_i = 0; dir_i < DPB; dir_i++) {
      if (strcmp(dir_entries[dir_i].name, name) == 0)
        return inode->d[i];                               //Returns the ref
    }
  }
  //dir not found in the direct refs
  //Loop to search the indirect refs
  for (uint32_t i = 0; i < N_INDIRECT; i++) {
    if (inode->i1[i] == BlockNullReference) continue;
    uint32_t i_ref_block[RPB];
    soReadDataBlock(inode->i1[i], i_ref_block);          //Reads db with refs
    for (uint32_t j = 0; j < RPB; j++) {
      if (i_ref_block[j] == BlockNullReference) continue;
      SODirentry dir_entries[DPB];
      soReadDataBlock(i_ref_block[j], dir_entries);        //Reads db with dirs
      for (uint32_t dir_i = 0; dir_i < DPB; dir_i++) {
        if (strcmp(dir_entries[dir_i].name, name) == 0)
          return i_ref_block[j];                         //Returns the ref
      }
    }
  }
  //dir not found in the indirect refs
  //Loop to search the doubl indirect refs
  for (uint32_t i = 0; i < N_DOUBLE_INDIRECT; i++) {
    if (inode->i2[i] == BlockNullReference) continue;
    uint32_t di_ref_block[RPB];
    soReadDataBlock(inode->i2[i], di_ref_block);          //Reads db with refs    
    for (uint32_t j = 0; j < RPB; j++) {
      if (di_i_ref_block[j] == BlockNullReference) continue;
      uint32_t i_ref_block[RPB];
      soReadDataBlock(di_i_ref_block[j], i_ref_block);        //Reads db with refs
      for (uint32_t k = 0; k < RPB; k++) {
        if (i_ref_block[k] == BlockNullReference) continue;
        SODirentry dir_entries[DPB];
        soReadDataBlock(i_ref_block[k], dir_entries);          //Reads db with dirs
        for (uint32_t dir_i = 0; dir_i < DPB; dir_i++) {
          if (strcmp(dir_entries[dir_i].name, name) == 0)
            return i_ref_block[k];                             //Returns the ref
        }
      }
    }
  }
  return InodeNullReference;
}
};  // namespace sofs20
