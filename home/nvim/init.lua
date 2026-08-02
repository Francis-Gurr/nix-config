-- Set leader key (before loading plugins)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.g.have_nerd_font = true

-- Load options (settings)
require("options")

-- Load key mappings
require("keymaps")

-- Load autocommands
require("autocmds")

-- Load plugins via vim.pack
require("pack")

-- LSP config
require("lsp")
