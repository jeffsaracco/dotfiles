-- tmux (~/.tmux.conf), prefix ctrl+b
rex.bind("ctrl+b>h", "pane.focus", { direction = "left" })
rex.bind("ctrl+b>j", "pane.focus", { direction = "down" })
rex.bind("ctrl+b>k", "pane.focus", { direction = "up" })
rex.bind("ctrl+b>l", "pane.focus", { direction = "right" })

rex.bind("ctrl+b>-", "pane.split", { direction = "down" })
rex.bind("ctrl+b>shift+5", "pane.split", { direction = "right" })
rex.bind("ctrl+b>shift+\\", "pane.split", { direction = "right" })

-- bind | split-window -h -c "#{pane_current_path}"
-- bind - split-window -v -c "#{pane_current_path}"

rex.bind("ctrl+b>[", "pane.copy_mode.enter")

-- ctrl+b starts sequences, so press it twice to send it to the program.
rex.bind("ctrl+b>ctrl+b", "pane.send_key", { key = "ctrl+b" })

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
