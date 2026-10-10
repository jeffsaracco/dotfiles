import type { On } from 'claude-code'
import { expect, mock, test } from 'claude-code/testing'

import { inWindow, longRunningName, shellQuote } from '../hooks/register'

test('spots commands that never exit', async () => {
  expect(longRunningName('npm run dev')).toBe('npm run dev')
  expect(longRunningName('cd web && pnpm dev')).toBe('pnpm dev')
  expect(longRunningName('PORT=4000 npm start')).toBe('npm start')
  expect(longRunningName('docker compose up')).toBe('docker compose up')
  expect(longRunningName('tail -f log/dev.log')).toBe('tail -f')
  expect(longRunningName('jest --watch')).toBe('jest --watch')
  expect(longRunningName('npm run build')).toBe(undefined)
  expect(longRunningName('docker compose up -d')).toBe(undefined)
  expect(longRunningName('tmux new-window npm run dev')).toBe(undefined)
})

test('ignores mentions that are not the command being run', async () => {
  expect(longRunningName(`python3 - <<'EOF'\ns='npm run dev'\nEOF`)).toBe(undefined)
  expect(longRunningName(`grep -n "npm run dev" README.md`)).toBe(undefined)
  expect(longRunningName('npm run dev; echo done')).toBe(undefined)
  expect(longRunningName(`echo 'tail -f x'`)).toBe(undefined)
})

test('quotes for the shell', async () => {
  expect(shellQuote(`echo 'hi'`)).toBe(`'echo '\\''hi'\\'''`)
  expect(inWindow('npm run dev', 'npm run dev', '@4')).toContain(`tmux new-window -d -a -t @4`)
})

function fakeTmux(on: On, calls: string[][]) {
  on('process.run', ($, e) => {
    calls.push([...e.argv])
    const out =
      e.argv[1] === 'capture-pane' ? 'line 1\nline 2\n\n\n' : e.argv[1] === 'display' ? '@4\n' : ''
    return { value: { exitCode: 0, stdout: out, stderr: '', isStdoutTruncated: false, isStderrTruncated: false } }
  })
}

test('moves a dev server into its own window', async ($, on) => {
  mock.env(on, { TMUX_PANE: '%3' })
  fakeTmux(on, [])
  on('tool.call', { tool: 'Bash' }, ($, e) => ({ result: { stdout: e.command, stderr: '', interrupted: false } }))

  const moved = await $.tool.call({ tool: 'Bash', command: 'npm run dev', description: 'dev server' })
  expect(JSON.stringify(moved.result)).toContain('tmux new-window -d -a -t @4')

  const plain = await $.tool.call({ tool: 'Bash', command: 'npm test', description: 'tests' })
  expect(JSON.stringify(plain.result)).toContain('"stdout":"npm test"')
})

test('leaves Bash alone outside tmux', async ($, on) => {
  mock.env(on, {})
  on('tool.call', { tool: 'Bash' }, ($, e) => ({ result: { stdout: e.command, stderr: '', interrupted: false } }))

  const ran = await $.tool.call({ tool: 'Bash', command: 'npm run dev', description: 'dev server' })
  expect(JSON.stringify(ran.result)).toContain('"stdout":"npm run dev"')
})

test('captures a pane', async ($, on) => {
  mock.env(on, { TMUX_PANE: '%3' })
  const calls: string[][] = []
  fakeTmux(on, calls)

  const got = await $.tool.call({ tool: 'mcp__tmux__capture', target: '%5', lines: 50 } as never)
  expect(got.result).toBe('line 1\nline 2')
  expect(calls.at(-1)).toEqual(['tmux', 'capture-pane', '-p', '-J', '-t', '%5', '-S', '-50'])
})
