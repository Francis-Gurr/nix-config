vim.pack.add({ { src = "https://github.com/iamcco/markdown-preview.nvim" } })

vim.g.mkdp_filetypes = { "markdown" }

-- `cd app && yarn install` build hook — runs once on install and on each
-- update (PackChanged fires for "install" and "update" kinds).
vim.api.nvim_create_autocmd("PackChanged", {
  callback = function(event)
    local data = event.data
    if data.spec.name ~= "markdown-preview.nvim" or data.kind == "delete" then
      return
    end
    vim.system({ "yarn", "install" }, { cwd = data.path .. "/app" }, function(out)
      if out.code ~= 0 then
        vim.schedule(function()
          vim.notify("markdown-preview build failed: " .. (out.stderr or ""), vim.log.levels.ERROR)
        end)
      end
    end)
  end,
})
