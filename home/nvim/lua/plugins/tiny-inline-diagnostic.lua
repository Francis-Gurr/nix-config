vim.pack.add({ { src = "https://github.com/rachartier/tiny-inline-diagnostic.nvim" } })

require("tiny-inline-diagnostic").setup({
  preset = "simple",
  options = {
    show_source = { enabled = true, if_many = true },
    use_icons_from_diagnostic = true,
    show_all_diags_on_cursorline = true,
    multilines = {
      enabled = true,
      always_show = true,
      trim_whitespaces = false,
      tabstop = 4,
    },
  },
})

vim.diagnostic.config({ virtual_text = false })
