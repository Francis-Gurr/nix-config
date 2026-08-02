vim.pack.add({ { src = "https://github.com/stevearc/conform.nvim" } })

require("conform").setup({
  notify_on_error = false,
  format_on_save = function(bufnr)
    -- Languages without a well-standardized coding style: skip lsp fallback.
    local disable_filetypes = { c = true, cpp = true }
    local lsp_format_opt = disable_filetypes[vim.bo[bufnr].filetype] and "never" or "fallback"
    return {
      timeout_ms = 500,
      lsp_format = lsp_format_opt,
    }
  end,
  formatters_by_ft = {
    lua = { "stylua" },
    python = { "ruff" },
    javascript = { "eslint_d" },
    typescript = { "eslint_d" },
    vue = { "eslint_d" },
    json = { "eslint_d" },
    markdown = { "markdownlint", "prettierd" },
    bash = { "shellcheck" },
  },
})

vim.keymap.set("", "<leader>lf", function()
  require("conform").format({ async = true, lsp_format = "fallback" })
end, { desc = "[F]ormat buffer" })
