vim.pack.add({ { src = "https://github.com/mfussenegger/nvim-lint" } })

local lint = require("lint")
lint.linters_by_ft = {
  markdown = { "markdownlint" },
  javascript = { "eslint_d" },
  typescript = { "eslint_d" },
  vue = { "eslint_d" },
  json = { "eslint_d" },
  python = { "ruff" },
  lua = { "luacheck" },
  bash = { "shellcheck" },
}

local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })
vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
  group = lint_augroup,
  callback = function()
    lint.try_lint()
  end,
})
