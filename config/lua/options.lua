-- - [ ] nice todos make config back on git merge other two and have env
-- vim.api.nvim_set_hl(0, 'Comment', { fg = '#444444' })
-- vim.api.nvim_set_hl(0, '@comment', { link = 'Comment' })

-- -- Disable bold for comments
-- vim.api.nvim_set_hl(0, 'Comment', { bold = false })
vim.g.have_nerd_font = true
vim.opt.winborder = "none"
vim.opt.virtualedit = "onemore"
vim.opt.conceallevel = 0
-- vim.opt.jumpoptions = "clean"
vim.opt.jumpoptions = "clean,stack,view"
vim.opt.fillchars = { fold = " " }
-- vim.opt.selection = "exclusive"

-- Suppress mark error messages
vim.opt.shortmess:append("c")

vim.api.nvim_create_autocmd("BufWinLeave", {
	pattern = { "*.*" },
	callback = function(args)
    local name = vim.api.nvim_buf_get_name(args.buf)
    if vim.bo[args.buf].buftype == "" and name ~= "" and not name:find("://", 1, true) then
      vim.api.nvim_buf_call(args.buf, function()
        vim.cmd("silent! mkview")
      end)
    end
  end,
})
vim.api.nvim_create_autocmd("BufWinEnter", {
	pattern = { "*.*" },
	command = "silent! loadview",
})
vim.opt.foldmethod = "indent"
-- lazyredraw can desync the visible grid from buffer state, breaking mouse click position
vim.opt.lazyredraw = false
vim.opt.foldenable = true
vim.opt.foldlevel = 99
vim.g.markdown_folding = 1 -- enable markdown folding
vim.opt.cmdheight = 0
-- long messages show for 1s then clear, instead of the "Press ENTER" prompt; :messages has the full text
-- DISABLED for nvim 0.11: vim.o.messagesopt = "wait:1000,history:500,progress:c"
vim.g.nvim_web_devicons_enabled = false
vim.o.autoread = true
vim.opt.number = true
vim.opt.numberwidth = 1
vim.opt.relativenumber = true
vim.opt.showmode = false
vim.opt.nu = true
-- todo
vim.opt.wrap = true

--  Remove this option if you want your OS clipboard toaaaa remain independent.
-- vim.opt.clipboard = "unnamedplus"
vim.opt.breakindent = true
vim.opt.undofile = true
vim.opt.ignorecase = true --HERETODO
-- marks persistent
-- Neovim shada settings
vim.opt.shada = [[!,'500,<500,s200,h,:100]]
-- Explanation:
-- !       -> save and restore command history
-- '500     -> save marks for last 500 files (local + global marks)
-- <500     -> save up to 500 lines of registers
-- s200     -> save up to 200 search patterns
-- h       -> include local marks
-- :0      -> include jumplist (0 = unlimited)

-- Store marks relative to full file path
vim.opt.shadafile = vim.fn.stdpath("data") .. "/shada/main.shada"
vim.opt.smartcase = true
-- vim.opt.colorcolumn = "180"
vim.opt.updatetime = 400
vim.opt.timeoutlen = 400
-- vim.opt.splitright = true
-- vim.opt.splitbelow = true
-- vim.opt.listchars = { tab = '  ', trail = '·', nbsp = ' ' }
vim.opt.expandtab = true -- Use spaces instead of tabs
vim.opt.shiftwidth = 2 -- Number of spaces per indentation level
vim.opt.tabstop = 2 -- Number of spaces a tab represents
vim.opt.softtabstop = 2 -- Makes backspace behave correctly
vim.opt.autoindent = true -- Copy indent from current line when starting a new line
vim.opt.smartindent = true -- Smart auto-indenting for C-like files
vim.opt.swapfile = false
vim.opt.incsearch = true
vim.opt.signcolumn = "no"
-- vim.opt.grepprg = "rg --vimgrep"
-- vim.opt.grepformat = "%f:%l:%c:%m"
vim.opt.grepprg = "rg --vimgrep --smart-case --fixed-strings"
vim.opt.grepformat = "%f:%l:%c:%m"
-- vim.opt.formatoptions = "qnlj"

vim.opt.formatoptions:remove({ "o", "r" })

-- vim.opt.inccommand = 'split'
vim.opt.cursorline = false
-- normal / cmdline = green nCursor, insert = pink Cursor, visual = pink Visual (style.lua)
vim.opt.guicursor = "n-c:block-nCursor,i:block-Cursor,v:block-Visual"
vim.opt.termguicolors = false
--vim.opt.scrolloff = 11
-- vim.opt.scrolloff = 999
-- vim.opt.scrolloff = 1
vim.opt.hlsearch = true
vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking (copying) text",
	group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
	callback = function()
		vim.highlight.on_yank()
	end,
})
vim.opt.shell = vim.fn.exepath("nu") ~= "" and vim.fn.exepath("nu") or vim.o.shell
-- vim.opt.shellcmdflag = "-c"
if vim.fn.exepath("nu") ~= "" then vim.o.shellcmdflag = "--login -c" end
-- vim.opt.shellquote = '"'
-- vim.opt.shellxquote = ''
vim.g.VM_silent_exit = 1
vim.g.VM_verbose = 0
vim.g.VM_show_warnings = 0
vim.g.loaded_node_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider = 0
