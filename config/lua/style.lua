---------------------------
------S-T-Y-L-E------------
---------------------------

-- Set colorscheme
-- vim.cmd.colorscheme("paragon")
-- vim.cmd.colorscheme("catppuccin")

vim.opt.termguicolors = true

-- prevent terminal background from bleeding into nvim
vim.api.nvim_set_hl(0, "Normal", { bg = "NONE" })
vim.api.nvim_set_hl(0, "NormalFloat", { bg = "NONE" })
vim.api.nvim_set_hl(0, "NormalNC", { bg = "NONE" })

-- Custom overrides go here (will override colors.lua)
-- Use reverse to force cursor colors to override syntax highlighting
vim.cmd([[
  highlight Visual guifg=#000000 guibg=#b4a7f5 gui=bold
  highlight Cursor guifg=#000000 guibg=#ff1493 gui=reverse
  highlight lCursor guifg=#000000 guibg=#ff1493 gui=reverse
  highlight TermCursor guifg=#000000 guibg=#ff1493 gui=reverse
  highlight CursorIM guifg=#000000 guibg=#ff1493 gui=reverse
  highlight nCursor guifg=#000000 guibg=#32cd32 gui=NONE
  highlight iCursor guifg=#000000 guibg=#ff1493 gui=reverse
  highlight vCursor guifg=#000000 guibg=#b4a7f5 gui=NONE
]])

-- Re-apply on mode changes to override any plugin interference
vim.api.nvim_create_autocmd({"ModeChanged", "ColorScheme"}, {
  pattern = "*",
  callback = function()
    vim.cmd([[
      highlight Visual guifg=#000000 guibg=#b4a7f5 gui=bold
      highlight Cursor guifg=#000000 guibg=#ff1493 gui=reverse
      highlight lCursor guifg=#000000 guibg=#ff1493 gui=reverse
      highlight TermCursor guifg=#000000 guibg=#ff1493 gui=reverse
      highlight CursorIM guifg=#000000 guibg=#ff1493 gui=reverse
      highlight nCursor guifg=#000000 guibg=#32cd32 gui=NONE
      highlight iCursor guifg=#000000 guibg=#ff1493 gui=reverse
      highlight vCursor guifg=#000000 guibg=#b4a7f5 gui=NONE
    ]])
  end,
})

-- Example overrides (commented out):
-- vim.api.nvim_set_hl(0, "Normal", { bg = "NONE" }) -- Transparent background
-- vim.api.nvim_set_hl(0, "Cursor", { fg = "#000000", bg = "#F0F0F0" })
