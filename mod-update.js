import { execFile } from 'node:child_process'
import { createHash } from 'node:crypto'
import { access, mkdir, readFile, rename, rm, stat, writeFile } from 'node:fs/promises'
import { homedir } from 'node:os'
import path from 'node:path'
import { promisify } from 'node:util'
import { findContent, findInstances, listEntries } from './lib/instances.js'
import { download, projectVersions, versionsByHash } from './lib/modrinth.js'
import { pickUpdate } from './lib/select.js'

const ROOT = process.env.MINECRAFT_ROOT ?? path.join(homedir(), 'Minecraft')
const BACKUPS = '.mod-updates'
const BACKUP_DAYS = 30
const dryRun = process.argv.includes('--dry-run')
const stamp = new Date().toISOString().slice(0, 19).replaceAll(':', '-')
const versionCache = new Map()

function sha512 (data) {
  return createHash('sha512').update(data).digest('hex')
}

async function exists (file) {
  return access(file).then(() => true, () => false)
}

// Game directories of running Minecraft clients, from their --gameDir argument.
async function runningGameDirs () {
  const { stdout } = await promisify(execFile)('ps', ['-Aww', '-o', 'command='])
  return new Set(stdout.split('\n').flatMap(line => {
    const match = /--gameDir (.+?)(?= --|$)/.exec(line)
    return match ? [path.resolve(match[1])] : []
  }))
}

async function candidatesFor (projectId, loaders, gameVersion) {
  const key = JSON.stringify([projectId, loaders, gameVersion])
  if (!versionCache.has(key)) versionCache.set(key, await projectVersions(projectId, { loaders, gameVersions: [gameVersion] }))
  return versionCache.get(key)
}

function primaryFile (version) {
  return version.files.find(f => f.primary) ?? version.files[0]
}

// Download `file`, verify it, move the replaced file into this run's backup
// folder, then put the new file where the old one was.
async function install (instance, item, file) {
  const folder = path.dirname(item.file)
  const destination = path.join(folder, path.basename(file.filename))
  if (destination !== item.file && await exists(destination)) throw new Error(`${file.filename} already exists`)
  const data = await download(file.url)
  if (sha512(data) !== file.hashes.sha512) throw new Error(`${file.filename} failed its sha512 check`)
  const partial = path.join(folder, `.${path.basename(file.filename)}.download`)
  try {
    await writeFile(partial, data)
    const backup = path.join(instance.dir, BACKUPS, stamp, path.relative(instance.dir, item.file))
    await mkdir(path.dirname(backup), { recursive: true })
    await rename(item.file, backup)
    await rename(partial, destination)
  } finally {
    await rm(partial, { force: true })
  }
}

async function pruneBackups (instance) {
  const dir = path.join(instance.dir, BACKUPS)
  const cutoff = Date.now() - BACKUP_DAYS * 24 * 60 * 60 * 1000
  for (const entry of await listEntries(dir)) {
    const backup = path.join(dir, entry.name)
    if ((await stat(backup)).mtimeMs < cutoff) await rm(backup, { recursive: true, force: true })
  }
}

async function updateInstance (instance) {
  const content = await findContent(instance)
  for (const item of content) item.hash = sha512(await readFile(item.file))
  const installed = await versionsByHash(content.map(item => item.hash))
  const known = content.filter(item => installed[item.hash])
  const summary = { checked: content.length, unknown: content.length - known.length, updated: 0, errors: 0 }

  const byProject = Map.groupBy(known, item => `${path.dirname(item.file)}\0${installed[item.hash].project_id}`)
  for (const items of byProject.values()) {
    const [item] = items
    const name = path.relative(ROOT, item.file)
    if (items.length > 1) {
      console.warn(`${name}: skipped, same project as ${items.slice(1).map(i => path.basename(i.file)).join(', ')}`)
      summary.errors++
      continue
    }
    try {
      const current = installed[item.hash]
      const candidates = await candidatesFor(current.project_id, item.loaders ?? current.loaders, instance.gameVersion)
      const update = pickUpdate(current, candidates)
      if (!update) continue
      const file = primaryFile(update)
      console.log(`${name} → ${file.filename} (${update.version_type})`)
      if (!dryRun) await install(instance, item, file)
      summary.updated++
    } catch (error) {
      console.error(`${name}: ${error.message}`)
      summary.errors++
    }
  }
  return summary
}

console.log(`${new Date().toISOString()} updating ${ROOT}${dryRun ? ' (dry run)' : ''}`)
const running = await runningGameDirs()
for (const instance of await findInstances(ROOT)) {
  if (running.has(instance.dir)) {
    console.log(`${instance.name}: skipped, Minecraft is running`)
    continue
  }
  try {
    const { checked, unknown, updated, errors } = await updateInstance(instance)
    console.log(`${instance.name} (${instance.gameVersion}): ${checked} checked, ${unknown} not on Modrinth, ${updated} ${dryRun ? 'to update' : 'updated'}, ${errors} problems`)
    if (errors) process.exitCode = 1
    if (!dryRun) await pruneBackups(instance)
  } catch (error) {
    console.error(`${instance.name}: ${error.message}`)
    process.exitCode = 1
  }
}
