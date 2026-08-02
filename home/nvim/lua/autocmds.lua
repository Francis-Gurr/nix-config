vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "Highlight when yanking (copying) text",
  group = vim.api.nvim_create_augroup("highlight-yank", { clear = true }),
  callback = function()
    vim.hl.on_yank()
  end,
})

-- Enable builtin autocomplete only in regular file buffers (skip snacks picker
-- prompts, terminal, mini.starter, help, etc., where popup suggestions are noise).
vim.api.nvim_create_autocmd("BufEnter", {
  desc = "Enable autocomplete in file buffers only",
  group = vim.api.nvim_create_augroup("autocomplete-buftype", { clear = true }),
  callback = function(args)
    if vim.bo[args.buf].buftype == "" then
      vim.bo[args.buf].autocomplete = true
    end
  end,
})
