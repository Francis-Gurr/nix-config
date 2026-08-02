vim.pack.add({ { src = "https://github.com/folke/which-key.nvim" } })

local wk = require("which-key")
wk.setup({})
wk.add({
  { "<leader>c", group = "[C]ode", mode = { "n", "x" } },
  { "<leader>r", group = "[R]ename" },
  { "<leader>f", group = "[F]ind" },
  { "<leader>g", group = "[G]it" },
  { "<leader>l", group = "[L]SP" },
  { "<leader>p", group = "[P]ack" },
  { "<leader>s", group = "[S]earch" },
  { "<leader>w", group = "[W]orkspace" },
  { "<leader>t", group = "[T]oggle" },
  { "<leader>h", group = "Git [H]unk", mode = { "n", "v" } },
  { "<leader>q", desc = "Diagnostic [Q]uickfix" },
})
