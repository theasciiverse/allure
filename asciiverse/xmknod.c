/* GHC's ghcup build of the unix package was compiled against a glibc
 * older than 2.33, where mknod() was a macro over __xmknod(). Newer
 * glibc keeps __xmknod only in the shared library, so a static link
 * misses it. This gives the static link the old entry point. */
#include <sys/types.h>
#include <sys/stat.h>

int __xmknod(int ver, const char *path, mode_t mode, dev_t *dev)
{
    (void)ver;
    return mknod(path, mode, *dev);
}
