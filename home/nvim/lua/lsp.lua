vim.pack.add({
  { src = "https://github.com/neovim/nvim-lspconfig" },
  { src = "https://github.com/mason-org/mason.nvim" },
  { src = "https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim" },
})

require("mason").setup()

require("mason-tool-installer").setup({
  ensure_installed = {
    -- Typescript, Javascript & Vue
    "vue-language-server",
    "vtsls",
    "eslint_d", -- linter
    "eslint-lsp",
    "prettierd", -- formatter

    -- python
    "ruff", --lsp, linter & formatter

    -- lua
    "lua-language-server",
    "luacheck", -- linter
    "stylua", -- formatter

    -- markdown
    "marksman",
    "markdownlint",

    -- some spell checker
    -- json
    -- beancount

    -- yaml
    "yaml-language-server",

    -- bash
    "bash-language-server",
    "shellcheck",
  },
})

vim.lsp.enable({
  "bashls",
  "eslint",
  "lua_ls",
  "marksman",
  "ruff",
  "vtsls",
  "vue_ls",
  "yamlls",
})

vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),
  callback = function(event)
    local map = function(keys, func, desc, mode)
      mode = mode or "n"
      vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
    end

    map("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction", { "n", "x" })
    map("<leader>cs", function()
      vim.lsp.buf.code_action({ context = { only = { "source" } } })
    end, "[C]ode [S]ource action", { "n", "x" })

    local client = vim.lsp.get_client_by_id(event.data.client_id)

    -- LSP-driven auto-completion
    if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_completion) then
      vim.lsp.completion.enable(true, client.id, event.buf, { autotrigger = true })
    end

    -- Highlight references under cursor on CursorHold
    if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
      local highlight_augroup = vim.api.nvim_create_augroup("lsp-highlight", { clear = false })
      vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
        buffer = event.buf,
        group = highlight_augroup,
        callback = vim.lsp.buf.document_highlight,
      })

      vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
        buffer = event.buf,
        group = highlight_augroup,
        callback = vim.lsp.buf.clear_references,
      })

      vim.api.nvim_create_autocmd("LspDetach", {
        group = vim.api.nvim_create_augroup("lsp-detach", { clear = true }),
        callback = function(event2)
          vim.lsp.buf.clear_references()
          vim.api.nvim_clear_autocmds({ group = "lsp-highlight", buffer = event2.buf })
        end,
      })
    end
  end,
})

-- Configure diagnostics
vim.diagnostic.config({
  severity_sort = true,
  float = { border = "rounded", source = "if_many" },
  underline = { severity = vim.diagnostic.severity.ERROR },
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = "󰅚 ",
      [vim.diagnostic.severity.WARN] = "󰀪 ",
      [vim.diagnostic.severity.INFO] = "󰋽 ",
      [vim.diagnostic.severity.HINT] = "󰌶 ",
    },
  },
  -- virtual_text = {
  -- 	source = "if_many",
  -- 	spacing = 2,
  -- 	format = function(diagnostic)
  -- 		local diagnostic_message = {
  -- 			[vim.diagnostic.severity.ERROR] = diagnostic.message,
  -- 			[vim.diagnostic.severity.WARN] = diagnostic.message,
  -- 			[vim.diagnostic.severity.INFO] = diagnostic.message,
  -- 			[vim.diagnostic.severity.HINT] = diagnostic.message,
  -- 		}
  -- 		return diagnostic_message[diagnostic.severity]
  -- 	end,
  -- },
})
