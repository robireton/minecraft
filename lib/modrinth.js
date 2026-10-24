import { setTimeout as sleep } from 'node:timers/promises'

const API = 'https://api.modrinth.com/v2'
const USER_AGENT = 'robireton/minecraft (github.com/robireton/minecraft)'

async function request (url, options = {}) {
  for (let attempt = 1; ; attempt++) {
    const response = await fetch(url, { ...options, headers: { 'User-Agent': USER_AGENT, ...options.headers } })
    if (response.ok) return response
    if (response.status === 429 && attempt < 3) {
      await sleep((Number(response.headers.get('x-ratelimit-reset')) || 60) * 1000)
      continue
    }
    throw new Error(`${options.method ?? 'GET'} ${url} failed: ${response.status} ${response.statusText}`)
  }
}

// Map of sha512 hash → Modrinth version, for the hashes Modrinth recognizes.
export async function versionsByHash (hashes) {
  if (hashes.length === 0) return {}
  const response = await request(`${API}/version_files`, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({ hashes, algorithm: 'sha512' })
  })
  return response.json()
}

export async function projectVersions (projectId, { loaders, gameVersions }) {
  const query = new URLSearchParams({
    loaders: JSON.stringify(loaders),
    game_versions: JSON.stringify(gameVersions),
    include_changelog: 'false'
  })
  const response = await request(`${API}/project/${projectId}/version?${query}`)
  return response.json()
}

export async function download (url) {
  const response = await request(url)
  return Buffer.from(await response.arrayBuffer())
}
