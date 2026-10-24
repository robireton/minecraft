import assert from 'node:assert/strict'
import { test } from 'node:test'
import { pickUpdate } from '../lib/select.js'

const version = (id, type, day) => ({ id, version_type: type, date_published: `2026-10-${String(day).padStart(2, '0')}T00:00:00Z` })

test('release installed: ignores newer betas and alphas', () => {
  const installed = version('a', 'release', 1)
  assert.equal(pickUpdate(installed, [version('b', 'beta', 5), version('c', 'alpha', 6), installed]), undefined)
  assert.equal(pickUpdate(installed, [version('b', 'beta', 5), version('d', 'release', 3)])?.id, 'd')
})

test('alpha installed: prefers a newer release over newer betas and alphas', () => {
  const installed = version('a', 'alpha', 1)
  const candidates = [version('b', 'alpha', 9), version('c', 'beta', 8), version('d', 'release', 4), version('e', 'release', 6)]
  assert.equal(pickUpdate(installed, candidates)?.id, 'e')
})

test('beta installed: takes newest beta when no release, never alpha', () => {
  const installed = version('a', 'beta', 1)
  assert.equal(pickUpdate(installed, [version('b', 'beta', 3), version('c', 'beta', 5), version('d', 'alpha', 7)])?.id, 'c')
  assert.equal(pickUpdate(installed, [version('d', 'alpha', 7)]), undefined)
})

test('never downgrades', () => {
  const installed = version('a', 'release', 10)
  assert.equal(pickUpdate(installed, [version('b', 'release', 2)]), undefined)
})
