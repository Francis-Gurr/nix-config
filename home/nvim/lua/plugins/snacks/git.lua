-- Extends snacks (installed in plugins/snacks.lua) with git-related keymaps.
local function pick(name, opts)
  return function()
    Snacks.picker[name](opts)
  end
end

local function snack(method, opts)
  return function()
    Snacks[method](opts)
  end
end

local map = vim.keymap.set

-- Git Pickers
map("n", "<leader>gb", pick("git_branches"), { desc = "Git Branches" })
map("n", "<leader>gl", pick("git_log"), { desc = "Git Log" })
map("n", "<leader>gs", pick("git_status"), { desc = "Git Status" })
map("n", "<leader>gd", pick("git_diff"), { desc = "Git Diff (Hunks)" })
map("n", "<leader>gf", pick("git_log_file"), { desc = "Git Log File" })

-- LazyGit / GitBrowse
map("n", "<leader>gg", snack("lazygit"), { desc = "Lazygit" })
map({ "n", "v" }, "<leader>gB", snack("gitbrowse"), { desc = "Git Browse" })
