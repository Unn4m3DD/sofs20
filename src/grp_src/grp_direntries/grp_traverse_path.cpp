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
  if (inode->owner != getuid() && inode->group != getgid() && !(inode->mode & 0001))
    valid_permissions = false;
  if (inode->owner == getuid() && !(inode->mode | 0100))
    valid_permissions = false;
  if (inode->group == getgid() && !(inode->mode | 0010))
    valid_permissions = false;
  if (!valid_permissions)
    throw SOException(EACCES, __FUNCTION__);
}

uint16_t traversePath(char** path, int path_len, int current_inode) {
  //if the current path_len is > 1 it searches recursively else it return the found/not found inode
  int ih = soOpenInode(current_inode);
  SOInode* inode = soGetInodePointer(ih);
  if (path_len > 1)
    assert_exceptions(path_len, inode);
  uint32_t path_inode_number = soGetDirentry(ih, path[0]);
  soCloseInode(ih);
  if (path_inode_number != InodeNullReference) {
    if (path_len > 1)
      traversePath(&path[1], path_len - 1, path_inode_number);
    else
      return path_inode_number;
  }
  throw SOException(ENOENT, __FUNCTION__);
}

uint16_t grpTraversePath(char* path) {
  //convers path to an array of char* splitted by "/", analogous to path.split("/") on a higher level language
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
  printf("%s\n", path);
  for(int i = 0; i < current_args; i++){
    printf("%s -> ", path_args[i]);
  }
  return traversePath(path_args, current_args, 0);
}
};  // namespace sofs20
