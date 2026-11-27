-- tmux (~/.tmux.conf), prefix ctrl+b
rex.bind("ctrl+b>h", "pane.focus", { direction = "left" })
rex.bind("ctrl+b>j", "pane.focus", { direction = "down" })
rex.bind("ctrl+b>k", "pane.focus", { direction = "up" })
rex.bind("ctrl+b>l", "pane.focus", { direction = "right" })
rex.bind("ctrl+b>v", "pane.split", { direction = "right" })
rex.bind("ctrl+b>-", "pane.split", { direction = "down" })
rex.bind("ctrl+b>[", "pane.copy_mode.enter")

-- ctrl+b starts sequences, so press it twice to send it to the program.
rex.bind("ctrl+b>ctrl+b", "pane.send_key", { key = "ctrl+b" })

-- >>> raptor >>>
dofile("/opt/homebrew/opt/raptor/share/raptor/init.lua").setup{}
rex.bind("shift+cmd+o", "raptor")
rex.bind("shift+cmd+c", "raptor_pr_open")
rex.bind("shift+cmd+n", "raptor_worktree_new")
rex.bind("cmd+opt+n", "raptor_worktree_agent")
rex.bind("ctrl+cmd+1", "raptor_pin_1")
rex.bind("ctrl+cmd+2", "raptor_pin_2")
rex.bind("ctrl+cmd+3", "raptor_pin_3")
rex.bind("ctrl+cmd+4", "raptor_pin_4")
rex.bind("ctrl+cmd+5", "raptor_pin_5")
rex.bind("ctrl+cmd+6", "raptor_pin_6")
rex.bind("ctrl+cmd+7", "raptor_pin_7")
rex.bind("ctrl+cmd+8", "raptor_pin_8")
rex.bind("ctrl+cmd+9", "raptor_pin_9")
-- <<< raptor <<<

-- >>> rex-agent-restore >>>
local ok_rar, rar = pcall(require, "rex_agent_restore")
if ok_rar and type(rar) == "table" then rar.setup({ bin = "/opt/homebrew/bin/rex-agent-restore" }) end
-- <<< rex-agent-restore <<<


local amber = dofile(os.getenv("HOME") .. "/.local/share/rex/amber/amber.lua")

amber.setup({
  plugins = {
    { "rawnly/smart-splits-backend-rex", main = "smart-splits-rex", opts = { resize_amount = 3 } },
  },
})
