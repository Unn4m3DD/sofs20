#include <inttypes.h>
#include <pwd.h>
#include <string.h>
#include <sys/stat.h>
#include <time.h>
#include <unistd.h>

#include "bin_mksofs.h"
#include "core.h"
#include "devtools.h"
#include "grp_mksofs.h"
#include "rawdisk.h"

namespace sofs20 {
void grpFillInodeTable(uint32_t itotal, bool date) {
  soProbe(604, "%s(%u)\n", __FUNCTION__, itotal);
  SOInode inodes[itotal];
  inodes[0].mode = S_IFDIR | 0755;
  inodes[0].lnkcnt = 2;
  passwd* root_id = getpwnam("root");
  inodes[0].owner = root_id->pw_uid;
  inodes[0].group = root_id->pw_gid;
  inodes[0].size = 2 * sizeof(SODirentry);
  inodes[0].blkcnt = 1;
  uint32_t timestamp = time(NULL);
  inodes[0].atime = date ? timestamp : 0;
  inodes[0].mtime = date ? timestamp : 0;
  inodes[0].ctime = date ? timestamp : 0;
  memset(((int8_t*)(&inodes[0])) + sizeof(SOInode) - N_DIRECT * 4 - N_INDIRECT * 4 - N_DOUBLE_INDIRECT * 4,
         BlockNullReference, N_DIRECT * 4 + N_INDIRECT * 4 + N_DOUBLE_INDIRECT * 4);
  inodes[0].d[0] = 0;

  for (uint32_t i = 1; i < itotal; i++) {
    memset(&inodes[i], 0, sizeof(SOInode) - N_DIRECT * 4 - N_INDIRECT * 4 - N_DOUBLE_INDIRECT * 4);
    memset(((int8_t*)(&inodes[i])) + sizeof(SOInode) - N_DIRECT * 4 - N_INDIRECT * 4 - N_DOUBLE_INDIRECT * 4,
           BlockNullReference, N_DIRECT * 4 + N_INDIRECT * 4 + N_DOUBLE_INDIRECT * 4);
  }

  for (uint block = 0; block < (itotal + IPB - 1) / IPB; block++)
    soWriteRawBlock(block + 1, &inodes[block * IPB]);
  //soWriteRawBlock(1, inodes);
}
};  // namespace sofs20
