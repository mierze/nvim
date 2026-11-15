local root = assert(vim.env.PORTABLE_NVIM_ROOT, "Launch with the portable Neovim runner")
local settings = dofile(vim.fs.joinpath(root, "local.example.lua"))
local private = vim.fs.joinpath(root, "local.lua")
if vim.uv.fs_stat(private) then
  for key, value in pairs(dofile(private)) do
    settings[key] = value
  end
end
for _, key in ipairs({ "workspace", "projects", "notes", "protos", "vault", "vault_parent", "config_dir" }) do
  settings[key] = vim.fs.normalize(vim.fn.expand(settings[key]))
end
settings.worktree_containers = settings.worktree_containers or { settings.workspace }
local paths = vim.tbl_map(vim.fn.expand, settings.tool_dirs)
table.insert(paths, 1, vim.fs.joinpath(root, ".local", "tools", "bin"))
vim.env.PATH = table.concat(paths, vim.fn.has("win32") == 1 and ";" or ":")
  .. (vim.fn.has("win32") == 1 and ";" or ":") .. vim.env.PATH
return settings
