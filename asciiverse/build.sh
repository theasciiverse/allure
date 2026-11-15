#!/bin/sh
# Builds Allure of the Stars for the Asciiverse catalog into stage/: one
# static binary (Allure) with the ANSI terminal frontend as its display and
# no SDL2 in it (cabal.project.asciiverse, LambdaHack built with -f -sdl),
# plus the game's readme, help, licence and credits.
#
# Needs GHC (9.8 or newer), cabal, and the static libraries of gmp, ffi,
# numa and zlib (Debian and Ubuntu: libgmp-dev libffi-dev libnuma-dev
# zlib1g-dev). glibc is linked statically too; it only warns about the user
# and group lookups the unix package carries, which the game never makes.
set -eu
root=$(cd "$(dirname "$0")/.." && pwd)
cd "$root"
P="--project-file=cabal.project.asciiverse --builddir=dist-static"
jobs=${JOBS:-4}
cabal build -j"$jobs" $P --ghc-options="-optl-static -optl-pthread" exe:Allure
rm -rf stage
mkdir -p stage
cp "$(cabal list-bin $P exe:Allure)" stage/
strip stage/Allure
cp README.md CHANGELOG.md CREDITS LICENSE COPYLEFT GameDefinition/PLAYING.md stage/
file stage/Allure
ls -l stage
