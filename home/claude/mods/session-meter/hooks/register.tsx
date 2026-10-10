import { atom, read, update } from 'claude-code'
import type { EngineInterface, Register } from 'claude-code'

import type { Limit, Meter } from '../types'

const meter = atom({ plugin: 'session-meter', key: 'meter' } as const, null)
const isHidden = atom({ plugin: 'session-meter', key: 'isHidden' } as const, false)

const LIMIT_LABELS: Record<string, string> = {
  five_hour: '5h',
  seven_day: '7d',
  spend_limit: 'spend',
}

export function formatReset(resetsAt: string | undefined, now: number): string {
  if (!resetsAt) return ''
  const minutes = Math.max(0, Math.round((Date.parse(resetsAt) - now) / 60_000))
  if (Number.isNaN(minutes)) return ''
  if (minutes < 60) return ` ↻${minutes}m`
  const hours = Math.floor(minutes / 60)
  if (hours < 24) return ` ↻${hours}h${minutes % 60 ? `${minutes % 60}m` : ''}`
  return ` ↻${Math.round(hours / 24)}d`
}

export function formatTokens(n: number): string {
  return n >= 1_000_000 ? `${n / 1_000_000}M` : `${Math.round(n / 1000)}k`
}

// Powerline glyphs: they need a patched font (Nerd Font or Powerline), as
// the tmux and vim status lines do.
const ARROW = '\ue0b0'
const BRANCH = '\ue0a0'

type Segment = { key: string; text: string; bg: string; fg: string; bold?: boolean }

const MODEL = { bg: '#d97757', fg: '#1c1c1c' }
const BRANCH_SEG = { bg: '#3a3a3a', fg: '#d0d0d0' }
const COST = { bg: '#303030', fg: '#bcbcbc' }

export function levelColors(percent: number, calm: { bg: string; fg: string }) {
  if (percent >= 90) return { bg: '#d70000', fg: '#ffffff' }
  if (percent >= 75) return { bg: '#d7af00', fg: '#1c1c1c' }
  return calm
}

async function refresh($: EngineInterface): Promise<void> {
  const [usage, model, cwd] = await Promise.all([
    $.session.usage(),
    $.session.model(),
    $.session.cwd(),
  ])
  let branch: string | undefined
  try {
    const git = await $.process.run(['git', 'branch', '--show-current'], { cwd })
    branch = git.exitCode === 0 ? git.stdout.trim() || undefined : undefined
  } catch {
    // Not a repo, or no git: leave the branch off.
  }
  const next: Meter = {
    limits: usage.rateLimits.map(({ kind, percentUsed, resetsAt }): Limit => ({
      kind,
      percentUsed,
      resetsAt,
    })),
    contextPercent: usage.context.percent,
    contextWindow: usage.context.window,
    usd: usage.cost?.usd,
    model: model.replace(/^claude-/, ''),
    branch,
  }
  await update($, meter, () => next)
}

export const register: Register = on => {
  on('session.start', async ($, e, next) => {
    await $.command.register({
      name: 'meter',
      description: 'Show or hide the usage line above the prompt',
    })
    await refresh($)

    return next(e)
  })

  on('command.run', { command: 'meter' }, async $ => {
    const hidden = await update($, isHidden, was => !was)

    return { text: hidden ? 'Usage line hidden.' : 'Usage line shown.' }
  })

  on('session.measure', async ($, e, next) => {
    await refresh($)

    return next(e)
  })

  on('turn.complete', async ($, e, next) => {
    await refresh($)

    return next(e)
  })

  on('ui.render', { component: 'AbovePrompt' }, async ($, e, next) => {
    const m = await read($, meter)
    if (e.props.hasSurvey || m === null || (await read($, isHidden))) {
      return next(e)
    }

    const { Box, Text } = $.ui.resolve(e)
    const now = await $.clock.now()
    const segments: Segment[] = [
      { key: 'model', text: m.model, ...MODEL, bold: true },
      ...(m.branch ? [{ key: 'branch', text: `${BRANCH} ${m.branch}`, ...BRANCH_SEG }] : []),
      ...m.limits.map(limit => ({
        key: limit.kind,
        text: `${LIMIT_LABELS[limit.kind] ?? limit.kind} ${limit.percentUsed}%${formatReset(limit.resetsAt, now)}`,
        ...levelColors(limit.percentUsed, { bg: '#87af5f', fg: '#1c1c1c' }),
      })),
      {
        key: 'ctx',
        text: `ctx ${m.contextPercent ?? 0}% of ${formatTokens(m.contextWindow)}`,
        ...levelColors(m.contextPercent ?? 0, { bg: '#005f87', fg: '#ffffff' }),
      },
      ...(m.usd !== undefined ? [{ key: 'cost', text: `$${m.usd.toFixed(2)}`, ...COST }] : []),
    ]

    return (
      <Box>
        {segments.flatMap((seg, i) => [
          <Text key={seg.key} backgroundColor={seg.bg} color={seg.fg} bold={seg.bold}>
            {` ${seg.text} `}
          </Text>,
          <Text key={`${seg.key}-arrow`} color={seg.bg} backgroundColor={segments[i + 1]?.bg}>
            {ARROW}
          </Text>,
        ])}
      </Box>
    )
  })
}
