import type { EngineInterface, Register } from 'claude-code'

// Window options the tmux config reads:
//   @claude          working | waiting | done | idle
//   @claude_meter    "ctx 42% · 5h 13%"
//   @claude_renamed  1 when this mod named the window
type State = 'working' | 'waiting' | 'done' | 'idle'

// Commands that never exit on their own: servers, watchers, followers. Each
// must start the command's last segment, so a mention inside a heredoc,
// string or earlier step never matches.
const LONG_RUNNING: RegExp[] = [
  /^(npm|pnpm|yarn|bun)\s+(run\s+)?(dev|start|serve|watch)\b/,
  /^(npx\s+)?(next|nuxt|astro|remix)\s+dev\b/,
  /^(npx\s+)?vite(\s+(dev|serve))?$/,
  /^cargo\s+watch\b/,
  /^\S+(\s+\S+)*\s--watch\b/,
  /^tail\s+-[a-zA-Z]*[fF]/,
  /^docker(-|\s+)compose\s+up\b(?!.*\s(-d|--detach)\b)/,
  /^python3?\s+-m\s+http\.server\b/,
  /^(uvicorn|gunicorn|flask\s+run|rails\s+s(erver)?|hugo\s+server|jekyll\s+serve)\b/,
]

export function longRunningName(command: string): string | undefined {
  if (command.includes('\n')) return undefined
  const last = (command.split(/&&|\|\||;/).pop() ?? '').trim().replace(/^(\w+=\S*\s+)*/, '')
  if (/^tmux\b/.test(last)) return undefined
  for (const re of LONG_RUNNING) {
    const m = last.match(re)
    if (m) return m[0].trim().slice(0, 24)
  }
  return undefined
}

export function shellQuote(s: string): string {
  return `'${s.replaceAll("'", `'\\''`)}'`
}

// The Bash command that starts `command` in a new window after Claude's own
// (`window`, a window id like @4: new-window refuses a pane id) and tells the
// model where it went.
export function inWindow(command: string, name: string, window: string): string {
  return [
    `p=$(tmux new-window -d -a -t ${window} -P -F '#{pane_id}' -n ${shellQuote(name)} -c "$PWD")`,
    `tmux send-keys -t "$p" -l -- ${shellQuote(command)}`,
    `tmux send-keys -t "$p" Enter`,
    `echo "Started in tmux window ${name.replaceAll('"', '')} (pane $p) so it keeps running. ` +
      `Read its output with mcp__tmux__capture, target $p. Stop it with: tmux send-keys -t $p C-c"`,
  ].join(' && ')
}

let last: State | undefined

async function tmux($: EngineInterface, ...args: string[]) {
  try {
    return await $.process.run(['tmux', ...args], { timeoutMs: 5000 })
  } catch {
    return undefined
  }
}

async function setState($: EngineInterface, state: State) {
  const pane = await $.env.get('TMUX_PANE')
  if (!pane || state === last) return
  last = state
  await tmux($, 'set', '-w', '-t', pane, '@claude', state)
}

async function refreshMeter($: EngineInterface) {
  const pane = await $.env.get('TMUX_PANE')
  if (!pane) return
  const usage = await $.session.usage()
  const parts = [`ctx ${usage.context.percent ?? 0}%`]
  const fiveHour = usage.rateLimits.find(l => l.kind === 'five_hour')
  if (fiveHour) parts.push(`5h ${fiveHour.percentUsed}%`)
  await tmux($, 'set', '-w', '-t', pane, '@claude_meter', parts.join(' · '))
}

export const register: Register = on => {
  on('session.start', async ($, e, next) => {
    const started = await next(e)
    const pane = await $.env.get('TMUX_PANE')
    if (!pane) return started

    await $.tool.register({
      name: 'capture',
      description:
        'Read another tmux pane: a dev server, test watcher, REPL or log the user has open. ' +
        'With no target, lists every pane (id, location, window name, running command, cwd). ' +
        'With a target (a pane id like %3, or session:window.pane), returns its last `lines` lines.',
      inputSchema: {
        type: 'object',
        properties: {
          target: { type: 'string', description: 'tmux pane target; omit to list panes' },
          lines: { type: 'number', description: 'Scrollback lines to return (default 200)' },
        },
      },
      isDeferred: false,
    })

    // Name the window after the project, unless the user named it already.
    const auto = await tmux($, 'display', '-p', '-t', pane, '#{automatic-rename}')
    if (auto?.stdout.trim() === '1') {
      const root = (await $.session.repo())?.root ?? (await $.session.cwd())
      const name = root.split('/').filter(Boolean).pop() ?? 'claude'
      await tmux($, 'rename-window', '-t', pane, name)
      await tmux($, 'set', '-w', '-t', pane, '@claude_renamed', '1')
    }

    last = undefined
    await setState($, 'idle')
    await refreshMeter($)
    return started
  })

  on('session.end', async ($, e, next) => {
    const pane = await $.env.get('TMUX_PANE')
    if (pane && e.reason !== 'clear') {
      const renamed = await tmux($, 'display', '-p', '-t', pane, '#{@claude_renamed}')
      if (renamed?.stdout.trim() === '1') {
        await tmux($, 'set', '-w', '-t', pane, 'automatic-rename', 'on')
      }
      for (const opt of ['@claude', '@claude_meter', '@claude_renamed']) {
        await tmux($, 'set', '-w', '-u', '-t', pane, opt)
      }
    }
    return next(e)
  })

  on('turn.start', async ($, e, next) => {
    await setState($, 'working')
    return next(e)
  })

  on('turn.complete', async ($, e, next) => {
    if (!e.agentId) {
      await setState($, 'done')
      await refreshMeter($)
    }
    return next(e)
  })

  on('session.measure', async ($, e, next) => {
    await refreshMeter($)
    return next(e)
  })

  on('classic.Notification', async ($, e, next) => {
    if (e.notification_type === 'permission_prompt' || e.notification_type === 'elicitation_dialog') {
      await setState($, 'waiting')
    }
    return next(e)
  }).catch(($, e, next) => next(e))

  // A permission prompt or question has been answered once a tool runs.
  on('tool.call', async ($, e, next) => {
    if (last !== 'waiting' && e.tool !== 'AskUserQuestion') return next(e)
    if (e.tool === 'AskUserQuestion') await setState($, 'waiting')
    const ran = await next(e)
    await setState($, 'working')
    return ran
  }).catch(($, e, next) => next(e))

  on('tool.call', { tool: 'mcp__tmux__capture' }, async ($, e) => {
    const { target, lines } = e as unknown as { target?: string; lines?: number }
    if (!target) {
      const self = await $.env.get('TMUX_PANE')
      const listed = await tmux(
        $, 'list-panes', '-a', '-F',
        '#{pane_id}\t#{session_name}:#{window_index}.#{pane_index}\t#{window_name}\t#{pane_current_command}\t#{pane_current_path}',
      )
      if (!listed || listed.exitCode !== 0) return { deny: `tmux list-panes failed: ${listed?.stderr ?? 'tmux not reachable'}` }
      const rows = listed.stdout.trim().split('\n').map(r => (r.startsWith(`${self}\t`) ? `${r}\t(this Claude session)` : r))
      return { result: `pane\tlocation\twindow\tcommand\tcwd\n${rows.join('\n')}` }
    }
    const n = Math.max(1, Math.min(Math.floor(lines ?? 200), 5000))
    const cap = await tmux($, 'capture-pane', '-p', '-J', '-t', target, '-S', `-${n}`)
    if (!cap || cap.exitCode !== 0) return { deny: `tmux capture-pane failed: ${cap?.stderr.trim() ?? 'tmux not reachable'}` }
    const text = cap.stdout.replace(/\s+$/, '').split('\n').slice(-n).join('\n')
    return { result: text || '(pane is empty)' }
  }).catch(($, e, next) =>
    next.called ? next(e) : { deny: `${$.plugin.name}: capture failed.` },
  )

  on('tool.call', { tool: 'Bash' }, async ($, e, next) => {
    const pane = await $.env.get('TMUX_PANE')
    const name = pane && !e.run_in_background ? longRunningName(e.command) : undefined
    if (!pane || !name) return next(e)
    const window = (await tmux($, 'display', '-p', '-t', pane, '#{window_id}'))?.stdout.trim()
    if (!window?.startsWith('@')) return next(e)
    return next({ ...e, command: inWindow(e.command, name, window) })
  }).catch(($, e, next) => next(e))
}
