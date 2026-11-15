# Changes from upstream

This is the Asciiverse packaging of [Allure of the Stars](https://allureofthestars.com)
by Mikolaj Konarski (AGPL-3.0-or-later), built from upstream's `master` at
`59caa940` (17 November 2023; Allure 0.11.0.0 and 29 commits after it,
mostly CI and build fixes). Upstream is the `upstream` remote
(https://github.com/AllureOfTheStars/Allure); the `asciiverse` branch
carries the changes below. `UPSTREAM.md` is the same list written for
Mikolaj.

The engine, [LambdaHack](https://github.com/LambdaHack/LambdaHack) 0.11.0.1
by the same author (BSD-3-Clause), is in `LambdaHack/` as a git subtree of
its `v0.11.0.1` tag (the `lambdahack` remote), the release Allure 0.11
builds on from Hackage, so the two changes to it below can be built.

The game, its content, keys and screen are upstream's, unchanged. It is
drawn by LambdaHack's own ANSI terminal frontend, which upstream ships in
the same binary as the SDL2 one (`--frontendANSI`), and needs a terminal of
at least 80x45: the game's screen is 80 by 45, and the frontend says so and
stops in a smaller one.

## Ours

- **A build without SDL2** (`LambdaHack/LambdaHack.cabal`,
  `LambdaHack/engine-src/Game/LambdaHack/Client/UI/Frontend.hs`). A new
  cabal flag, `sdl` (on by default, so upstream builds as before): with
  `-f -sdl` the SDL2 frontend and the `sdl2` and `sdl2-ttf` packages are
  left out, and the ANSI frontend is the one used when no other is asked
  for. `cabal.project.asciiverse` builds Allure that way.
- **The player's files in the state folder**
  (`LambdaHack/engine-src/Game/LambdaHack/Common/Misc.hs`, `appDataDir`).
  Saves, settings, scores and the history went to `~/.Allure`. A new
  player's now go to `$XDG_STATE_HOME/allure`, else `~/.local/state/allure`
  (`%LOCALAPPDATA%\allure` on Windows); an existing `~/.Allure` is still
  used. The `directory` lower bound rises to 1.3.7, the first with
  `XdgState`.

## Packaging

- `cabal.project.asciiverse`: Allure and `./LambdaHack`, LambdaHack with
  `-f -sdl`.
- `asciiverse/build.sh`: the release build. One static binary, glibc, gmp,
  zlib and the rest linked in, so players install nothing.
- `.github/workflows/asciiverse-release.yml`: builds Linux x86-64 and
  ARM64 on Ubuntu 22.04 with GHC 9.8.2, smoke-tests each binary, and
  attaches archives and SHA256SUMS to the release.
- `asciiverse/smoke.py`: the smoke test (80x45, empty HOME, scratch
  `XDG_STATE_HOME`).
- `asciiverse/allure.toml`, `.md`, `.cast`: the catalog manifest, store
  page and preview, drafts for `hub/catalog`.

## Not changed

- The screen stays 80x45, the size Allure is made for; it is not reflowed
  for 80x24 or 100x30.
- No session log of our own: LambdaHack already has its debug and log
  options (`--dbgMsgCli`, `--dbgMsgSer`, `--logPriority`), and adding one
  would mean touching the engine's client loop.
