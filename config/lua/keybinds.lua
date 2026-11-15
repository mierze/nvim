vim.g.project_root = vim.fn.getcwd()


vim.keymap.set("n", "ge", vim.diagnostic.open_float)
vim.keymap.set("n", "gp", vim.diagnostic.goto_prev)
vim.keymap.set("n", "gn", vim.diagnostic.goto_next)
vim.keymap.set("n", "gq", vim.diagnostic.setloclist)
vim.keymap.set({ "n", "v" }, "a", "i", { noremap = true, silent = true })
vim.keymap.set({ "n", "v" }, "A", "I", { noremap = true, silent = true })
vim.keymap.set({ "n", "v" }, "i", "a", { noremap = true, silent = true })
vim.keymap.set({ "n", "v" }, "I", "A", { noremap = true, silent = true })


vim.keymap.set("n", "<C-e>", ":e<CR>", { noremap = true, silent = true }) -- end of line
-- vim.keymap.set("n", "<C-e>", "2<C-e>")
-- vim.keymap.set("n", "<C-y>", "2<C-y>")

vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.keymap.set("i", "<C-f>", function()
  vim.fn.feedkeys(os.date("%H%M"))
end)
vim.keymap.set("c", "<C-f>", function()
  -- insert the current time into the command line
  local line = vim.fn.getcmdline()
  local pos = vim.fn.getcmdpos()
  local text = os.date("%H%M")
  -- insert at current cursor position
  local newline = line:sub(1, pos - 1) .. text .. line:sub(pos)
  vim.fn.setcmdline(newline)
  vim.fn.setcmdpos(pos + #text)
end, { noremap = true, silent = true })

-- TODOPANDA
vim.keymap.set("c", "<C-d>", function()
  -- insert current working directory into command line
  local line = vim.fn.getcmdline()
  local pos = vim.fn.getcmdpos()
  local text = vim.fn.getcwd()
  local newline = line:sub(1, pos - 1) .. text .. line:sub(pos)
  vim.fn.setcmdline(newline)
  vim.fn.setcmdpos(pos + #text)
end, { noremap = true, silent = true })

vim.keymap.set("i", "<C-d>", function()
  vim.fn.feedkeys(os.date("%y%m%d%H%M"))
end)


vim.keymap.set("i", "<C-A-d>", function()
  vim.fn.feedkeys(os.date("%m%d"))
end)

vim.keymap.set("i", "<C-S-D>", function()
  vim.fn.feedkeys(os.date("%Y%m%d%H%M"))
end)


-- Toggle between last two windows
vim.keymap.set({ "n", "v" }, "$", "$l")
vim.keymap.set({ 'n', 'i', 'v' }, '<D-A-w>', function()
  -- Exit insert mode if needed, then close window
  vim.cmd('stopinsert') -- ensures insert mode exits
  vim.cmd('close')      -- closes the window/pane
end, { noremap = true, silent = true, desc = "Close window/pane" })

vim.keymap.set({ "n", "i", "v" }, "<D-A-Backspace>", "<cmd>wincmd p<cr>", { noremap = true, silent = true })
-- vim.keymap.set({ "n", "i", "v" }, "<D-A-Space>", "<cmd>wincmd p<cr>", { noremap = true, silent = true })
-- vim.keymap.set({ "n", "i", "v" }, "<A-Tab>", "<cmd>wincmd p<cr>", { noremap = true, silent = true })
-- vim.keymap.set({ "n", "i", "v" }, "<D-A-Space>", "<cmdincmd p<cr>", { noremap = true, silent = true })
-- vim.keymap.set("n", "<C-z>", "<cmd>wincmd p<cr>", { noremap = true, silent = true })
-- Go to the next window
-- vim.keymap.set({ "i", "n", "v" }, "<C-Tab>", "<cmd>wincmd w<cr>", { noremap = true, silent = true })

local function show_marks(mark_filter, file_filter)
  -- boxed helpers
  local function is_md(filename)
    return filename:lower():sub(-3) == ".md"
  end

  local function not_md(filename)
    return filename ~= "[unknown]" and not is_md(filename)
  end

  local marks = vim.fn.getmarklist()
  local lines = { "mark  file                  text" }

  for _, mark in ipairs(marks) do
    local name = mark.mark:sub(2, 2)
    if mark_filter(name) then
      local bufnr = mark.bufnr
      local filename
      local fullpath

      if bufnr and vim.api.nvim_buf_is_valid(bufnr) then
        fullpath = vim.api.nvim_buf_get_name(bufnr)
        filename = vim.fn.fnamemodify(fullpath, ":t")
      elseif mark.file and #mark.file > 0 then
        fullpath = mark.file
        filename = vim.fn.fnamemodify(mark.file, ":t")
      else
        filename = "[unknown]"
        fullpath = ""
      end

      -- file filter (optional)
      if file_filter and not file_filter(filename) then
        goto continue
      end

      local lnum = mark.pos[2]
      local snippet = ""

      if bufnr and vim.api.nvim_buf_is_valid(bufnr) then
        local ok, text =
            pcall(vim.api.nvim_buf_get_lines, bufnr, lnum - 1, lnum, false)
        if ok and text and text[1] then
          snippet = text[1]:gsub("^%s+", ""):sub(1, 60)
        end
      elseif fullpath ~= "" and vim.fn.filereadable(fullpath) == 1 then
        local file = io.open(fullpath, "r")
        if file then
          local i = 1
          for line in file:lines() do
            if i == lnum then
              snippet = line:gsub("^%s+", ""):sub(1, 60)
              break
            end
            i = i + 1
          end
          file:close()
        end
      end

      table.insert(
        lines,
        string.format("%-2s  %-20s  %s", name, filename, snippet)
      )
    end
    ::continue::
  end

  if #lines == 1 then
    print("No matching marks set")
  else
    vim.api.nvim_echo({ { table.concat(lines, "\n"), "Normal" } }, false, {})
  end
end
vim.keymap.set({ "n", "v" }, "<D-C-A-m>", function()
  show_marks(
    function(name) return name:match("%u") end
  )
end, { silent = true, desc = "Show global marks A–Z" })

vim.keymap.set({ "n", "v" }, "<A-m>", function()
  show_marks(
    function(name) return name:match("%u") end,
    function(filename) return filename:lower():sub(-3) == ".md" end
  )
end, { silent = true, desc = "Show global marks in .md files" })

vim.keymap.set({ "n", "v" }, "<C-A-m>", function()
  show_marks(
    function(name) return name:match("%u") end,
    function(filename)
      return filename ~= "[unknown]"
          and filename:lower():sub(-3) ~= ".md"
    end
  )
end, { silent = true, desc = "Show global marks NOT in .md files" })

vim.keymap.set({ "n", "v" }, "<D-C-m>", function()
  show_marks(function(name)
    return name:match("[0123456789HUION]")
  end)
end, { silent = true, desc = "Show marks 0-9 and HUION" })

local function show_unused_global_marks()
  local marks = vim.fn.getmarklist()

  -- track which A–Z are taken
  local taken = {}
  for _, mark in ipairs(marks) do
    local name = mark.mark:sub(2, 2)
    if name:match("%u") then
      taken[name] = true
    end
  end

  local unused = {}
  for c = string.byte("A"), string.byte("Z") do
    local letter = string.char(c)
    if not taken[letter] then
      table.insert(unused, letter)
    end
  end

  if #unused == 0 then
    print("All global marks A–Z are taken")
  else
    vim.api.nvim_echo({
      { "Unused global marks:\n",   "Title" },
      { table.concat(unused, "\n"), "Normal" },
    }, false, {})
  end
end

vim.keymap.set({ "n", "v" }, "<D-C-A-S-m>", show_unused_global_marks, {
  silent = true,
  desc = "Show unused global marks A–Z",
})

-- vim.keymap.set({ "n", "v" }, "<C-m>", function()
--   show_marks(function(name)
--     return name:match("[HUION]")
--   end)
-- end, { silent = true, desc = "Show marks HUION" })


-- ball / only: z only, v columns, b rows, o grid
vim.keymap.set({ "n", "v", "i" }, "<D-A-z>", "<cmd>only<cr>", { noremap = true, silent = true })
vim.keymap.set({ "n", "v", "i" }, "<D-A-f>", "<cmd>only<cr>", { noremap = true, silent = true })
vim.keymap.set({ "n", "v", "i" }, "<D-A-v>", "<cmd>vert ball<cr>", { noremap = true, silent = true })
vim.keymap.set({ "n", "v", "i" }, "<D-A-b>", "<cmd>ball<cr>", { noremap = true, silent = true })
-- grid: listed buffers in ceil(sqrt(n)) columns, current buffer top left
vim.keymap.set({ "n", "v", "i" }, "<D-A-o>", function()
  local cur = vim.api.nvim_get_current_buf()
  local bufs = { cur }
  for _, b in ipairs(vim.api.nvim_list_bufs()) do
    if b ~= cur and vim.bo[b].buflisted then
      table.insert(bufs, b)
    end
  end
  local cols = math.ceil(math.sqrt(#bufs))
  local rows = math.ceil(#bufs / cols)
  vim.cmd("stopinsert")
  vim.cmd("silent! only")
  local first = vim.api.nvim_get_current_win()
  local col_wins = { first }
  for _ = 2, cols do
    vim.cmd("rightbelow vsplit")
    table.insert(col_wins, vim.api.nvim_get_current_win())
  end
  for c, w in ipairs(col_wins) do
    vim.api.nvim_set_current_win(w)
    for r = 1, rows do
      local b = bufs[(c - 1) * rows + r]
      if not b then
        break
      end
      if r > 1 then
        vim.cmd("rightbelow split")
      end
      vim.api.nvim_win_set_buf(0, b)
    end
  end
  vim.cmd("wincmd =")
  vim.api.nvim_set_current_win(first)
end, { noremap = true, silent = true, desc = "buffers in a grid" })

-- s e a t: go to window 1-4 (vim's numbering: column by column, top to bottom); with one window, listed buffer 1-4
for i, k in ipairs({ "s", "e", "a", "t" }) do
  vim.keymap.set({ "n", "v", "i" }, "<D-A-" .. k .. ">", function()
    if vim.fn.winnr("$") > 1 then
      local w = vim.fn.win_getid(i)
      if w ~= 0 then
        vim.api.nvim_set_current_win(w)
      end
      return
    end
    local b = vim.fn.getbufinfo({ buflisted = 1 })[i]
    if b then
      vim.api.nvim_set_current_buf(b.bufnr)
    end
  end, { noremap = true, silent = true, desc = "window / buffer " .. i })
end

local function win_move(dir)
  local ok, _ = pcall(vim.cmd, "wincmd " .. dir)
  if not ok then
    -- fallback to next window in tab (wrap)
    vim.cmd("wincmd w")
  end
end

vim.keymap.set({ "n", "v", "i" }, "<D-A-Space>", function() win_move("w") end, { noremap = true, silent = true })
vim.keymap.set({ "n", "v" }, "<Backspace><Tab>", function() win_move("w") end, { noremap = true, silent = true })
vim.keymap.set({ "n", "v", "i" }, "<D-A-S-Space>", function() win_move("W") end, { noremap = true, silent = true })

vim.keymap.set({ "n", "v", "i" }, "<D-A-h>", function() win_move("h") end, { noremap = true, silent = true })
vim.keymap.set({ "n", "v", "i" }, "<D-A-j>", function() win_move("j") end, { noremap = true, silent = true })
vim.keymap.set({ "n", "v", "i" }, "<D-A-k>", function() win_move("k") end, { noremap = true, silent = true })
vim.keymap.set({ "n", "v", "i" }, "<D-A-l>", function() win_move("l") end, { noremap = true, silent = true })
-- Resize splits directly
-- Normal mode vertical split with Cmd+Alt+h
vim.keymap.set({ "v", "i", "n" }, "<D-A-S-h>", ":vsplit<CR>", { noremap = true, silent = true })
vim.keymap.set({ "v", "i", "n" }, "<D-A-S-l>", ":vsplit<CR>", { noremap = true, silent = true })

-- Cycle to next window (wrap around)
vim.keymap.set({ "v", "i", "n" }, "<D-A-Tab>", "<C-w>w", { noremap = true, silent = true })

-- Cycle to previous window (wrap around)
vim.keymap.set({ "v", "i", "n" }, "<D-A-S-Tab>", "<C-w>W", { noremap = true, silent = true })

-- Normal mode horizontal split with Cmd+Alt+j
vim.keymap.set({ "v", "i", "n" }, "<D-A-S-j>", ":split<CR>", { noremap = true, silent = true })
vim.keymap.set({ "v", "i", "n" }, "<D-A-S-k>", ":split<CR>", { noremap = true, silent = true })

vim.keymap.set({ "n", "i", "v" }, "<D-A-Left>", "<cmd>vertical resize -5<cr>", { noremap = true, silent = true })  -- shrink width
vim.keymap.set({ "n", "i", "v" }, "<D-A-Right>", "<cmd>vertical resize +5<cr>", { noremap = true, silent = true }) -- increase width
vim.keymap.set({ "n", "i", "v" }, "<D-A-Up>", "<cmd>resize +2<cr>", { noremap = true, silent = true })             -- increase height
vim.keymap.set({ "n", "i", "v" }, "<D-A-Down>", "<cmd>resize -2<cr>", { noremap = true, silent = true })           -- decrease height

-- NORMAL mode
vim.keymap.set("n", "<Up>", "k^", { noremap = true, silent = true })
vim.keymap.set("n", "<Down>", "j^", { noremap = true, silent = true })

-- VISUAL mode
vim.keymap.set("v", "<Up>", "k^", { noremap = true, silent = true })
vim.keymap.set("v", "<Down>", "j$", { noremap = true, silent = true })

local function aerial_toggle_and_focus()
  require("aerial").toggle()
  -- Small delay to ensure window is created, then focus it
  vim.schedule(function()
    -- Find the aerial window by buffer type
    for _, win in ipairs(vim.api.nvim_list_wins()) do
      local buf = vim.api.nvim_win_get_buf(win)
      local buf_name = vim.api.nvim_buf_get_name(buf)
      if string.match(buf_name, "aerial://") then
        vim.api.nvim_set_current_win(win)
        break
      end
    end
  end)
end
vim.keymap.set({ "v", "n" }, "<C-f>", aerial_toggle_and_focus, { desc = "Toggle Aerial", silent = true })
vim.keymap.set({ "n", "i", "v" }, "<D-C-z>", "<Nop>")
vim.keymap.set({ "n", "i", "v" }, "<ScrollWheelLeft>", "<Nop>")
vim.keymap.set({ "n", "i", "v" }, "<ScrollWheelRight>", "<Nop>")
vim.keymap.set("n", "<Esc>", function()
  vim.cmd("noh")
end, { silent = true })
vim.keymap.set({ "v", "i" }, "<Esc>", "<esc>:noh<CR>", { silent = true })

vim.keymap.set({ "v" }, "<Esc>", "<esc><esc>")
vim.keymap.set({ "n", "v", "i" }, "<D-C-a>", "<Esc>gg_vG$", { noremap = true, silent = true })
-- Select all (with aliases)
vim.keymap.set({ "n", "v", "i" }, "<D-a>", "<Esc>gg_vG$", { noremap = true, silent = true, desc = "Select all" })
vim.keymap.set({ "n", "v", "i" }, "<D-C-a>", "<Esc>gg_vG$",
  { noremap = true, silent = true, desc = "Select all (alias)" })
vim.keymap.set({ "n", "v" }, "gg", "gg_", { noremap = true, silent = true })
vim.keymap.set({ "v" }, "G", "G$", { noremap = true, silent = true })

vim.keymap.set({ "n", "v" }, "<leader>a", "<Esc>gg_vG$", { noremap = true, silent = true })
vim.keymap.set({ "n", "v" }, "<Backspace>a", "<Esc>gg_vG$", { noremap = true, silent = true })
vim.keymap.set({ "n", "v" }, "`", require("./marks").set, { noremap = true, silent = true })
vim.keymap.set({ "n", "v" }, "!", "@@", { noremap = true, silent = true, desc = "Replay last macro" })
-- TODOPANDA - marks with error suppression
local function safe_jump_mark_exact()
  local char = vim.fn.getcharstr()
  pcall(vim.cmd, "normal! `" .. char)
end
local function safe_jump_mark_line()
  local char = vim.fn.getcharstr()
  pcall(vim.cmd, "normal! '" .. char)
end
vim.keymap.set({ "n", "v" }, "m", safe_jump_mark_exact, { noremap = true, silent = true })
vim.keymap.set({ "n", "v" }, ";", safe_jump_mark_exact, { noremap = true, silent = true })
vim.keymap.set({ "n", "v" }, "'", safe_jump_mark_line, { noremap = true, silent = true })
-- vim.keymap.set({ "n", "v" }, "m", "`Bm", { noremap = true, silent = true })
vim.keymap.set({ "n", "v" }, "<C-BS>", "<C-6>", { noremap = true, silent = true })
vim.keymap.set({ "n", "v" }, "<C-q>", "<cmd>wq<cr>", { noremap = true, silent = true })
-- cycles: normal -> no numbers -> no numbers + no lualine -> normal
function _G.toggle_zen()
  vim.g.zen_level = ((vim.g.zen_level or 0) + 1) % 3
  vim.g.zen_active = vim.g.zen_level > 0
  local win = vim.api.nvim_get_current_win()
  vim.wo[win].number = not vim.g.zen_active
  vim.wo[win].relativenumber = not vim.g.zen_active
  vim.wo[win].signcolumn = vim.g.zen_active and "no" or "yes"
  if vim.g.zen_level == 2 then
    vim.g.zen_laststatus = vim.o.laststatus
    require("lualine").hide({ unhide = false })
    vim.o.laststatus = 0
  elseif vim.g.zen_level == 0 then
    require("lualine").hide({ unhide = true })
    vim.o.laststatus = vim.g.zen_laststatus or 3
  end
end

vim.keymap.set({ "n", "v", "i" }, "<D-A-c>", "<cmd>lua toggle_zen()<CR>")
-- vim.keymap.set({ "n", "v" }, "<C-q>", "<C-6>", { noremap = true, silent = true })
vim.keymap.set({ "x", "c" }, "<A-BS>", "<C-w>", { noremap = true, silent = true })
vim.keymap.set("i", "<M-BS>", "<C-w>", { noremap = true, silent = true })
vim.keymap.set("v", "<M-BS>", "b", { noremap = true, silent = true })
vim.keymap.set("n", "<M-BS>", "db", { noremap = true, silent = true })
vim.keymap.set({ "v", "n", "i" }, "<C-Tab>", "<cmd>bnext<cr>", { noremap = true, silent = true })
vim.keymap.set({ "v", "n", "i" }, "<C-A-BS>", "<cmd>bprevious<cr>", { noremap = true, silent = true })
vim.keymap.set({ "v", "n", "i" }, "<C-Space>", "<cmd>bnext<cr>", { noremap = true, silent = true })
vim.keymap.set({ "v", "n", "i" }, "<C-S-Space>", "<cmd>bprevious<cr>", { noremap = true, silent = true })
vim.keymap.set({ "n", "i", "v" }, "<C-w>", "<cmd>bdelete<cr>", { noremap = true, silent = true })
vim.g.VM_maps = {
  ["i"] = "a",
  ["a"] = "i",
  ["A"] = "I",
  ["I"] = "A",
  -- ["Enter"] = "<CR><CR>",
}
vim.keymap.set("n", "r", function()
  vim.api.nvim_feedkeys("r" .. vim.fn.nr2char(vim.fn.getchar()) .. "\r", "n", true)
end, { noremap = true, silent = true, buffer = 0 })
vim.api.nvim_create_autocmd("User", {
  pattern = "visual_multi_start",
  callback = function()
    vim.keymap.set("n", "r", function()
      vim.api.nvim_feedkeys("r" .. vim.fn.nr2char(vim.fn.getchar()) .. "\r", "n", true)
    end, { noremap = true, silent = true, buffer = 0 })
  end,
})
vim.api.nvim_create_autocmd("User", {
  pattern = "visual_multi_exit",
  callback = function()
    vim.keymap.del("n", "r", { buffer = 0 })
  end,
})
-- TODOPANDA make this file only
vim.keymap.set("n", "<C-o>", "<C-i>", { noremap = true, silent = true })
vim.keymap.set("n", "<C-i>", "<C-o>", { noremap = true, silent = true })
vim.keymap.set({ "n", "v" }, "N", "Nzz", { noremap = true, silent = true })
vim.keymap.set({ "n", "v" }, "n", "nzz", { noremap = true, silent = true })
vim.keymap.set({ "n", "v" }, "*", "*zz", { noremap = true, silent = true })
vim.keymap.set({ "n", "v" }, "#", "#zz", { noremap = true, silent = true })

-- Vertical space to the left
vim.keymap.set("n", "<leader>j", "o<Esc>k", { noremap = true, silent = true })
vim.keymap.set("n", "<Backspace>j", "o<Esc>k", { noremap = true, silent = true })
vim.keymap.set("n", "<leader>k", "O<Esc>j", { noremap = true, silent = true })
vim.keymap.set("n", "<Backspace>k", "O<Esc>j", { noremap = true, silent = true })
-- Horizontal space
vim.keymap.set("n", "<leader>h", "i <Esc>l", { noremap = true, silent = true })
vim.keymap.set("n", "<Backspace>h", "i <Esc>l", { noremap = true, silent = true })

-- Non-shift mappings
-- vim.keymap.set({ "n", "v", "i" }, "<M-f>", "<C-Right>", { noremap = true, silent = true })
-- vim.keymap.set("i", "<A-Left>", "<C-o>:normal! b<CR>", { silent = true })
-- In your init.lua or ~/.config/nvim/lua/keymaps.lua
vim.keymap.set('i', '<M-Left>', '<C-o>b', { desc = 'Jump word backward in insert mode', silent = true })
vim.keymap.set('i', '<M-Right>', '<C-o>w', { desc = 'Jump word forward in insert mode', silent = true })
-- vim.keymap.set('i', '<Esc>b', '<C-o>b', { desc = 'Jump word backward', silent = true })
-- vim.keymap.set('i', '<Esc>f', '<C-o>w', { desc = 'Jump word forward', silent = true })
--
-- -- Alt+d for word deletion
-- vim.keymap.set('i', '<Esc>d', '<C-o>dw', { desc = 'Delete next word', silent = true })
-- Insert mode word deletions like terminal
-- Delete next word (Alt-d)
vim.keymap.set("i", "<M-d>", "<C-o>dw", { noremap = true, silent = true })

-- Delete previous word (Ctrl-w)
vim.keymap.set("i", "<C-w>", "<C-o>db", { noremap = true, silent = true })

vim.keymap.set("i", "<A-Up>", "<C-o>10k^zz", { noremap = true, silent = true })
vim.keymap.set("i", "<A-Down>", "<C-o>10j^zz", { noremap = true, silent = true })

vim.keymap.set({ "n", "v" }, "<A-Up>", "<Esc>10k^zz", { noremap = true, silent = true })
vim.keymap.set({ "n", "v" }, "<A-Down>", "<Esc>10j^zz", { noremap = true, silent = true })

-- Shift variants for selection
-- vim.keymap.set("i", "<A-S-Left>", "<Esc>vB", { noremap = true, silent = true })
-- vim.keymap.set("i", "<A-S-Right>", "<Esc>vW", { noremap = true, silent = true })
-- vim.keymap.set("i", "<A-S-Up>", "<Esc>v10k$zz", { noremap = true, silent = true })
-- vim.keymap.set("i", "<A-S-Down>", "<Esc>v10j$zz", { noremap = true, silent = true })
--
-- vim.keymap.set("n", "<A-S-Left>", "vB", { noremap = true, silent = true })
-- vim.keymap.set("n", "<A-S-Right>", "vW", { noremap = true, silent = true })
-- vim.keymap.set("n", "<A-S-Up>", "v10k$zz", { noremap = true, silent = true })
-- vim.keymap.set("n", "<A-S-Down>", "v10j$zz", { noremap = true, silent = true })
--
-- vim.keymap.set("v", "<A-S-Left>", "B", { noremap = true, silent = true })
-- vim.keymap.set("v", "<A-S-Right>", "W", { noremap = true, silent = true })
-- vim.keymap.set("v", "<A-S-Up>", "10k$", { noremap = true, silent = true })
-- vim.keymap.set("v", "<A-S-Down>", "10j$", { noremap = true, silent = true })
--
vim.keymap.set("v", "<D-C-/>", function()
  local esc = vim.api.nvim_replace_termcodes("<Esc>", true, false, true)
  vim.api.nvim_feedkeys(esc, "n", false) -- leave visual mode
  print("hsw")
  local text = vim.fn.getreg("v")        -- get visual selection
  text = vim.fn.escape(text, "/\\")      -- escape / and \ so it works in pattern

  -- Start :%s/<text>/
  vim.api.nvim_feedkeys(":%s/" .. text .. "/", "c", false)
end, { noremap = true, silent = true })

vim.keymap.set("v", "<leader>fr", function()
  local esc = vim.api.nvim_replace_termcodes("<Esc>", true, false, true)
  vim.api.nvim_feedkeys(esc, "n", false) -- leave visual mode

  local text = vim.fn.getreg("v")        -- get visual selection
  text = vim.fn.escape(text, "/\\")      -- escape / and \ so it works in pattern

  -- Start :%s/<text>/
  vim.api.nvim_feedkeys(":%s/" .. text .. "/", "c", false)
end, { noremap = true, silent = true })
vim.keymap.set({ "v", "n" }, "-", "<cmd>Oil<cr>", { noremap = true, silent = true })
vim.keymap.set({ "v", "i", "n" }, "<D-C-->", require("oil").toggle_float, { noremap = true, silent = true })
-- vim.keymap.set({ "v", "n" }, "-", require("oil").t, { noremap = true, silent = true })
vim.keymap.set({ "v", "n" }, "<leader>-", require("oil").toggle_float, { noremap = true, silent = true })
vim.keymap.set({ "n", "v" }, "<Backspace>d", '"_d', { noremap = true, silent = true })
vim.keymap.set({ "n", "v" }, "<Backspace>dj", 'j"_ddk', { noremap = true, silent = true })
vim.keymap.set({ "n", "v" }, "<Backspace>do", 'j"_ddk', { noremap = true, silent = true })
vim.keymap.set({ "n", "v" }, "<Backspace>dO", 'k"_dd', { noremap = true, silent = true })
vim.keymap.set({ "n", "v" }, "<Backspace>dk", 'k"_dd', { noremap = true, silent = true })
vim.keymap.set({ "n", "v" }, "<Backspace>p", '"+p', { noremap = true, silent = true })
-- vim.keymap.set({ "n", "v" }, "<leader>d", '"_d', { noremap = true, silent = true })
vim.keymap.set({ "n", "v" }, "<leader>d", '"+d', { noremap = true, silent = true })

vim.keymap.set({ "n", "v" }, "<leader>dj", 'j"_ddk', { noremap = true, silent = true })
vim.keymap.set({ "n", "v" }, "<leader>do", 'j"_ddk', { noremap = true, silent = true })
vim.keymap.set({ "n", "v" }, "<leader>dO", 'k"_dd', { noremap = true, silent = true })
vim.keymap.set({ "n", "v" }, "<leader>dk", 'k"_dd', { noremap = true, silent = true })
vim.keymap.set({ "n", "v" }, "<Backspace>y", '"+y', { noremap = true, silent = true })
vim.keymap.set({ "n", "v" }, "<leader>y", '"+y', { noremap = true, silent = true })
vim.keymap.set({ "n", "v" }, "<leader>p", '"+p', { noremap = true, silent = true })

-- Paste from clipboard
vim.keymap.set({ "i", "n", "v" }, "<D-v>", '"+p', { noremap = true, silent = true, desc = "Paste from clipboard" })

-- Copy to clipboard
vim.keymap.set({ "i", "n", "v" }, "<D-c>", '"+y', { noremap = true, silent = true, desc = "Copy to clipboard" })
vim.keymap.set({ "i", "n", "v" }, "<D-C-c>", '"+y', { noremap = true, silent = true, desc = "Copy to clipboard (alias)" })

-- Save commands
vim.keymap.set({ "n", "v", "i" }, "<D-s>", "<Esc>:w<CR>:wshada<CR>",
  { noremap = true, silent = true, desc = "Save current buffer" })
vim.keymap.set({ "n", "v", "i" }, "<D-C-s>", "<Esc>:wa<cr>:wshada<cr>",
  { noremap = true, silent = true, desc = "Save all buffers" })
vim.keymap.set({ "n", "v", "i" }, "<D-C-A-s>", "<Esc>:wa<cr>:wshada<cr>",
  { noremap = true, silent = true, desc = "Save all buffers" })
vim.keymap.set({ "n" }, "<Backspace>s", "<Esc>:wa<cr>:wshada<cr>", { noremap = true, silent = true })
vim.keymap.set({ "n" }, "<leader>s", "<Esc>:w<cr>:wshada<cr>", { noremap = true, silent = true })
vim.keymap.set({ "n", "v", "i" }, "<D-/>", "<Esc>:%s/", { noremap = true, silent = true })

vim.keymap.set({ "n", "v" }, "U", "<C-r>", { noremap = true, silent = true })

vim.keymap.set({ "n", "v" }, "<C-d>", "zz<C-d>zz", { noremap = true, silent = true })
-- vim.keymap.set({ "n", "v" }, "<D-j>", "zz<C-d>zz", { noremap = true, silent = true })
vim.keymap.set({ "n", "v" }, "<C-u>", "zz<C-u>zz", { noremap = true, silent = true })
-- vim.keymap.set({ "n", "v" }, "<D-k>", "zz<C-u>zz", { noremap = true, silent = true })

vim.keymap.set("i", "<C-p>", "<C-x><C-p>", { noremap = true, silent = true })
vim.keymap.set("i", "<C-n>", "<C-x><C-n>", { noremap = true, silent = true })

-- Original Ctrl-j/k: simple line moves with auto-indent
vim.keymap.set("n", "<C-k>", ":m .-2<CR>==", { noremap = true, silent = true })
vim.keymap.set("n", "<C-j>", ":m .+1<CR>==", { noremap = true, silent = true })
vim.keymap.set("v", "<C-k>", ":m '<-2<CR>gv=gv", { noremap = true, silent = true })
vim.keymap.set("v", "<C-j>", ":m '>+1<CR>gv=gv", { noremap = true, silent = true })
vim.keymap.set("n", "<BS>", "<Up>")

-- Helper: Move lines with nested/indented children
local function move_with_indent(direction)
  local start_line = vim.fn.line(".")
  local end_line = start_line
  local start_indent = vim.fn.indent(start_line)
  local buf_lines = vim.fn.line("$")

  -- Find all lines with greater indentation (children)
  while end_line < buf_lines do
    local next_line = end_line + 1
    local next_text = vim.fn.getline(next_line)
    -- Stop if we hit a non-empty line with same or less indentation
    if next_text:match("%S") and vim.fn.indent(next_line) <= start_indent then
      break
    end
    -- Include empty lines and more-indented lines
    if not next_text:match("%S") or vim.fn.indent(next_line) > start_indent then
      end_line = next_line
    else
      break
    end
  end

  -- Move the block
  if direction == "up" then
    if start_line > 1 then
      vim.cmd(start_line .. "," .. end_line .. "m " .. (start_line - 2))
      vim.api.nvim_win_set_cursor(0, { start_line - 1, 0 })
    end
  elseif direction == "down" then
    if end_line < buf_lines then
      vim.cmd(start_line .. "," .. end_line .. "m " .. (end_line + 1))
      vim.api.nvim_win_set_cursor(0, { start_line + 1, 0 })
    end
  end
end

-- Helper: Move visual selection with indent preservation
local function move_visual_with_indent(direction)
  local start_line = vim.fn.line("'<")
  local end_line = vim.fn.line("'>")

  if direction == "up" then
    if start_line > 1 then
      vim.cmd("'<,'>m '<-2")
      vim.cmd("normal! gv")
    end
  elseif direction == "down" then
    local buf_lines = vim.fn.line("$")
    if end_line < buf_lines then
      vim.cmd("'<,'>m '>+1")
      vim.cmd("normal! gv")
    end
  end
end

-- Cmd-Ctrl-Alt-j/k: move lines with nested children
vim.keymap.set("n", "<D-C-A-k>", function() move_with_indent("up") end, { noremap = true, silent = true })
vim.keymap.set("n", "<D-C-A-j>", function() move_with_indent("down") end, { noremap = true, silent = true })
vim.keymap.set("v", "<D-C-A-k>", function() move_visual_with_indent("up") end, { noremap = true, silent = true })
vim.keymap.set("v", "<D-C-A-j>", function() move_visual_with_indent("down") end, { noremap = true, silent = true })

vim.keymap.set("v", "<C-s>", ":Sort<CR>", { noremap = true, silent = true, desc = "Sort selected lines" })
vim.keymap.set({ "n", "v" }, "<C-l>", function()
  vim.api.nvim_feedkeys("xp", "n", true)
end, { noremap = true, silent = true })
vim.keymap.set({ "n", "v" }, "<C-h>", function()
  vim.api.nvim_feedkeys("xhP", "n", true)
end, { noremap = true, silent = true })

-- Manual override roots - expand paths from vim.g.project_roots
local function expand_path(path)
  if path:sub(1, 1) == "~" then
    return vim.fn.expand(path)
  end
  return path
end

-- dirs whose immediate children are git worktrees (each child gets its own root)
local settings = require("profile_settings")
local worktree_containers = settings.worktree_containers

-- true if path is root or inside it (avoids ~/code matching ~/codex)
local function under(path, root)
  return path == root or path:sub(1, #root + 1) == root .. "/"
end

-- ~/code/workspace/repo/crates/x -> ~/code/workspace/repo
local function worktree_root(path)
  for _, c in ipairs(worktree_containers) do
    c = vim.fs.normalize(vim.fn.expand(c))
    if under(path, c) then
      local name = path:sub(#c + 2):match("^[^/]+")
      local dir = name and (c .. "/" .. name)
      return (dir and vim.fn.isdirectory(dir) == 1) and dir or c
    end
  end
end

local function smart_root()
  local markers = {
    "Cargo.toml", "package.json", "pnpm-lock.yaml", "yarn.lock",
    "vite.config.ts", "vite.config.js", "pyproject.toml", "setup.py", ".git",
  }

  local buf = vim.api.nvim_get_current_buf()
  local file = vim.api.nvim_buf_get_name(buf)
  local filedir = vim.fs.normalize(vim.fn.fnamemodify(file, ":p:h"))
  local cwd = vim.fn.getcwd()

  -- Check if we're in an Oil buffer
  if vim.bo[buf].filetype == "oil" then
    local oil = require("oil")
    local oil_dir = oil.get_current_dir()
    if oil_dir then
      filedir = oil_dir
    end
  end

  -- Build manual_roots dynamically each time (since vim.g.project_roots is set in actions.lua)
  local manual_roots = {}
  for _, root in ipairs(vim.g.project_roots or {}) do
    table.insert(manual_roots, expand_path(root))
  end

  -- file dir takes precedence over cwd (cwd is usually a previous lcd)
  local target = filedir ~= "" and filedir or cwd
  local wt = worktree_root(target)
  if wt then
    return wt
  end

  for _, root in ipairs(manual_roots) do
    if under(target, root) and vim.fn.isdirectory(root) == 1 then
      return root
    end
  end

  if filedir ~= "" then
    local found = vim.fs.find(markers, { path = filedir, upward = true, stop = vim.loop.os_homedir() })[1]
    if found then
      local dir = vim.fs.dirname(found)
      if vim.fn.isdirectory(dir) == 1 then
        return dir
      end
    end
  end

  if filedir ~= "" and vim.fn.isdirectory(filedir) == 1 then
    return filedir
  end

  return cwd
end

vim.api.nvim_create_autocmd("BufEnter", {
  callback = function()
    vim.cmd("lcd " .. smart_root())
  end
})

local harpoon = require("harpoon")

-- harpoon reads its data file once (keyed by the root at startup) but writes to the file keyed by the root at
-- sync time, so moving between projects wrote empty lists over real ones. one fixed file for every project; the
-- list key is still smart_root(), so each project keeps its own list inside it
local harpoon_all = vim.fn.stdpath("data") .. "/harpoon/all.json"
require("harpoon.data").test.set_fullpath(function() return harpoon_all end)

harpoon:setup({
  settings = {
    save_on_toggle = true,
    sync_on_ui_close = true,
    key = function()
      return smart_root()
    end,
  },
  -- Customize the display
  menu = {
    width = vim.api.nvim_win_get_width(0) - 4,
    height = 12, -- Show 10 rows instead of default
  },
  default = {
    -- Convert relative paths to absolute when creating items
    create_list_item = function(config, item)
      if item == nil then
        item = vim.api.nvim_buf_get_name(vim.api.nvim_get_current_buf())
      end

      -- Convert to absolute path
      local path = item
      if path:sub(1, 1) ~= "/" then
        path = vim.fn.fnamemodify(path, ":p")
      end

      local cursor_pos = vim.api.nvim_win_get_cursor(0)
      return {
        value = path,
        context = {
          row = cursor_pos[1],
          col = cursor_pos[2],
        },
      }
    end,

    -- Display paths relative to root for readability
    display = function(list_item)
      local root = smart_root()
      local path = list_item.value

      -- Make path relative to project root
      if path:sub(1, #root) == root then
        path = path:sub(#root + 2) -- +2 to skip the trailing slash
      end

      -- Fallback: show relative to home
      local home = vim.loop.os_homedir()
      if path:sub(1, #home) == home then
        path = "~" .. path:sub(#home + 1)
      end

      return path
    end,
  },
})

-- vim.keymap.set({ "v", "n", "i" }, "<D-C-s>", "<esc>:lua require('harpoon'):list():select(1)<cr><cr>")
-- vim.keymap.set({ "v", "n", "i" }, "<D-C-i>", "<esc>:lua require('harpoon'):list():select(2)<cr><cr>")
-- vim.keymap.set({ "v", "n", "i" }, "<D-C-o>", "<esc>:lua require('harpoon'):list():select(3)<cr><cr>")
-- vim.keymap.set({ "v", "n", "i" }, "<D-C-n>", "<esc>:lua require('harpoon'):list():select(4)<cr><cr>")
-- Harpoon: Jump to marks 0-9 with Ctrl (top row or numpad)
for i = 0, 9 do
  for _, k in ipairs({ "<C-" .. i .. ">", "<C-k" .. i .. ">" }) do
    vim.keymap.set("n", k, function()
      harpoon:list():select(i == 0 and 10 or i)
    end, { desc = "Harpoon: Go to " .. (i == 0 and 10 or i) })
  end
end

-- Harpoon: Set marks 0-9 with Cmd-Ctrl (top row or numpad)
for i = 0, 9 do
  for _, k in ipairs({ "<D-C-" .. i .. ">", "<D-C-k" .. i .. ">" }) do
    vim.keymap.set("n", k, function()
      local pos = i == 0 and 10 or i
      harpoon:list():replace_at(pos)
    end, { desc = "Harpoon: Set mark " .. (i == 0 and 10 or i) })
  end
end
vim.keymap.set("n", "<leader>g", function() harpoon:list():add() end,
  { desc = "Harpoon: Add file" })

vim.keymap.set({ "n", "v", "i" }, "<D-C-l>", function()
  vim.cmd("stopinsert")
  require("oil").open(settings.vault)
end, { desc = "Oil: scratch notes" })
vim.keymap.set({ "n", "v", "i" }, "<D-C-A-l>", function()
  vim.cmd("stopinsert")
  require("oil").open(settings.protos)
end, { desc = "Oil: protos" })
vim.keymap.set({ "n", "v", "i" }, "<D-C-h>", function()
  vim.cmd("stopinsert")
  require("oil").open(vim.fn.expand("~"))
end, { desc = "Oil: home" })
vim.keymap.set({ "n", "v", "i" }, "<D-h>", function() harpoon:list():add() end,
  { desc = "Harpoon: Add file" })

-- vim.keymap.set("n", "<Backspace>h", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end,
-- { desc = "Harpoon: Toggle menu" })

vim.keymap.set("n", "<D-l>", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end,
  { desc = "Harpoon: Toggle menu" })
vim.keymap.set("n", "<leader>l", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end,
  { desc = "Harpoon: Toggle menu" })

vim.api.nvim_create_autocmd("DirChanged", {
  callback = function()
    -- Harpoon will use the new smart_root() automatically
    -- Just need to refresh the UI if it's open
    local ok, _ = pcall(require, "harpoon")
    if ok then
      -- Force a refresh of harpoon's internal state
      require("harpoon"):list()
    end
  end
})

local mac_excludes =
"--exclude .DS_Store --exclude Library --exclude .Trash --exclude .Spotlight-V100 --exclude System --exclude Applications --exclude Movies --exclude Music --exclude Pictures --exclude Public --exclude Desktop --exclude Documents --exclude Downloads --exclude OrbStack --exclude .cache --exclude .docker --exclude .orbstack --exclude .npm --exclude .cargo --exclude .rustup --exclude .local --exclude .bun --exclude node_modules"

-- current workspace worktree (has .git), else the one nvim was launched in / :Z to (global cwd), else main
local function workspace_root()
  local workspace = settings.workspace
  for _, p in ipairs({ smart_root(), vim.fn.getcwd(-1, -1) }) do
    local root = worktree_root(p)
    if root and root ~= workspace and vim.uv.fs_stat(root .. "/.git") then
      return root
    end
  end
  return workspace .. "/main"
end

-- ============================================================================
-- O FAMILY: FILES (mirrors E family grep structure)
-- ============================================================================
vim.keymap.set({ "n", "i", "v" }, "<D-o>", function()
  require("mini.pick").builtin.files(
    {},
    { source = { cwd = smart_root() } }
  )
end, { noremap = true, silent = true, desc = "Files: smart root" })

vim.keymap.set({ "n", "i", "v" }, "<D-C-o>", function()
  local current_file = vim.api.nvim_buf_get_name(0)
  local parent_dir = vim.fn.fnamemodify(current_file, ":h:h")
  require("mini.pick").builtin.files(
    {},
    { source = { cwd = parent_dir } }
  )
end, { noremap = true, silent = true, desc = "Files: ../ (parent)" })

vim.keymap.set({ "n", "i", "v" }, "<D-C-A-o>", function()
  local current_file = vim.api.nvim_buf_get_name(0)
  local grandparent_dir = vim.fn.fnamemodify(current_file, ":h:h:h")
  require("mini.pick").builtin.files(
    {},
    { source = { cwd = grandparent_dir } }
  )
end, { noremap = true, silent = true, desc = "Files: ../../ (grandparent)" })

vim.keymap.set({ "n", "i", "v" }, "<D-C-A-S-o>", function()
  require("mini.pick").builtin.files(
    {
      options = {
        fd_args = "--hidden --follow --no-ignore-vcs --exclude .git --exclude code/projects --exclude code/workspace " ..
            mac_excludes,
      },
    },
    { source = { cwd = vim.fn.expand("~") } }
  )
end, { noremap = true, silent = true, desc = "Files: ~/ (everything filtered)" })

vim.keymap.set({ "n", "i", "v" }, "<D-k>", function()
  require("mini.pick").builtin.files(
    {},
    { source = { cwd = settings.projects } }
  )
end, { noremap = true, silent = true, desc = "Files: ~/code/projects" })

-- d-c-a-k: files ~/code/projects (include git ignored)
vim.keymap.set({ "n", "i", "v" }, "<D-C-A-k>", function()
  local projects_path = settings.projects
  require("mini.pick").builtin.cli(
    {
      command = {
        "fd",
        "--type=f",
        "--color=never",
        "--hidden",
        "--follow",
        "--no-ignore",
      },
      spawn_opts = {
        cwd = projects_path,
      },
    },
    {
      source = {
        name = "Files (fd no-ignore)",
        cwd = projects_path,
      }
    }
  )
end, { noremap = true, silent = true, desc = "Files: ~/code/projects (no-ignore)" })

-- d-d: files in current workspace worktree (main if outside workspace)
vim.keymap.set({ "n", "i", "v" }, "<D-d>", function()
  require("mini.pick").builtin.files(
    {},
    { source = { cwd = workspace_root() } }
  )
end, { noremap = true, silent = true, desc = "Files: workspace worktree" })

-- d-c-a-d: files across all workspace worktrees + _/ (no-ignore, minus build/data)
vim.keymap.set({ "n", "i", "v" }, "<D-C-A-d>", function()
  local workspace_path = settings.workspace
  require("mini.pick").builtin.cli(
    {
      command = {
        "fd",
        "--type=f",
        "--color=never",
        "--hidden",
        "--follow",
        "--no-ignore",
        "--exclude=.git",
        "--exclude=target",
        "--exclude=data",
        "--base-directory=" .. workspace_path,
      },
    },
    {
      source = {
        name = "Files: workspace (all worktrees)",
        cwd = workspace_path,
      }
    }
  )
end, { noremap = true, silent = true, desc = "Files: workspace all worktrees" })

-- d-c-v: files ~/notes
vim.keymap.set({ "n", "i", "v" }, "<D-C-v>", function()
  require("mini.pick").builtin.files(
    {},
    { source = { cwd = settings.vault } }
  )
end, { noremap = true, silent = true, desc = "Files: ~/.vault" })

-- d-c-t: files ~/notes/scratch (git ignored so no-ignore)
vim.keymap.set({ "n", "i", "v" }, "<D-C-t>", function()
  local notes_path = settings.vault
  require("mini.pick").builtin.cli(
    {
      command = {
        "fd", "--type=f", "--color=never", "--hidden", "--follow", "--no-ignore",
        "--exclude=.git", "--exclude=.venv", "--exclude=target", "--exclude=node_modules", "--exclude=__pycache__",
      },
      spawn_opts = { cwd = notes_path },
    },
    { source = { name = "Files: notes", cwd = notes_path } }
  )
end, { noremap = true, silent = true, desc = "Files: ~/.vault/cloud (notes)" })

-- d-c-a-c: files ~/.config
vim.keymap.set({ "n", "i", "v" }, "<D-C-A-c>", function()
  require("mini.pick").builtin.files(
    {},
    { source = { cwd = settings.config_dir } }
  )
end, { noremap = true, silent = true, desc = "Files: ~/.config" })


-- ============================================================================
-- LIVE GREP MAPPINGS
-- ============================================================================
-- E FAMILY: smart root + local directory grep
-- J FAMILY: projects grep
-- F FAMILY: workspace grep
-- O FAMILY: files (mirrors E grep structure)
-- K/D FAMILY: projects/workspace files

-- Helper: Recent directories picker for a base path
local function recent_dirs_picker(base_path, desc)
  local oldfiles = vim.v.oldfiles or {}
  local dirs = {}
  local seen = {}

  for _, file in ipairs(oldfiles) do
    if file:sub(1, #base_path) == base_path and vim.fn.isdirectory(file) == 0 then
      local dir = vim.fn.fnamemodify(file, ":h")
      if not seen[dir] and vim.fn.isdirectory(dir) == 1 then
        seen[dir] = true
        table.insert(dirs, dir)
      end
    end
    if #dirs >= 50 then break end
  end

  if #dirs == 0 then
    vim.notify("No recent directories in " .. base_path, vim.log.levels.WARN)
    return
  end

  require("mini.pick").start({
    source = {
      items = dirs,
      name = desc or "Recent Directories",
      choose = function(item)
        if item then
          vim.cmd("lcd " .. vim.fn.fnameescape(item))
          require("mini.pick").builtin.files({}, { source = { cwd = item } })
        end
      end
    }
  })
end

-- Helper: base ripgrep args with smart-case enabled, includes hidden and md files
local function rg_args_with_smart_case(extra_args)
  local base = {
    "--no-heading",
    "--line-number",
    "--column",
    "--smart-case",
    "--hidden",                -- Search in hidden files like .env
    "--no-ignore-vcs",         -- Ignore .gitignore to search .md files
    "--glob", "!.git/*",       -- But exclude .git directory
    "--glob", "!**/target/**", -- rust build output
    "--glob", "!**/data/**",   -- parquet/log dumps
  }
  if extra_args then
    for _, arg in ipairs(extra_args) do
      table.insert(base, arg)
    end
  end
  return base
end

-- grep query history for the E family: <C-s> back / <C-t> forward in the picker walk past queries (newest first);
-- plain <Up> / <Down> stay mini.pick's move between results
local grep_history, grep_hist_pos = {}, 0
local function grep_recall(step)
  if #grep_history == 0 then return end
  grep_hist_pos = math.max(1, math.min(#grep_history, grep_hist_pos + step))
  MiniPick.set_picker_query(vim.split(grep_history[grep_hist_pos], ""))
end
local grep_hist_maps = {
  hist_back = { char = "<C-s>", func = function() grep_recall(1) end },
  hist_fwd = { char = "<C-t>", func = function() grep_recall(-1) end },
  -- <C-s> / <C-t> were mini.pick's open-in-split / open-in-tab, unused
  choose_in_split = "",
  choose_in_tabpage = "",
}

-- Helper: Save grep context and track last query
local function grep_with_tracking(tool_args, source_opts)
  local cwd = source_opts.source.cwd

  vim.api.nvim_create_autocmd("User", {
    pattern = "MiniPickStop",
    once = true,
    callback = function()
      local query_parts = MiniPick.get_picker_query() or {}
      local query = table.concat(query_parts, "")
      if query and query ~= "" then
        vim.g.last_grep_context = {
          query = query,
          tool_args = tool_args,
          cwd = cwd,
        }
        -- newest first, no repeats, keep 50
        for i, q in ipairs(grep_history) do
          if q == query then table.remove(grep_history, i) break end
        end
        table.insert(grep_history, 1, query)
        grep_history[51] = nil
      end
    end,
  })

  grep_hist_pos = 0
  source_opts = vim.tbl_deep_extend("force", source_opts, { mappings = grep_hist_maps })
  require("mini.pick").builtin.grep_live({ tool = "rg", tool_args = tool_args }, source_opts)
end

-- ============================================================================
-- E FAMILY: SMART ROOT + LOCAL GREP
-- ============================================================================
-- d-e: grep smart root (normal mode)
vim.keymap.set({ "n", "i" }, "<D-e>", function()
  grep_with_tracking(rg_args_with_smart_case(), { source = { cwd = smart_root() } })
end, { noremap = true, silent = true, desc = "Grep: smart root" })

-- d-e: grep selection (visual mode)
vim.keymap.set("v", "<D-e>", function()
  vim.cmd('noau normal! "vy"')
  local text = vim.fn.getreg('v')
  vim.fn.setreg('v', {})
  text = vim.fn.escape(text, '\\/.*$^~[]')
  text = text:gsub('\n', '\\n')

  require("mini.pick").builtin.grep_live(
    {
      tool = "rg",
      tool_args = rg_args_with_smart_case({ "--fixed-strings" }),
    },
    {
      source = { cwd = smart_root() },
      default = text
    }
  )
end, { noremap = true, silent = true, desc = "Grep: selection in smart root" })

-- d-c-e: grep ../ (parent)
vim.keymap.set({ "n", "i", "v" }, "<D-C-e>", function()
  local current_file = vim.api.nvim_buf_get_name(0)
  local parent_dir = vim.fn.fnamemodify(current_file, ":h:h")
  grep_with_tracking(rg_args_with_smart_case({ "--no-ignore" }), { source = { cwd = parent_dir } })
end, { noremap = true, silent = true, desc = "Grep: ../ (parent)" })

-- d-c-a-e: grep ../../ (grandparent)
vim.keymap.set({ "n", "i", "v" }, "<D-C-A-e>", function()
  local current_file = vim.api.nvim_buf_get_name(0)
  local grandparent_dir = vim.fn.fnamemodify(current_file, ":h:h:h")
  grep_with_tracking(rg_args_with_smart_case({ "--no-ignore" }), { source = { cwd = grandparent_dir } })
end, { noremap = true, silent = true, desc = "Grep: ../../ (grandparent)" })

-- d-c-a-s-e: grep ~/ (everything except system)
vim.keymap.set({ "n", "i", "v" }, "<D-C-A-S-e>", function()
  grep_with_tracking(
    rg_args_with_smart_case({
      "--glob=!code/projects/**",
      "--glob=!code/workspace/**",
      "--glob=!Library/**",
      "--glob=!.Trash/**",
      "--glob=!.Spotlight-V100/**",
      "--glob=!System/**",
    }),
    { source = { cwd = vim.fn.expand("~") } }
  )
end, { noremap = true, silent = true, desc = "Grep: ~/ (everything filtered)" })

-- ============================================================================
-- J FAMILY: PROJECTS GREP
-- ============================================================================
-- d-j: grep ~/code/projects (respects .gitignore)
vim.keymap.set({ "n", "i", "v" }, "<D-j>", function()
  grep_with_tracking(rg_args_with_smart_case(), { source = { cwd = settings.projects } })
end, { noremap = true, silent = true, desc = "Grep: ~/code/projects" })

-- d-c-j: recent directories from ~/code/projects
vim.keymap.set({ "n", "i", "v" }, "<D-C-j>", function()
  recent_dirs_picker(settings.projects, "Recent: ~/code/projects")
end, { noremap = true, silent = true, desc = "Recent dirs: ~/code/projects" })

-- d-c-a-j: grep ~/code/projects (--no-ignore, everything)
vim.keymap.set({ "n", "i", "v" }, "<D-C-A-j>", function()
  grep_with_tracking(rg_args_with_smart_case({ "--no-ignore" }), { source = { cwd = settings.projects } })
end, { noremap = true, silent = true, desc = "Grep: ~/code/projects (no-ignore)" })

-- ============================================================================
-- F FAMILY: WORKSPACE GREP
-- ============================================================================
-- d-f: grep current workspace worktree (main if outside workspace)
vim.keymap.set({ "n", "i", "v" }, "<D-f>", function()
  grep_with_tracking(rg_args_with_smart_case(), { source = { cwd = workspace_root() } })
end, { noremap = true, silent = true, desc = "Grep: workspace worktree" })

-- d-c-f: recent directories from ~/code/workspace
vim.keymap.set({ "n", "i", "v" }, "<D-C-f>", function()
  recent_dirs_picker(settings.workspace, "Recent: ~/code/workspace")
end, { noremap = true, silent = true, desc = "Recent dirs: ~/code/workspace" })

-- d-c-a-f: grep all workspace worktrees + _/
vim.keymap.set({ "n", "i", "v" }, "<D-C-A-f>", function()
  grep_with_tracking(rg_args_with_smart_case(), { source = { cwd = settings.workspace } })
end, { noremap = true, silent = true, desc = "Grep: workspace all worktrees" })

-- d-c-a-v: grep ~/.vault
vim.keymap.set({ "n", "i", "v" }, "<D-C-A-v>", function()
  grep_with_tracking(rg_args_with_smart_case(), { source = { cwd = settings.vault_parent } })
end, { noremap = true, silent = true, desc = "Grep: ~/.vault" })

-- d-c-a-s-f: repeat last grep with same query
vim.keymap.set({ "n", "i", "v" }, "<D-C-A-S-f>", function()
  local last_grep = vim.g.last_grep_context
  if not last_grep then
    vim.notify("No previous grep to repeat", vim.log.levels.WARN)
    return
  end

  vim.api.nvim_create_autocmd("User", {
    pattern = "MiniPickStart",
    once = true,
    callback = function()
      MiniPick.set_picker_query(vim.split(last_grep.query, ""))
    end,
  })

  require("mini.pick").builtin.grep_live(
    {
      tool = "rg",
      tool_args = last_grep.tool_args,
    },
    { source = { cwd = last_grep.cwd } }
  )
end, { noremap = true, silent = true, desc = "Repeat last grep" })

-- ============================================================================
-- OTHER GREP ACTIONS
-- ============================================================================
-- d-*: grep word under cursor (smart root)
vim.keymap.set("n", "<D-S-8>", function()
  local word = vim.fn.expand("<cword>")

  vim.api.nvim_create_autocmd("User", {
    pattern = "MiniPickStart",
    once = true,
    callback = function()
      MiniPick.set_picker_query(vim.split(word, ""))
    end,
  })

  require("mini.pick").builtin.grep_live(
    { tool = "rg", tool_args = rg_args_with_smart_case() },
    { source = { cwd = smart_root() } }
  )
end, { noremap = true, silent = true, desc = "Grep: word under cursor" })

-- d-c-*: grep word under cursor (smart root alias)
vim.keymap.set("n", "<D-C-S-8>", function()
  local word = vim.fn.expand("<cword>")
  require("mini.pick").builtin.grep_live(
    {
      tool = "rg",
      tool_args = rg_args_with_smart_case(),
    },
    {
      source = { cwd = smart_root() },
      default = word
    }
  )
end, { noremap = true, silent = true, desc = "Grep: word under cursor" })

-- d-b: grep all open buffers
vim.keymap.set({ "n", "i", "v" }, "<D-C-b>", function()
  local items = {}
  local bufs = vim.fn.getbufinfo({ buflisted = 1 })

  for _, buf in ipairs(bufs) do
    local bufnr = buf.bufnr
    local filename = vim.fn.fnamemodify(buf.name, ":t")
    if filename == "" then filename = "[No Name]" end

    if vim.api.nvim_buf_is_loaded(bufnr) then
      local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
      for lnum, line in ipairs(lines) do
        table.insert(items, {
          bufnr = bufnr,
          lnum = lnum,
          filename = filename,
          text = line,
        })
      end
    end
  end

  require("mini.pick").start({
    source = {
      name = "All Buffers",
      items = items,
      show = function(buf_id, items_to_show, query)
        local ns = vim.api.nvim_create_namespace('mini_pick_buffer_grep')
        vim.api.nvim_buf_clear_namespace(buf_id, ns, 0, -1)

        local lines_to_show = {}
        for _, item in ipairs(items_to_show) do
          table.insert(lines_to_show, string.format("%-20s %4d: %s", item.filename, item.lnum, item.text))
        end
        vim.api.nvim_buf_set_lines(buf_id, 0, -1, false, lines_to_show)
      end,
      choose = function(item)
        if not item then return end
        -- Close the picker first
        vim.cmd("stopinsert")
        -- Switch to buffer and move cursor
        vim.schedule(function()
          if vim.api.nvim_buf_is_valid(item.bufnr) then
            vim.api.nvim_set_current_buf(item.bufnr)
            vim.api.nvim_win_set_cursor(0, { item.lnum, 0 })
            vim.cmd("normal! zz")
          end
        end)
      end,
      choose_marked = function(items_marked)
        if not items_marked or #items_marked == 0 then return end
        vim.cmd("stopinsert")
        vim.schedule(function()
          for _, item in ipairs(items_marked) do
            if vim.api.nvim_buf_is_valid(item.bufnr) then
              vim.api.nvim_set_current_buf(item.bufnr)
              vim.api.nvim_win_set_cursor(0, { item.lnum, 0 })
              vim.cmd("normal! zz")
              break
            end
          end
        end)
      end,
    },
  })
end, { noremap = true, silent = true, desc = "Grep: all open buffers" })

-- ============================================================================
-- LSP NAVIGATION MAPPINGS
-- ============================================================================
-- d-g: go to declaration in vsplit
vim.keymap.set("n", "<D-g>", function()
  vim.cmd("vsplit")
  vim.lsp.buf.declaration()
end, { noremap = true, silent = true, desc = "LSP: declaration in vsplit" })

-- d-c-g: find usages/references
vim.keymap.set("n", "<D-C-g>", function()
  vim.lsp.buf.references()
end, { noremap = true, silent = true, desc = "LSP: find references/usages" })

-- d-c-a-g: go to implementation
vim.keymap.set("n", "<D-C-A-g>", vim.lsp.buf.implementation,
  { noremap = true, silent = true, desc = "LSP: go to implementation" })

-- d-c-a-s-g: go to type definition
vim.keymap.set("n", "<D-C-A-S-g>", vim.lsp.buf.type_definition,
  { noremap = true, silent = true, desc = "LSP: type definition" })

-- ============================================================================
-- LSP REFACTORING & DIAGNOSTICS (R FAMILY)
-- ============================================================================
-- d-r: rename symbol
vim.keymap.set("n", "<D-r>", vim.lsp.buf.rename,
  { noremap = true, silent = true, desc = "LSP: rename symbol" })

-- d-c-r: code actions (quick fixes, imports, etc)
vim.keymap.set("n", "<D-C-r>", vim.lsp.buf.code_action,
  { noremap = true, silent = true, desc = "LSP: code action" })

-- d-c-a-r: format document
vim.keymap.set("n", "<D-C-A-r>", function()
  vim.lsp.buf.format({ async = true })
end, { noremap = true, silent = true, desc = "LSP: format document" })

-- d-c-a-s-r: workspace symbol search
vim.keymap.set("n", "<D-C-A-S-r>", vim.lsp.buf.workspace_symbol,
  { noremap = true, silent = true, desc = "LSP: workspace symbol search" })

-- Enhanced buffer picker with MRU (most recently used) sorting
vim.keymap.set({ "v", "i", "n" }, "<D-b>", function()
  require("mini.pick").builtin.buffers(
    {},
    {
      source = {
        items = function()
          local bufs = vim.fn.getbufinfo({ buflisted = 1 })
          -- Sort by most recently used
          table.sort(bufs, function(a, b)
            return a.lastused > b.lastused
          end)
          return vim.tbl_map(function(buf)
            return buf.bufnr
          end, bufs)
        end
      }
    }
  )
end, { noremap = true, silent = true, desc = "Buffers (MRU sorted)" })

-- d-c-a-b: recent files
vim.keymap.set({ "n", "i", "v" }, "<D-C-A-b>", function()
  local oldfiles = vim.v.oldfiles or {}
  local items = {}
  for _, file in ipairs(oldfiles) do
    if vim.fn.filereadable(file) == 1 then
      table.insert(items, file)
    end
    if #items >= 100 then break end
  end
  require("mini.pick").builtin.files(
    {},
    {
      source = {
        name = "Recent Files",
        items = items,
        choose = function(item)
          vim.cmd("edit " .. vim.fn.fnameescape(item))
        end
      }
    }
  )
end, { noremap = true, silent = true, desc = "Files: recent" })

-- leader e / o: grep / files in the current file's own folder (the gap under <D-C-e> / <D-C-o>, which start one up)
local function file_dir()
  local name = vim.api.nvim_buf_get_name(0)
  if vim.bo.filetype == "oil" then
    return require("oil").get_current_dir() or smart_root()
  end
  return name ~= "" and vim.fn.fnamemodify(name, ":p:h") or smart_root()
end
vim.keymap.set("n", "<leader>e", function()
  grep_with_tracking(rg_args_with_smart_case(), { source = { cwd = file_dir() } })
end, { noremap = true, silent = true, desc = "Grep: this file's folder" })
vim.keymap.set("n", "<leader>o", function()
  require("mini.pick").builtin.files({}, { source = { cwd = file_dir() } })
end, { noremap = true, silent = true, desc = "Files: this file's folder" })

-- backspace o: recent files in this project (smart root), newest first
vim.keymap.set("n", "<Backspace>o", function()
  local root = smart_root()
  local items = {}
  for _, file in ipairs(vim.v.oldfiles or {}) do
    if vim.startswith(file, root .. "/") and vim.fn.filereadable(file) == 1 then
      table.insert(items, file:sub(#root + 2))
    end
    if #items >= 100 then break end
  end
  if #items == 0 then
    return vim.notify("no recent files in " .. vim.fn.fnamemodify(root, ":~"), vim.log.levels.WARN)
  end
  require("mini.pick").builtin.files({}, {
    source = { name = "Recent: " .. vim.fn.fnamemodify(root, ":t"), items = items, cwd = root },
  })
end, { noremap = true, silent = true, desc = "Files: recent in project" })

-- backspace e: grep only this project's harpoon files (mini.pick globs, relative to the root, narrow rg to them)
vim.keymap.set("n", "<Backspace>e", function()
  local root = smart_root()
  local globs = {}
  for _, item in ipairs(harpoon:list().items) do
    local p = item.value
    if p:sub(1, 1) ~= "/" then
      p = root .. "/" .. p
    end
    if vim.startswith(p, root .. "/") and vim.fn.filereadable(p) == 1 then
      table.insert(globs, p:sub(#root + 2))
    end
  end
  if #globs == 0 then
    return vim.notify("no harpoon files in " .. vim.fn.fnamemodify(root, ":~"), vim.log.levels.WARN)
  end
  require("mini.pick").builtin.grep_live({ tool = "rg", globs = globs }, { source = { cwd = root, name = "Grep: harpoon" } })
end, { noremap = true, silent = true, desc = "Grep: harpoon files" })

-- Help tags picker
vim.keymap.set("n", "<D-C-A-h>", "<cmd>Pick help<cr>",
  { noremap = true, silent = true, desc = "Help tags" })
-- vim.keymap.set({ "v", "i", "n" }, "<D-b>", "<esc><cmd>Pick grep<cr><cr>", { noremap = true, silent = true })
-- vim.keymap.set({ "n", "v" }, ",", ":Pounce<cr>", { noremap = true, silent = true })
-- vim.keymap.set({ "n", "v" }, "<Tab>", ":PounceRepeat<cr>", { noremap = true, silent = true })
vim.keymap.set({ "v", "n" }, "<S-,>", ":PounceRepeat<cr>", { noremap = true, silent = true })
vim.keymap.set({ "v", "n" }, ",", ":Pounce<cr>", { noremap = true, silent = true })
vim.keymap.set({ "v", "n" }, "<C-,>", ":PounceRepeat<cr>", { noremap = true, silent = true })
vim.keymap.set({ "v", "n" }, "<leader>,", ":PounceRepeat<cr>", { noremap = true, silent = true })
vim.keymap.set({ "v", "n" }, "<Backspace>,", ":PounceRepeat<cr>", { noremap = true, silent = true })

-- Jump to start/end of line in Insert mode
vim.keymap.set("i", "<C-e>", "<C-o>$", { noremap = true, silent = true })  -- end of line
vim.keymap.set("i", "<C-a>", "<C-o>^", { noremap = true, silent = true })  -- start of line
-- Insert mode Ctrl-k / Ctrl-u
vim.keymap.set("i", "<C-k>", "<C-o>d$", { noremap = true, silent = true }) -- delete to end
vim.keymap.set("i", "<C-u>", "<C-o>d0", { noremap = true, silent = true }) -- delete to start


-- leader i / backspace i: select the indent block (inner)
local keys = { "<leader>i", "<Backspace>i" }
for _, key in ipairs(keys) do
  vim.keymap.set("n", key, function()
    local cur_line = vim.fn.line(".")
    local cur_indent = vim.fn.indent(cur_line)
    local buf_lines = vim.fn.line("$")
    local start_line = cur_line
    while start_line > 1 do
      local line_indent = vim.fn.indent(start_line - 1)
      local line_text = vim.fn.getline(start_line - 1)
      if line_indent < cur_indent and line_text:match("%S") then
        break
      end
      start_line = start_line - 1
    end
    local end_line = cur_line
    while end_line < buf_lines do
      local line_indent = vim.fn.indent(end_line + 1)
      local line_text = vim.fn.getline(end_line + 1)
      if line_indent < cur_indent and line_text:match("%S") then
        break
      end
      end_line = end_line + 1
    end
    vim.api.nvim_win_set_cursor(0, { start_line, 0 })
    vim.cmd("normal! V" .. (end_line - start_line) .. "j")
  end, { noremap = true, silent = true })
end

-- leader v / backspace v (and leader b / backspace b): select the indent block plus the line above and below it
keys = { "<leader>v", "<Backspace>v", "<leader>b", "<Backspace>b" }
for _, key in ipairs(keys) do
  vim.keymap.set("n", key, function()
    local cur_line = vim.fn.line(".")
    local cur_indent = vim.fn.indent(cur_line)
    local buf_lines = vim.fn.line("$")
    local start_line = cur_line
    while start_line > 1 do
      local line_indent = vim.fn.indent(start_line - 1)
      local line_text = vim.fn.getline(start_line - 1)
      if line_indent < cur_indent and line_text:match("%S") then
        break
      end
      start_line = start_line - 1
    end
    if start_line > 1 then
      start_line = start_line - 1
    end
    local end_line = cur_line
    while end_line < buf_lines do
      local line_indent = vim.fn.indent(end_line + 1)
      local line_text = vim.fn.getline(end_line + 1)
      if line_indent < cur_indent and line_text:match("%S") then
        break
      end
      end_line = end_line + 1
    end
    if end_line < buf_lines then
      end_line = end_line + 1
    end
    vim.api.nvim_win_set_cursor(0, { start_line, 0 })
    vim.cmd("normal! V" .. (end_line - start_line) .. "j")
  end, { noremap = true, silent = true })
end
vim.keymap.set("n", "<leader>x", "'X", {
  noremap = true,
  silent = true,
  desc = "todo"
})
vim.keymap.set("n", "<Backspace>x", "'X", {
  noremap = true,
  silent = true,
  desc = "todo"
})
vim.keymap.set("n", "<leader>q", "'Q", {
  noremap = true,
  silent = true,
  desc = "flow"
})
vim.keymap.set("n", "<Backspace>q", "'Q", {
  noremap = true,
  silent = true,
  desc = "flow"
})
vim.keymap.set("n", "<leader>w", "<cmd>bdelete<cr>", {
  noremap = true,
  silent = true,
  desc = "close buffer"
})
-- unsaved buffers stay open
vim.keymap.set("n", "<Backspace>w", function()
  local cur = vim.api.nvim_get_current_buf()
  for _, b in ipairs(vim.api.nvim_list_bufs()) do
    if b ~= cur and vim.bo[b].buflisted and not vim.bo[b].modified then
      pcall(vim.api.nvim_buf_delete, b, {})
    end
  end
end, {
  noremap = true,
  silent = true,
  desc = "close other buffers"
})
vim.keymap.set("n", "<leader>z", "'Z", {
  noremap = true,
  silent = true,
  desc = "mark Z"
})
vim.keymap.set("n", "<Backspace>z", "'Z", {
  noremap = true,
  silent = true,
  desc = "mark Z"
})

-- vim.keymap.set("n", "<leader>s", "'S", {
--   noremap = true,
--   silent = true,
--   desc = "zen"
-- })
-- <Backspace>s saves (with <leader>s, near the <D-s> maps)
-- vim.keymap.set("n", "<Backspace>s", "'S", {
--   noremap = true,
--   silent = true,
--   desc = "zen"
-- })
vim.keymap.set("n", "<leader>n", "'N", {
  noremap = true,
  silent = true,
  desc = "zen"
})
vim.keymap.set("n", "<Backspace>n", "'N", {
  noremap = true,
  silent = true,
  desc = "zen"
})

-- leader t / backspace t: beam (global), see the beam section
vim.keymap.set("n", "<leader>'", "'Y", {
  noremap = true,
  silent = true,
  desc = "now"
})
vim.keymap.set("n", "<Backspace>'", "'Y", {
  noremap = true,
  silent = true,
  desc = "now"
})
vim.keymap.set("n", "<leader>;", "'X", {
  noremap = true,
  silent = true,
  desc = "todo"
})
vim.keymap.set("n", "<Backspace>;", "'X", {
  noremap = true,
  silent = true,
  desc = "todo"
})
-- beam (:Beam in actions.lua), same on space and backspace:
--   t<a-z> = global mark A-Z (any file), u<a-z> = this file's mark a-z
-- both land on the line after the mark; normal = the line + its indented children, visual = the selection
for c in ("abcdefghijklmnopqrstuvwxyz"):gmatch(".") do
  for _, l in ipairs({ "<leader>", "<Backspace>" }) do
    vim.keymap.set("n", l .. "t" .. c, "<cmd>Beam " .. c:upper() .. "<cr>", { desc = "beam to mark " .. c:upper() })
    vim.keymap.set("x", l .. "t" .. c, ":Beam " .. c:upper() .. "<cr>", { silent = true, desc = "beam to mark " .. c:upper() })
    vim.keymap.set("n", l .. "u" .. c, "<cmd>Beam " .. c .. "<cr>", { desc = "beam to mark " .. c })
    vim.keymap.set("x", l .. "u" .. c, ":Beam " .. c .. "<cr>", { silent = true, desc = "beam to mark " .. c })
  end
end

-- ============================================================================
-- SURROUND SHORTCUTS (mini.surround quick actions)
-- ============================================================================
-- Base: saiw" (surround inner word), sa2w", sa$", sd", sr"'
-- Added shortcuts:
-- ss" = surround line
-- s" = surround word (shortcut for saiw")
-- sb = surround word with brackets
-- sa}" = surround to next }

-- ss + char = surround entire line (sa$)
vim.keymap.set("n", "ss", function()
  local char = vim.fn.getcharstr()
  -- Use visual selection to bypass i/a remap
  vim.cmd("normal! v$")
  vim.schedule(function()
    vim.api.nvim_feedkeys("sa" .. char, "m", false)
  end)
end, { noremap = true, silent = true, desc = "Surround line" })

-- s + char shortcuts for word surround
vim.keymap.set("n", "s", function()
  local char = vim.fn.getcharstr()

  -- ss = surround line (let ss mapping handle it)
  if char == "s" then
    vim.api.nvim_feedkeys("ss", "n", false)
    return
  end

  -- sd = delete, sr = replace (pass through to mini.surround)
  if char == "d" or char == "r" then
    vim.api.nvim_feedkeys("s" .. char, "n", false)
    return
  end

  -- sb = surround word with brackets
  if char == "b" then
    vim.cmd("normal! viw")
    vim.schedule(function()
      vim.api.nvim_feedkeys("sa[", "m", false)
    end)
    return
  end

  -- s} or s{ = surround word with braces
  if char == "}" or char == "{" then
    vim.cmd("normal! viw")
    vim.schedule(function()
      vim.api.nvim_feedkeys("sa" .. char, "m", false)
    end)
    return
  end

  -- s + other surround chars = surround word (quotes, parens, brackets, backticks)
  if char:match('["\')(`%[%]]') then
    vim.cmd("normal! viw")
    vim.schedule(function()
      vim.api.nvim_feedkeys("sa" .. char, "m", false)
    end)
    return
  end

  -- s + anything else = treat as motion
  -- Examples: s$" = surround to end of line with quotes
  -- For motion surround, use sa}} (default mini.surround)
  vim.api.nvim_feedkeys("sa" .. char, "n", false)
end, { noremap = true, silent = true, desc = "Surround shortcuts" })

-- Visual mode: Just use mini.surround directly with no wrapper
vim.keymap.set("v", "s", function()
  local char = vim.fn.getcharstr()
  -- Exit visual mode first
  vim.cmd('normal! \27') -- ESC
  -- Reselect and surround
  vim.cmd('normal! gv')
  vim.schedule(function()
    vim.api.nvim_feedkeys("sa" .. char, "m", false)
  end)
end, { noremap = true, silent = true, desc = "Surround selection" })
