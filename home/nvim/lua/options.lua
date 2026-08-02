vim.opt.number = true
vim.opt.relativenumber = true

vim.opt.mouse = "a"

-- Don't show the mode, since it's already in the status line
vim.opt.showmode = false

-- Schedule clipboard sync after `UiEnter` because it can increase startup-time
vim.schedule(function()
  vim.opt.clipboard = "unnamedplus"
end)

vim.opt.breakindent = true
vim.opt.undofile = true

-- Case-insensitive search UNLESS \C or one or more capital letters in the term
vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.opt.signcolumn = "yes"
vim.opt.updatetime = 250

-- Faster mapped-sequence wait so the which-key popup appears sooner
vim.opt.timeoutlen = 300

vim.opt.splitright = true
vim.opt.splitbelow = true

vim.opt.list = true
vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }

-- Suppress nvim's intro screen so the snacks dashboard isn't preceded by a flash
vim.opt.shortmess:append("I")

vim.opt.inccommand = "split"
vim.opt.cursorline = true
vim.opt.scrolloff = 20

-- Indentation: 4-space tabs, expanded to spaces
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4
vim.opt.expandtab = true

vim.opt.spell = true
vim.opt.spelllang = "en_us"

-- Completion menu: fuzzy matching, popup style
vim.opt.completeopt = "fuzzy"
-- LSP-only completion (no buffer-word / tag sources)
vim.opt.complete = ""
