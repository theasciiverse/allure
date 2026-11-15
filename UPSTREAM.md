# For upstream

Hi Mikolaj. Two small changes to LambdaHack on this branch might be useful
to you as they stand. Both are in `LambdaHack/`, a subtree of your
`v0.11.0.1` tag, the version Allure 0.11 builds against.

## A build without SDL2

`LambdaHack.cabal` gains a manual flag, `sdl`, on by default. With
`-f -sdl` the `Sdl` frontend module and the `sdl2` and `sdl2-ttf`
dependencies are left out and `-DNO_SDL` is set; `Frontend.hs` then makes
the ANSI frontend the default one (in `chanFrontendIO` and
`frontendName`) instead of importing `Sdl` as `Chosen`. With the flag on,
nothing changes. It gives a binary that plays in any terminal of 80x45
and up and needs no SDL, fonts or display server, which is what we ship.

## The state folder

`appDataDir` (`Common/Misc.hs`) keeps `~/.Allure` when it exists, and
otherwise uses `getXdgDirectory XdgState "allure"` (the program name in
lower case), creating the folders above it first, since `tryCreateDir`
makes only the last one. That needs `directory >= 1.3.7`.
