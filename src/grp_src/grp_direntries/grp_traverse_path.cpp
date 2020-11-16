#include <errno.h>
#include <libgen.h>
#include <stdlib.h>
#include <string.h>
#include <sys/stat.h>
#include <unistd.h>

#include "bin_direntries.h"
#include "core.h"
#include "daal.h"
#include "devtools.h"
#include "direntries.h"
#include "fileblocks.h"

namespace sofs20 {
void assert_exceptions(int path_len, SOInode* inode) {
  if (path_len != 0 && !(inode->mode | S_IFDIR))
    throw SOException(ENOTDIR, __FUNCTION__);
  bool valid_permissions = true;
  if (inode->owner != getuid() && inode->group != getgid() && !(inode->mode & 0b010))
    valid_permissions = false;
  if (inode->owner == getuid() && !(inode->mode | 0b010000000))
    valid_permissions = false;
  if (inode->group == getgid() && !(inode->mode | 0b000010000))
    valid_permissions = false;
  if (!valid_permissions)
    throw SOException(EACCES, __FUNCTION__);
}

uint16_t traversePath(char** path, int path_len, int current_inode) {
  int ih = soOpenInode(current_inode);
  SOInode* inode = soGetInodePointer(ih);
  assert_exceptions(path_len, inode);

  //This loop will search the directory in direct references
  for (int i = 0; i < N_DIRECT; i++) {
    SODirentry dir_entries[DPB];
    if (inode->d[i] == BlockNullReference) continue;
    soReadDataBlock(inode->d[i], dir_entries);
    for (int dir_idx = 0; dir_idx < DPB; dir_idx++) {
      if (strcmp(dir_entries[dir_idx].name, path[0]))
        if (path_len == 1)
          return dir_entries[dir_idx].in;
        else
          return traversePath(&path[1], path_len - 1, dir_entries[dir_idx].in);
    }
  }

  //This loop will search the directory in indirect references
  for (int i = 0; i < N_INDIRECT; i++) {
    uint32_t ref_block[RPB];
    if (inode->i1[i] == BlockNullReference) continue;
    soReadDataBlock(inode->i1[i], ref_block);
    for (int j = 0; j < RPB; j++) {
      SODirentry dir_entries[DPB];
      if (ref_block[j] == BlockNullReference) continue;
      soReadDataBlock(ref_block[j], ref_block);
      for (int dir_idx = 0; dir_idx < DPB; dir_idx++) {
        if (strcmp(dir_entries[dir_idx].name, path[0]))
          if (path_len == 1)
            return dir_entries[dir_idx].in;
          else
            return traversePath(&path[1], path_len - 1, dir_entries[dir_idx].in);
      }
    }
  }

  //This loop will search the directory in double indirect references
  for (int i = 0; i < N_DOUBLE_INDIRECT; i++) {
    uint32_t outer_ref_block[RPB];
    if (inode->i2[i] == BlockNullReference) continue;
    soReadDataBlock(inode->i2[i], outer_ref_block);
    for (int k = 0; k < RPB; k++) {
      uint32_t ref_block[RPB];
      if (outer_ref_block[k] == BlockNullReference) continue;
      soReadDataBlock(outer_ref_block[k], ref_block);
      for (int j = 0; j < RPB; j++) {
        SODirentry dir_entries[DPB];
        if (ref_block[j] == BlockNullReference) continue;
        soReadDataBlock(ref_block[j], ref_block);
        for (int dir_idx = 0; dir_idx < DPB; dir_idx++) {
          if (strcmp(dir_entries[dir_idx].name, path[0]))
            if (path_len == 1)
              return dir_entries[dir_idx].in;
            else
              return traversePath(&path[1], path_len - 1, dir_entries[dir_idx].in);
        }
      }
    }
  }

  soCloseInode(ih);
}

uint16_t grpTraversePath(char* path) {
  soProbe(221, "%s(%s)\n", __FUNCTION__, path);
  int path_len = strlen(path);
  char* path_copy = (char*)alloca(path_len + 1);
  strcpy(path_copy, path);
  char** path_args = (char**)alloca(path_len);
  int current_args = 0;
  for (int i = 0; i < path_len; i++) {
    if (path[i] == '/') {
      path_copy[i] = '\0';
      path_args[current_args++] = &path_copy[i + 1];
    }
  }
  return traversePath(path_args, current_args, 0);
}
};  // namespace sofs20
