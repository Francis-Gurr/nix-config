vim.pack.add({ { src = "https://github.com/folke/sidekick.nvim" } })

require("sidekick").setup({
  cli = {
    mux = {
      backend = "tmux",
      enabled = true,
    },
    -- Only Claude Code is enabled. Other tools are omitted so they don't show
    -- up in :checkhealth warnings.
    tools = {
      claude = {},
    },
  },
  -- Next Edit Suggestions requires the Copilot LSP, which we don't use.
  nes = {
    enabled = false,
  },
})

local map = vim.keymap.set

map({ "n", "t", "i", "x" }, "<c-.>", function()
  require("sidekick.cli").toggle()
end, { desc = "Sidekick Toggle" })

map("n", "<leader>aa", function()
  require("sidekick.cli").toggle()
end, { desc = "Sidekick Toggle CLI" })

map("n", "<leader>as", function()
  require("sidekick.cli").select()
end, { desc = "Select CLI" })

map("n", "<leader>ad", function()
  require("sidekick.cli").close()
end, { desc = "Detach a CLI Session" })

map({ "x", "n" }, "<leader>at", function()
  require("sidekick.cli").send({ msg = "{this}" })
end, { desc = "Send This" })

map("n", "<leader>af", function()
  require("sidekick.cli").send({ msg = "{file}" })
end, { desc = "Send File" })

map("x", "<leader>av", function()
  require("sidekick.cli").send({ msg = "{selection}" })
end, { desc = "Send Visual Selection" })

map({ "n", "x" }, "<leader>ap", function()
  require("sidekick.cli").prompt()
end, { desc = "Sidekick Select Prompt" })

map("n", "<leader>ac", function()
  require("sidekick.cli").toggle({ name = "claude", focus = true })
end, { desc = "Sidekick Toggle Claude" })
