vim.pack.add({
  -- Pinned to `master` because the `main` branch has an incompatible new API
  -- that requires migrating the configs setup call.
  { src = "https://github.com/nvim-treesitter/nvim-treesitter", version = "master" },
})

-- :TSUpdate equivalent — run parser updates after install/update.
vim.api.nvim_create_autocmd("PackChanged", {
  callback = function(event)
    if event.data.spec.name == "nvim-treesitter" and event.data.kind ~= "delete" then
      vim.cmd("TSUpdate")
    end
  end,
})

require("nvim-treesitter.configs").setup({
  ensure_installed = {
    "bash",
    "beancount",
    "c",
    "css",
    "diff",
    "go",
    "html",
    "javascript",
    "json",
    "lua",
    "luadoc",
    "markdown",
    "markdown_inline",
    "python",
    "query",
    "regex",
    "scss",
    "typescript",
    "vim",
    "vimdoc",
    "yaml",
  },
  auto_install = true,
  highlight = {
    enable = true,
    -- Some languages depend on vim's regex highlighting for indent rules.
    additional_vim_regex_highlighting = { "ruby" },
  },
  indent = { enable = true, disable = { "ruby" } },
})

vim.opt.foldenable = true
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
vim.opt.foldlevel = 99
