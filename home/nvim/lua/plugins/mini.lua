vim.pack.add({ { src = "https://github.com/nvim-mini/mini.nvim" } })

-- Better Around/Inside textobjects: va) yinq ci' etc.
require("mini.ai").setup({ n_lines = 500 })

-- Add/delete/replace surroundings: saiw) sd' sr)' etc.
require("mini.surround").setup()

-- Auto-pair brackets/quotes (replaces nvim-autopairs).
require("mini.pairs").setup()

-- Comment toggling with `gc` / `gcc` (replaces Comment.nvim).
require("mini.comment").setup()

-- Current-scope indent guide (replaces snacks.indent). Static (no animation),
-- using a full vertical line glyph to match the snacks default look.
local indentscope = require("mini.indentscope")
indentscope.setup({
  draw = { animation = indentscope.gen_animation.none() },
  symbol = "│",
  options = { try_as_border = true },
})

require("mini.sessions").setup()

-- Startup dashboard (replaces snacks.dashboard) with the snacks NEOVIM ASCII
-- header and a compact action menu.
local starter = require("mini.starter")
starter.setup({
  evaluate_single = true,
  header = table.concat({
    "███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗",
    "████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║",
    "██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║",
    "██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║",
    "██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║",
    "╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝",
  }, "\n"),
  footer = "",
  items = {
    { name = " f  Find File", action = "lua Snacks.picker.files()", section = "" },
    { name = " n  New File", action = "enew | startinsert", section = "" },
    { name = " g  Find Text", action = "lua Snacks.picker.grep()", section = "" },
    { name = " r  Recent Files", action = "lua Snacks.picker.recent()", section = "" },
    {
      name = " c  Config",
      action = "lua Snacks.picker.files({ cwd = vim.fn.stdpath('config') })",
      section = "",
    },
    { name = "󰦛 s  Restore Session", action = "lua MiniSessions.select()", section = "" },
    { name = " q  Quit", action = "qa", section = "" },
  },
  content_hooks = {
    starter.gen_hook.adding_bullet(""),
    starter.gen_hook.aligning("center", "center"),
  },
})

local statusline = require("mini.statusline")
statusline.setup({ use_icons = vim.g.have_nerd_font })
---@diagnostic disable-next-line: duplicate-set-field
statusline.section_location = function()
  return "%2l:%-2v"
end
