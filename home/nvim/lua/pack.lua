-- Plugin loader for vim.pack. Each lua/plugins/*.lua file is self-contained:
-- it calls `vim.pack.add` for its own packages and configures them inline.
-- Files are loaded in deterministic order (files before subdirectories, then
-- alphabetical), so a top-level `foo.lua` always loads before anything in `foo/`.

local function load_dir(dir, mod_prefix)
  local entries = {}
  for name, kind in vim.fs.dir(dir) do
    table.insert(entries, { name = name, kind = kind })
  end
  table.sort(entries, function(a, b)
    if a.kind ~= b.kind then
      return a.kind == "file"
    end
    return a.name < b.name
  end)

  for _, e in ipairs(entries) do
    local path = dir .. "/" .. e.name
    if e.kind == "directory" then
      load_dir(path, mod_prefix .. "." .. e.name)
    elseif e.name:match("%.lua$") then
      local modname = mod_prefix .. "." .. e.name:gsub("%.lua$", "")
      local ok, err = pcall(require, modname)
      if not ok then
        vim.notify(("[pack] failed to load %s: %s"):format(modname, err), vim.log.levels.ERROR)
      end
    end
  end
end

load_dir(vim.fn.stdpath("config") .. "/lua/plugins", "plugins")
