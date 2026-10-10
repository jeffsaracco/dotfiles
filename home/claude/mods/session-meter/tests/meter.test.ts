import type { RenderPropsOf } from 'claude-code'
import { expect, mock, test } from 'claude-code/testing'

import { formatReset, formatTokens } from '../hooks/register'

const PROPS = { hasSurvey: false, isWorking: false, maxRows: 10 } as unknown as RenderPropsOf['AbovePrompt']

test('formats reset times and token counts', async () => {
  const now = Date.parse('2026-10-10T12:00:00Z')
  expect(formatReset('2026-10-10T12:45:00Z', now)).toBe(' ↻45m')
  expect(formatReset('2026-10-10T15:30:00Z', now)).toBe(' ↻3h30m')
  expect(formatReset('2026-10-13T12:00:00Z', now)).toBe(' ↻3d')
  expect(formatReset(undefined, now)).toBe('')
  expect(formatTokens(1_000_000)).toBe('1M')
  expect(formatTokens(200_000)).toBe('200k')
})

test('draws usage, context, cost, model and branch above the prompt', async ($, on) => {
  const usage = {
    startedAt: 0,
    context: { tokens: 450_000, window: 1_000_000, percent: 45 },
    rateLimits: [
      { kind: 'five_hour', percentUsed: 12 },
      { kind: 'seven_day', percentUsed: 91 },
    ],
    cost: { usd: 1.234 },
  }
  mock.clock(on)
  on('session.usage', () => ({ value: usage }))
  on('session.model', () => ({ value: 'claude-opus-5-5' }))
  on('session.cwd', () => ({ value: '/repo' }))
  on('process.run', () => ({ value: { exitCode: 0, stdout: 'main\n', stderr: '' } }) as never)
  on('session.measure', ($, e) => ({ changed: e.changed }))

  await $.session.measure({ ...usage, changed: ['context', 'rateLimits', 'cost'] })

  for (const surface of ['terminal', 'desktop'] as const) {
    const ui = await $.ui.mount({ plugin: 'session-meter', surface, component: 'AbovePrompt', props: PROPS })
    for (const text of ['5h 12%', '7d 91%', 'ctx 45% of 1M', '$1.23', 'opus-5-5', '\ue0a0 main']) {
      expect(await ui.find({ type: 'Text', text })).toBeDefined()
    }
    await ui.unmount()
  }
})
