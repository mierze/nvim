local languages = require("parser_languages")
local ts = require("nvim-treesitter")
ts.install(languages):wait(600000)
if vim.env.PORTABLE_NVIM_UPDATE == "1" then
  ts.update(languages):wait(600000)
end
for _, lang in ipairs(languages) do
  assert(vim.treesitter.language.add(lang), "Missing parser: " .. lang)
end
