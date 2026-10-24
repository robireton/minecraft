import { readdir, readFile } from 'node:fs/promises'
import { homedir } from 'node:os'
import path from 'node:path'

const LAUNCHER_PROFILES = path.join(homedir(), 'Library', 'Application Support', 'minecraft', 'launcher_profiles.json')
const SKIPPED = new Set(['Archive'])

// Content folders in a game directory, with the Modrinth loaders to look for
// updates under. Shader packs have no single loader, so they keep the installed
// version's loaders.
const KINDS = [
  { folder: 'mods', extension: '.jar', loaders: ['fabric'] },
  { folder: 'resourcepacks', extension: '.zip', loaders: ['minecraft'] },
  { folder: 'shaderpacks', extension: '.zip' }
]

export async function listEntries (dir) {
  try {
    return await readdir(dir, { withFileTypes: true })
  } catch (error) {
    if (error.code === 'ENOENT') return []
    throw error
  }
}

async function readProfiles () {
  try {
    return Object.values(JSON.parse(await readFile(LAUNCHER_PROFILES, 'utf8')).profiles)
  } catch (error) {
    if (error.code === 'ENOENT') return []
    throw error
  }
}

// 'fabric-loader-0.19.5-26.3' → '26.3'
function gameVersionOf (versionId) {
  return /^fabric-loader-[^-]+-(.+)$/.exec(versionId ?? '')?.[1]
}

// Each game directory under `root`, with its game version taken from the most
// recently used launcher profile that points at it, or else the folder name.
export async function findInstances (root) {
  const profiles = await readProfiles()
  const instances = []
  for (const entry of await listEntries(root)) {
    if (!entry.isDirectory() || entry.name.startsWith('.') || SKIPPED.has(entry.name)) continue
    const dir = path.join(root, entry.name)
    const [profile] = profiles
      .filter(p => p.gameDir && path.resolve(p.gameDir) === dir)
      .sort((a, b) => (b.lastUsed ?? '').localeCompare(a.lastUsed ?? ''))
    instances.push({ name: entry.name, dir, gameVersion: gameVersionOf(profile?.lastVersionId) ?? entry.name })
  }
  return instances
}

async function listFiles (dir, extension) {
  return (await listEntries(dir))
    .filter(e => e.isFile() && !e.name.startsWith('.') && e.name.toLowerCase().endsWith(extension))
    .map(e => path.join(dir, e.name))
}

// Every mod, resource pack, shader pack and world data pack in an instance.
export async function findContent (instance) {
  const content = []
  for (const { folder, extension, loaders } of KINDS) {
    for (const file of await listFiles(path.join(instance.dir, folder), extension)) content.push({ file, loaders })
  }
  const saves = path.join(instance.dir, 'saves')
  for (const world of await listEntries(saves)) {
    if (!world.isDirectory()) continue
    for (const file of await listFiles(path.join(saves, world.name, 'datapacks'), '.zip')) content.push({ file, loaders: ['datapack'] })
  }
  return content
}
