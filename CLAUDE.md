# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Mod updater (the active project)

`mod-update.js` keeps Fabric mods, resource packs, shader packs and world data packs in each game directory under `~/Minecraft` (override with `MINECRAFT_ROOT`) current from Modrinth. It runs daily via launchd (`pub.lastchance.mod-update.plist` → `mod-update.zsh`, logs in `~/Library/Logs/mod-update*.log`), following the same pattern as `~/Projects/Annie`.

- `npm run check`: dry run; `npm run update`: apply. `npm test` (node:test, `test/`), `npm run lint` (neostandard, which all JS must follow; ESM, no semicolons).
- Each top-level folder under `~/Minecraft` is a launcher game directory. `Archive` and dot-folders are skipped. The game version comes from the most recently used profile in `~/Library/Application Support/minecraft/launcher_profiles.json` whose `gameDir` matches (`fabric-loader-<loader>-<game>`), falling back to the folder name.
- Installed files are identified by sha512 via Modrinth's `POST /version_files`; anything Modrinth doesn't recognize is left alone. Candidates come from `GET /project/{id}/version` filtered by loader (`fabric` / `minecraft` / `datapack`, or the installed version's loaders for shader packs) and game version.
- Channel rule lives in `lib/select.js`: only versions published after the installed one; newest release wins; betas/alphas only if the installed version is at least as unstable.
- Replaced files go to `<instance>/.mod-updates/<timestamp>/<relative path>` and are pruned after 30 days. An instance is skipped while a Minecraft process has it as `--gameDir`. Two files in one folder that resolve to the same Modrinth project are reported and skipped, not resolved.

## Legacy content

Everything below predates the updater and can generally be ignored.

A personal collection of old Minecraft tooling, with no build system or tests. The parts are independent:

- **`servers/<name>/`**: config for several vanilla Minecraft server instances (`cathedral`, `ch` = Crickhowell, `lan`, `superflat`, `wp`/`wp2` = Western Paquet). Only the config JSON/properties files are tracked; `world/`, `logs/`, and `*.jar` are gitignored.
- **`start.sh <name>`**: launches `~/Minecraft/servers/<name>/minecraft_server.jar` (2–6 GB heap). It assumes the repo is checked out at `~/Minecraft`, not at its current path.
- **`overviewer/`**: [Minecraft Overviewer](https://overviewer.org) render configs (Python 2-era). `config.py` is the main multi-world config (Western Paquet, Crickhowell, lan). `crickhowell.py` and `western_paquet.py` are older single-world variants that duplicate most of the same marker filter functions. Paths point to `/home/rob/Minecraft/...` (a Linux host), and `assets/` holds marker icons served through `customwebassets`.
- **`scripts/`**: generators for structures. Each Perl script hard-codes an origin `($x0, $y0, $z0)` and defines local `fill`/`setblock` helpers that **print Minecraft commands to stdout** with coordinates relative to that origin. Usage: `perl scripts/tower.pl > out.txt`, then paste or run the commands in-game or through the server console. `city.jl` (Julia) works the same way. Scripts are standalone copies, with no shared module.
- **`village-info/`**: Node scripts that use `prismarine-nbt` to read single-player saves from `~/Library/Application Support/minecraft/saves/<level>/`. `index.js` dumps villages from `level.dat`, and `level.js` dumps a map `.dat`. The world is chosen by editing the `const level = ...` line. Run with `cd village-info && npm install && node index.js`.
- **`minecraft notes.txt`, `villagers.txt`**: in-game coordinate notes and `summon` command lists.

## Things to know

- Overviewer filters and server configs use legacy pre-1.13 entity IDs and data values (e.g. `Ozelot`, `EntityHorse`, `Profession`/`Career`, numeric block data in `fill`). If you target a modern Minecraft version, these need updating.
- If you change a marker filter in `overviewer/config.py`, check whether the same function in the per-world `.py` files needs the same change.
