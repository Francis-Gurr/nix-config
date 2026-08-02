-- Extends snacks (installed in plugins/snacks.lua) with picker keymaps.
local function pick(name, opts)
  return function()
    Snacks.picker[name](opts)
  end
end

local map = vim.keymap.set

-- ═══════════════════════════════════════════════════════════
-- CORE NAVIGATION (top-level, most frequently used)
-- ═══════════════════════════════════════════════════════════
map("n", "<leader><space>", pick("smart"), { desc = "Smart Find Files" })
map("n", "<leader>,", pick("buffers"), { desc = "Buffers" })
map("n", "<leader>/", pick("grep"), { desc = "Grep" })
map("n", "<leader>:", pick("command_history"), { desc = "Command History" })
map("n", "<leader>e", pick("explorer"), { desc = "File Explorer" })

-- ═══════════════════════════════════════════════════════════
-- FILE FINDING (<leader>f)
-- ═══════════════════════════════════════════════════════════
map("n", "<leader>ff", pick("files"), { desc = "Find Files" })
map("n", "<leader>fr", pick("recent"), { desc = "Recent Files" })
map("n", "<leader>fb", pick("buffers"), { desc = "Buffers" })
map("n", "<leader>fp", pick("projects"), { desc = "Projects" })
map("n", "<leader>fg", pick("git_files"), { desc = "Git Files" })
map("n", "<leader>fc", pick("files", { cwd = vim.fn.stdpath("config") }), { desc = "Config Files" })

-- ═══════════════════════════════════════════════════════════
-- SEARCH/GREP (<leader>s)
-- ═══════════════════════════════════════════════════════════
map("n", "<leader>sg", pick("grep"), { desc = "Grep" })
map({ "n", "x" }, "<leader>sw", pick("grep_word"), { desc = "Grep Word" })
map("n", "<leader>sb", pick("lines"), { desc = "Buffer Lines" })
map("n", "<leader>sB", pick("grep_buffers"), { desc = "Grep Buffers" })
map("n", "<leader>s/", pick("search_history"), { desc = "Search History" })
map("n", "<leader>sR", pick("resume"), { desc = "Resume Last Picker" })

-- ═══════════════════════════════════════════════════════════
-- VIM/NEOVIM INTROSPECTION (<leader>s)
-- ═══════════════════════════════════════════════════════════
map("n", "<leader>sc", pick("command_history"), { desc = "Command History" })
map("n", "<leader>sC", pick("commands"), { desc = "Commands" })
map("n", "<leader>sk", pick("keymaps"), { desc = "Keymaps" })
map("n", "<leader>sa", pick("autocmds"), { desc = "Autocmds" })
map("n", "<leader>sh", pick("help"), { desc = "Help Pages" })
map("n", "<leader>sM", pick("man"), { desc = "Man Pages" })
map("n", "<leader>sH", pick("highlights"), { desc = "Highlights" })
map("n", "<leader>si", pick("icons"), { desc = "Icons" })
map("n", "<leader>sn", pick("notifications"), { desc = "Notifications" })
map("n", "<leader>sz", pick("spelling"), { desc = "Spelling Suggestions" })
map("n", "<leader>uC", pick("colorschemes"), { desc = "Colorschemes" })

-- ═══════════════════════════════════════════════════════════
-- REGISTERS & MARKS (<leader>s)
-- ═══════════════════════════════════════════════════════════
map("n", '<leader>s"', pick("registers"), { desc = "Registers" })
map("n", "<leader>sm", pick("marks"), { desc = "Marks" })
map("n", "<leader>sj", pick("jumps"), { desc = "Jump List" })
map("n", "<leader>su", pick("undo"), { desc = "Undo History" })
map("n", "<leader>sy", pick("cliphist"), { desc = "Clipboard History" })

-- ═══════════════════════════════════════════════════════════
-- DIAGNOSTICS & ERRORS
-- ═══════════════════════════════════════════════════════════
map("n", "<leader>sd", pick("diagnostics"), { desc = "Diagnostics (Workspace)" })
map("n", "<leader>sD", pick("diagnostics_buffer"), { desc = "Diagnostics (Buffer)" })
map("n", "<leader>sq", pick("qflist"), { desc = "Quickfix List" })
map("n", "<leader>sl", pick("loclist"), { desc = "Location List" })

-- ═══════════════════════════════════════════════════════════
-- LSP (<leader>l or goto keys)
-- ═══════════════════════════════════════════════════════════
map("n", "gd", pick("lsp_definitions"), { desc = "LSP: Definitions" })
map("n", "gD", pick("lsp_declarations"), { desc = "LSP: Declarations" })
map("n", "gr", pick("lsp_references"), { desc = "LSP: References" })
map("n", "gI", pick("lsp_implementations"), { desc = "LSP: Implementations" })
map("n", "gy", pick("lsp_type_definitions"), { desc = "LSP: Type Definitions" })
map("n", "<leader>ls", pick("lsp_symbols"), { desc = "LSP: Document Symbols" })
map("n", "<leader>lS", pick("lsp_workspace_symbols"), { desc = "LSP: Workspace Symbols" })
map("n", "<leader>lc", pick("lsp_config"), { desc = "LSP: Servers" })
map("n", "<leader>li", pick("lsp_incoming_calls"), { desc = "LSP: Incoming Calls" })
map("n", "<leader>lo", pick("lsp_outgoing_calls"), { desc = "LSP: Outgoing Calls" })

-- ═══════════════════════════════════════════════════════════
-- GITHUB (<leader>gh)
-- ═══════════════════════════════════════════════════════════
map("n", "<leader>ghi", pick("gh_issue"), { desc = "GitHub: Issues (Open)" })
map("n", "<leader>ghI", pick("gh_issue", { state = "all" }), { desc = "GitHub: Issues (All)" })
map("n", "<leader>ghp", pick("gh_pr"), { desc = "GitHub: PRs (Open)" })
map("n", "<leader>ghP", pick("gh_pr", { state = "all" }), { desc = "GitHub: PRs (All)" })
map("n", "<leader>ghd", pick("gh_diff"), { desc = "GitHub: PR Diff" })
map("n", "<leader>ghl", pick("gh_labels"), { desc = "GitHub: Labels" })
map("n", "<leader>ghr", pick("gh_reactions"), { desc = "GitHub: Reactions" })
map("n", "<leader>gha", pick("gh_actions"), { desc = "GitHub: Actions" })

-- ═══════════════════════════════════════════════════════════
-- TREESITTER & TAGS
-- ═══════════════════════════════════════════════════════════
map("n", "<leader>st", pick("treesitter"), { desc = "Treesitter Symbols" })
map("n", "<leader>sT", pick("tags"), { desc = "Tags" })

-- ═══════════════════════════════════════════════════════════
-- PLUGINS & META
-- ═══════════════════════════════════════════════════════════
map("n", "<leader>sP", pick("pickers"), { desc = "Pickers" })
map("n", "<leader>nx", pick("scratch"), { desc = "Scratch Buffers" })

-- ═══════════════════════════════════════════════════════════
-- TODO COMMENTS
-- ═══════════════════════════════════════════════════════════
map("n", "<leader>xT", pick("todo_comments"), { desc = "Todo Comments" })
map("n", "<leader>xt", pick("todo_comments", { keywords = { "TODO", "FIX", "FIXME" } }), { desc = "Todo/Fix/Fixme" })
