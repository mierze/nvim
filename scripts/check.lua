local root = vim.fs.normalize(vim.env.PORTABLE_NVIM_ROOT)
assert(vim.fs.normalize(vim.fn.stdpath("config")) == root .. "/config")
local aerial = vim.api.nvim_get_runtime_file("lua/aerial/init.lua", false)[1]
assert(aerial and vim.fs.normalize(aerial):find(root .. "/.local/", 1, true) == 1, "Aerial must load from this checkout")
assert(vim.fn.exists(":AerialToggle") == 2, "Aerial failed to load")
for _, name in ipairs({ "oil", "harpoon", "mini.pick", "cmp", "conform" }) do
  assert(require(name))
end
for _, tool in ipairs({
  "rg", "zoxide", "tree-sitter", "clangd", "lua-language-server", "pyright-langserver",
  "typescript-language-server", "vscode-css-language-server", "rust-analyzer", "zls",
  "clang-format", "stylua", "prettier", "black", "rustfmt",
}) do
  if vim.fn.executable(tool) == 0 then
    print("Optional tool missing: " .. tool)
  end
end
print("Portable profile OK: " .. vim.v.progpath)
