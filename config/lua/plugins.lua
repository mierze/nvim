local settings = require("profile_settings")
---------------------------
------P-L-U-G-I-N-S--------
---------------------------

-- Paragon colorscheme
-- require("paragon").setup({})

require("aerial").setup({
  -- Priority list of preferred backends for aerial.
  backends = { "treesitter", "lsp", "markdown", "man" },

  layout = {
    max_width = { 40, 0.4 },
    width = nil,
    min_width = 10,
    default_direction = "prefer_left",
    placement = "window",
  },

  attach_mode = "window",
  close_automatic_events = {},

  -- Simplified keymaps - just the essentials
  keymaps = {
    ["<CR>"] = "actions.jump",
    ["<2-LeftMouse>"] = "actions.jump",
    ["q"] = "actions.close",
    ["<Esc>"] = "actions.close", -- Easy exit
  },

  show_guides = true,
  manage_folds = false,
  default_bindings = true,
  disable_max_lines = 10000,
  disable_max_size = 2000000,

  filter_kind = {
    "Class",
    "Constructor",
    "Enum",
    "Function",
    "Interface",
    "Module",
    "Method",
    "Struct",
  },
})

-- Fixed:
require("rainbow-delimiters.setup").setup({})
-- More explicit rainbow delimiters setup
vim.g.rainbow_delimiters = {
  strategy = {
    [""] = "rainbow-delimiters.strategy.global",
    typescript = "rainbow-delimiters.strategy.global",
    tsx = "rainbow-delimiters.strategy.global",
    javascript = "rainbow-delimiters.strategy.global",
  },
  query = {
    [""] = "rainbow-delimiters",
    typescript = "rainbow-delimiters",
    tsx = "rainbow-delimiters",
    javascript = "rainbow-delimiters",
  },
  highlight = {
    "RainbowDelimiterRed",
    "RainbowDelimiterYellow",
    "RainbowDelimiterBlue",
    "RainbowDelimiterOrange",
    "RainbowDelimiterGreen",
    "RainbowDelimiterViolet",
    "RainbowDelimiterCyan",
  },
}
-- Custom toggle that focuses the aerial window
-- Treesitter
local ts_langs = require("parser_languages")

vim.api.nvim_create_autocmd("FileType", {
  pattern = vim.list_extend({ "typescriptreact", "javascriptreact" }, ts_langs),
  callback = function()
    if pcall(vim.treesitter.start) then
      vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
    end
  end,
})

-- Surround
require("mini.surround").setup({
  mappings = {
    add = "sa",          -- keep sa for internal use
    delete = "sd",       -- delete surround
    find = "",           -- disabled (rarely used)
    find_left = "",      -- disabled
    highlight = "",      -- disabled
    replace = "sr",      -- replace surround
    update_n_lines = "", -- disabled
  },
  custom_surroundings = {
    -- Override ( to not add spaces (like Python style)
    ["("] = { output = { left = "(", right = ")" } },
    -- Override [ to not add spaces
    ["["] = { output = { left = "[", right = "]" } },
    -- Override { to not add spaces
    ["{"] = { output = { left = "{", right = "}" } },
  },
})

-- Conform
require("conform").setup({
  formatters_by_ft = {
    rust = { "rustfmt" },
    javascript = { "prettier" },
    typescript = { "prettier" },
    cpp = { "clang-format" },
    c = { "clang-format" },
    lua = { "stylua" },
    css = { "prettier" },
    python = { "black" }, -- added
  },
  format_on_save = { timeout_ms = 200, lsp_format = "fallback" },
})

-- CMP
require("cmp").setup({
  sources = { { name = "nvim_lsp" } },
  mapping = {
    ["<CR>"] = require("cmp").mapping.confirm({ select = true }),
    ["<Tab>"] = require("cmp").mapping.confirm({ select = true }),
    ["<Down>"] = require("cmp").mapping.select_next_item(),
    ["<Up>"] = require("cmp").mapping.select_prev_item(),
  },
})

-- LSP config
local capabilities = require("cmp_nvim_lsp").default_capabilities()
-- LspAttach, not on_attach: lspconfig's rust_analyzer defines its own on_attach which replaces the "*" one
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(ev)
    local b = ev.buf
    vim.lsp.get_client_by_id(ev.data.client_id).server_capabilities.semanticTokensProvider = nil
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, { buffer = b })
    vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { buffer = b })
    vim.keymap.set("n", "gr", vim.lsp.buf.references, { buffer = b })
    vim.keymap.set("n", "K", vim.lsp.buf.hover, { buffer = b })
    -- vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, {buffer=b})
    -- vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, {buffer=b})
  end,
})

vim.lsp.config("*", {
  capabilities = capabilities,
})
vim.lsp.config("rust_analyzer", {
  root_dir = function(b, on_dir)
    local root = vim.fs.root(b, "Cargo.toml")
    if root then
      on_dir(root)
    end
  end,
  handlers = {
    ["$/progress"] = function() end, -- Silence indexing messages
  },
})
vim.lsp.config("lua_ls", {
  root_dir = function(_, on_dir)
    on_dir(vim.fn.getcwd())
  end, -- Prevent LSP from changing directory
  settings = {
    Lua = {
      diagnostics = { globals = { "vim" } }, -- avoid 'vim' undefined
      workspace = { checkThirdParty = false },
    },
  },
})
vim.lsp.enable({ "rust_analyzer", "ts_ls", "clangd", "cssls", "lua_ls", "pyright", "zls" })

require("oil").setup({
  columns = {},
  view_options = {
    show_hidden = true,
    sort = { { "mtime", "desc" } },
  },
  float = {
    padding_top = 8,
    max_width = 0.5,
    border = "none",
    win_options = {
      winblend = 0,
    },
  },
  keymaps = {
    ["g?"] = "actions.show_help",
    ["<CR>"] = "actions.select",
    ["<C-v>"] = "actions.select_vsplit",
    ["<C-x>"] = "actions.select_split",
    ["<C-t>"] = "actions.select_tab",
    ["<C-p>"] = "actions.preview",
    ["<C-c>"] = "actions.close",
    ["<C-l>"] = "actions.refresh",
    ["-"] = "actions.parent",
    ["_"] = "actions.open_cwd",
    ["gs"] = {
      desc = "Cycle sort: newest / name / largest",
      callback = function()
        local presets = {
          { "newest",  { { "mtime", "desc" } } },
          { "name",    { { "type", "asc" }, { "name", "asc" } } },
          { "largest", { { "type", "asc" }, { "size", "desc" } } },
        }
        vim.g.oil_sort = (vim.g.oil_sort or 1) % #presets + 1
        local p = presets[vim.g.oil_sort]
        require("oil").set_sort(p[2])
        vim.notify("oil: sort " .. p[1])
      end,
    },
    ["gS"] = "actions.change_sort",
    ["gx"] = "actions.open_external",
    ["g."] = "actions.toggle_hidden",
    ["g\\"] = "actions.toggle_trash",
  },
})

local pounce = require("pounce")

pounce.setup({
  accept_keys = '~SEATNOIUGH', -- your normal jump keys
  accept_best_key = "<Tab>",   -- main best-match key
  multi_window = true,
  debug = false,
})

-- Extra key to accept best match (comma)
-- Maps ',' to the same action as the main best key
-- TODOPANDA make sure this doesnt fuck shit up
-- vim.keymap.set({ "n", "x" }, ",", "\\", { remap = true, desc = "Pounce accept best" })
-- vim.keymap.set({ "n", "x" }, "<Tab>", "\\", { remap = true, desc = "Pounce accept best" })
-- vim.uv.os_setenv(
--   "RIPGREP_CONFIG_PATH",
--   vim.fn.expand("~/.config/ripgrep/rg.toml")
-- )

-- vim.api.nvim_set_hl(0, "MyPickBg", { bg = "#1e1e2e" })
vim.api.nvim_set_hl(0, "MyPickBorder", { fg = "#89b4fa" })
vim.api.nvim_set_hl(0, "MyPickSel", { bg = "#313244" })
vim.api.nvim_set_hl(0, "MyPickBg", { bg = "NONE", fg = "#ffffff" })                  -- dark bg with white text
vim.api.nvim_set_hl(0, "MyPickPrompt", { fg = "#ff1493", bg = "#1a1a2e", bold = true }) -- bright prompt
-- alt-backspace in pickers: delete the word left of the end, like <C-w> (built-in delete_word takes one key only)
local function pick_delete_word()
  local q = MiniPick.get_picker_query()
  local i = #q
  while i > 0 and q[i] == " " do i = i - 1 end
  local kw = function(c) return vim.fn.match(c, "[[:keyword:]]") >= 0 end
  local ref = i > 0 and kw(q[i])
  while i > 0 and q[i] ~= " " and kw(q[i]) == ref do i = i - 1 end
  MiniPick.set_picker_query(vim.list_slice(q, 1, i))
end

require("mini.pick").setup({
  sources = {
    -- Your existing file picker options
    -- look into .fdignore file global
    files = {
      tool = "fd",
      tool_args = {
        "--hidden",  -- Show hidden files like .env
        "--follow",
        "--no-ignore-vcs",  -- Ignore .gitignore to show .md files
        "--exclude", ".git",
        "--exclude", "Library",
        "--exclude", ".Trash",
        "--exclude", "node_modules",
        "--exclude", ".Spotlight-V100",
        "--exclude", ".DS_Store",
        "--exclude", "System",
      },
    },
    grep_live = {
      tool = "rg",
      tool_args = {
        "--no-heading",
        "--line-number",
        "--column",
        "--smart-case",
        "--hidden",  -- Search in hidden files like .env
        "--no-ignore-vcs",  -- Ignore .gitignore to search .md files
        "--glob", "!.git/*",  -- But exclude .git directory
        -- NOTE: Removed --fixed-strings to enable smart-case regex
        -- Use Ctrl-F in picker to type literal strings if needed
      },
    },
  },
  mappings = {
    move_up = "<C-p>",
    move_down = "<C-n>",
    delete_word_alt = { char = "<M-BS>", func = pick_delete_word },
  },
  window = {
    config = function()
      local min_height = 20
      local min_width = 80
      local height = math.max(min_height, math.floor(vim.o.lines * 0.618))
      -- at least 120 wide (minus a 2 col margin each side on narrow screens), golden ratio once that's wider
      local width = math.min(vim.o.columns - 4, math.max(120, math.floor(vim.o.columns * 0.618)))
      return {
        anchor = "NW",
        height = height,
        width = width,
        row = math.floor((vim.o.lines - height) / 2),
        col = math.floor((vim.o.columns - width) / 2),
        -- no frame; mini.pick keeps a blank top / bottom row for the prompt and footer
        border = "none",
      }
    end,
  },
})

vim.api.nvim_create_autocmd("User", {
  pattern = "MiniPickStart",
  callback = function()
    vim.wo.winhighlight = "Normal:MyPickBg"
    -- Set all Mini.pick specific highlight groups to ensure text visibility
    vim.api.nvim_set_hl(0, "MiniPickBorderText", { fg = "#89b4fa", bg = "NONE" })
    vim.api.nvim_set_hl(0, "MiniPickIconDirectory", { fg = "#89b4fa" })
    vim.api.nvim_set_hl(0, "MiniPickIconFile", { fg = "#89dceb" })
    vim.api.nvim_set_hl(0, "MiniPickHeader", { fg = "#ff1493", bold = true })
    vim.api.nvim_set_hl(0, "MiniPickMatchCurrent", { bg = "#313244" })
    vim.api.nvim_set_hl(0, "MiniPickMatchMarked", { fg = "#f9e2af" })
    vim.api.nvim_set_hl(0, "MiniPickMatchRanges", { fg = "#f38ba8", bold = true })
    vim.api.nvim_set_hl(0, "MiniPickNormal", { fg = "#ffffff", bg = "NONE" })
    vim.api.nvim_set_hl(0, "MiniPickPreviewLine", { bg = "#313244" })
    vim.api.nvim_set_hl(0, "MiniPickPreviewRegion", { fg = "#45475a" })
    vim.api.nvim_set_hl(0, "MiniPickPrompt", { fg = "#ff1493", bg = "NONE", bold = true })

    -- Ensure Enter key works in mini.pick (prevent markdown buffer mappings from interfering)
    vim.keymap.set("i", "<CR>", "<CR>", { buffer = true, noremap = true })
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = "markdown",
  callback = function()
    -- Disable auto-indent to prevent double indentation on newlines
    vim.opt_local.autoindent = false
    vim.opt_local.smartindent = false
    vim.opt_local.indentexpr = ""

    if not vim.g.obsidian_setup and vim.fn.isdirectory(settings.vault) == 1 then
      vim.g.obsidian_setup = true
      require("obsidian").setup({
        workspaces = {
          {
            name = "notes",
            path = settings.vault,
          },
        },
        ui = {
          enable = false,
        },
        mappings = {
          -- Disable all default mappings
        },
      })
    end

    -- Custom 3-level checkbox toggle: [ ] -> [~] -> [x]
    local function toggle_3_level_checkbox()
      local line_num = vim.fn.line(".")
      local line = vim.api.nvim_get_current_line()

      if line:match("^%s*- %[ %]") then
        line = line:gsub("- %[ %]", "- [~]", 1)
      elseif line:match("^%s*- %[~%]") then
        line = line:gsub("- %[~%]", "- [x]", 1)
      elseif line:match("^%s*- %[x%]") then
        line = line:gsub("- %[x%]", "- [ ]", 1)
      elseif line:match("^%s*- ") then
        -- Convert regular list item to checkbox
        line = line:gsub("^(%s*- )", "%1[ ] ", 1)
      else
        -- Not a list, add checkbox
        line = line:gsub("^(%s*)", "%1- [ ] ", 1)
      end

      vim.api.nvim_set_current_line(line)
    end

    -- Map Enter to toggle checkbox (normal mode)
    vim.keymap.set("n", "<CR>", toggle_3_level_checkbox, {
      buffer = true,
      desc = "Toggle 3-level checkbox",
    })

    -- Also override the default <leader>ch mapping
    vim.keymap.set("n", "<leader>ch", toggle_3_level_checkbox, {
      buffer = true,
      desc = "Toggle 3-level checkbox",
    })

    -- Insert mode: Enter creates new line with same list indentation
    -- Handles nested lists by preserving indent up to the list marker only
    vim.keymap.set("i", "<CR>", function()
      local line = vim.api.nvim_get_current_line()

      -- Match checkbox patterns: spaces + "- [x]", "- [~]", or "- [ ]"
      local checkbox_indent, checkbox_state = line:match("^(%s*)%- %[([x~%s])%]")
      if checkbox_indent then
        -- Continue with empty checkbox at same level
        return "<CR>" .. checkbox_indent .. "- [ ] "
      end

      -- Match list item pattern: spaces + "- " + optional content
      local list_indent = line:match("^(%s*)%- ")
      if list_indent then
        -- Continue list at same level
        return "<CR>" .. list_indent .. "- "
      end

      -- Match numbered list: spaces + number + ". "
      local num_indent = line:match("^(%s*)%d+%.%s")
      if num_indent then
        return "<CR>" .. num_indent .. "1. "
      end

      -- Non-list line: preserve full indentation
      local indent = line:match("^%s*")
      return "<CR>" .. indent
    end, {
      buffer = true,
      expr = true,
      desc = "New line with same indentation",
    })
  end,
})

require("zen-mode").setup({
  window = {
    width = 111,
    options = {
      number = false,
      relativenumber = false,
      signcolumn = "no",
      cursorcolumn = false,
    },
  },
  plugins = {
    options = {
      enabled = true,
      laststatus = 3,
      showcmd = false,
    },
    kitty = {
      enabled = true,
      font = "+4",
    },
  },
})


-- vim.keymap.set("n", "<leader>z", "<cmd>lua toggle_zen()<CR>", { noremap = true, silent = true })

vim.api.nvim_create_autocmd("BufWinEnter", {
  callback = function()
    if vim.g.zen_active then
      local win = vim.api.nvim_get_current_win()
      vim.wo[win].number = false
      vim.wo[win].relativenumber = false
      vim.wo[win].signcolumn = "no"
      vim.wo[win].cursorline = false
    end
  end,
})
-- Define highlight group for the register char: white text on red background
vim.api.nvim_set_hl(0, "LualineRecordingReg", {
  fg = "#F2F4F4", -- white/light text
  bg = "#D44D36", -- red background
  bold = true,
})

-- Define highlight group for the rest: black text on red background
vim.api.nvim_set_hl(0, "LualineRecordingRest", {
  fg = "#222222", -- black text
  bg = "#D44D36",
  bold = false,
})

local function macro_status()
  local rec = vim.fn.reg_recording()
  if rec ~= "" then
    -- Format: <REGISTER>_REC with colors inverted from before
    return "%#LualineRecordingReg#" .. rec .. "%#LualineRecordingRest#_REC%*"
  else
    return ""
  end
end
-- open buffer count after the filename; color = save state: both > current unsaved > another unsaved > all saved
local function buf_state()
  local n, others = 0, false
  local cur = vim.api.nvim_get_current_buf()
  for _, b in ipairs(vim.api.nvim_list_bufs()) do
    if vim.bo[b].buflisted then
      n = n + 1
      if b ~= cur and vim.bo[b].modified then
        others = true
      end
    end
  end
  local mine = vim.bo[cur].modified
  local state = (mine and others and "both") or (mine and "cur") or (others and "other") or "clean"
  return n, state
end
local buf_colors = {
  both = { fg = "#32cd32", bg = "#ff1493", gui = "bold" }, -- this and another unsaved (green on insert pink)
  cur = { fg = "#32cd32", gui = "bold" },                  -- this buffer unsaved (normal-mode green)
  other = { fg = "#ff2a6d", gui = "bold" },                -- another buffer unsaved (hot pink-red)
  clean = { fg = "#83A5C5", gui = "bold" },                -- everything saved
}
-- text runs before color each draw, so color reuses the state the text just computed
local buf_last = "clean"
local buf_count = {
  function()
    local n, state = buf_state()
    buf_last = state
    return " " .. n .. " "
  end,
  color = function() return buf_colors[buf_last] end,
  padding = 0,
}

require("lualine").setup({
  options = {
    icons_enabled = true,
    theme = {
      -- mode text only, no bg; matches the cursor: green normal, pink insert, periwinkle visual
      normal = {
        a = { bg = "NONE", fg = "#32cd32", gui = "bold" },
        b = { bg = "NONE", fg = "#f8f8f2" }, -- Custom background for diagnostics
        c = { bg = "NONE", fg = "#f8f8f2" }, -- Custom background for filename
      },
      insert = { a = { bg = "NONE", fg = "#ff1493", gui = "bold" } },
      visual = { a = { bg = "NONE", fg = "#b4a7f5", gui = "bold" } },
      replace = { a = { bg = "NONE", fg = "#D44D36", gui = "bold" } },
      command = { a = { bg = "NONE", fg = "#83A5C5" } },
      inactive = {
        a = { bg = "NONE", fg = "#d8d8d2" },
        b = { bg = "NONE", fg = "#d8d8d2" },
        c = { bg = "NONE", fg = "#d8d8d2" },
      },
    },
    component_separators = { left = "", right = "" },
    section_separators = { left = "", right = "" },
    disabled_filetypes = { statusline = {}, winbar = {} },
    ignore_focus = {},
    always_divide_middle = true,
    always_show_tabline = true,
    globalstatus = false,
    refresh = { statusline = 100, tabline = 100, winbar = 100 },
  },
  sections = {
    lualine_a = { "mode" },
    lualine_b = { "diagnostics" },
    lualine_c = { { "filename", file_status = false }, buf_count },
    lualine_x = { "progress" },
    lualine_y = { "workspace" },
    lualine_z = {
      macro_status },
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = { "filename" },
    lualine_x = { "location" },
    lualine_y = {},
    lualine_z = { macro_status },
  },
  tabline = {},
  winbar = {},
  inactive_winbar = {},
  extensions = {},
})
