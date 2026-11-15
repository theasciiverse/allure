#!/bin/sh
# The C compiler GHC links through for the static release build. Linking an
# executable, it adds -static (and -pthread); shared objects, which GHC
# still makes for Template Haskell while building the libraries, are
# linked as they would be anyway. GHC may pass the arguments in a response
# file (@file), so that is looked in too.
for a in "$@"; do
  case "$a" in
    -shared) exec "${CC:-cc}" "$@" ;;
    @*) grep -q -- '-shared' "${a#@}" 2>/dev/null && exec "${CC:-cc}" "$@" ;;
  esac
done
# xmknod.c: the old glibc entry point GHC's unix package still calls
exec "${CC:-cc}" "$@" "$(dirname "$0")/xmknod.c" -static -pthread
