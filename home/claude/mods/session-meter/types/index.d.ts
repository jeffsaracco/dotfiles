export type Limit = { kind: string; percentUsed: number; resetsAt?: string }

export type Meter = {
  limits: Limit[]
  contextPercent?: number
  contextWindow: number
  usd?: number
  model: string
  branch?: string
}

declare module 'claude-code' {
  interface PluginState {
    'session-meter': { meter: Meter | null; isHidden: boolean }
  }
}
