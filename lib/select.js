const STABILITY = { release: 0, beta: 1, alpha: 2 }

// Pick the version to replace `installed` with, from versions already filtered to
// the right loader and game version. Prefers the newest release published after
// `installed`; betas and alphas are considered only when `installed` is at least
// that unstable. Returns undefined when there is nothing newer.
export function pickUpdate (installed, candidates) {
  const published = Date.parse(installed.date_published)
  const tolerance = STABILITY[installed.version_type] ?? STABILITY.release
  const newer = candidates
    .filter(v => v.id !== installed.id && Date.parse(v.date_published) > published)
    .sort((a, b) => Date.parse(b.date_published) - Date.parse(a.date_published))
  for (const [type, stability] of Object.entries(STABILITY)) {
    if (stability > tolerance) break
    const found = newer.find(v => v.version_type === type)
    if (found) return found
  }
}
