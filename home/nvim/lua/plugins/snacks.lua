vim.pack.add({ { src = "https://github.com/folke/snacks.nvim" } })

require("snacks").setup({
  bigfile = { enabled = true },
  bufdelete = { enabled = true },
  debug = { enabled = true },
  dim = { enabled = true },
  explorer = { enabled = true },
  git = { enabled = true },
  gitbrowse = { enabled = true },
  image = { enabled = true },
  input = { enabled = true },
  keymap = { enabled = true },
  lazygit = { enabled = true },
  notifier = { timeout = 5000 },
  picker = { enabled = true },
  profiler = { enabled = true },
  quickfile = { enabled = true },
  rename = { enabled = true },
  scope = { enabled = true },
  scratch = { enabled = true },
  scroll = { enabled = true },
  statuscolumn = { enabled = true },
  terminal = { enabled = true },
  toggle = { enabled = true },
  words = { enabled = true },
  zen = { enabled = true },
})

-- General keys (split-by-category keymaps live in plugins/snacks/*.lua)
vim.keymap.set("n", "<leader>N", function()
  Snacks.win({
    file = vim.api.nvim_get_runtime_file("doc/news.txt", false)[1],
    width = 0.6,
    height = 0.6,
  })
end, { desc = "Neovim News" })

vim.keymap.set("n", "<leader>n", function()
  Snacks.notifier.show_history()
end, { desc = "Notification History" })

vim.keymap.set("n", "<leader>un", function()
  Snacks.notifier.hide()
end, { desc = "Dismiss All Notifications" })

-- Terminal
vim.keymap.set("n", "<c-/>", function()
  Snacks.terminal()
end, { desc = "Toggle Terminal" })
vim.keymap.set("n", "<c-_>", function()
  Snacks.terminal()
end, { desc = "which_key_ignore" })

-- Debug globals: pretty-print via Snacks's inspector instead of stdout
_G.dd = function(...)
  Snacks.debug.inspect(...)
end
_G.bt = function()
  Snacks.debug.backtrace()
end
vim.print = _G.dd
