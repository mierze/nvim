---------------------------
------C-O-L-O-R-S----------
---------------------------
-- Color palette organized by specific usage
-- Each variable is used exactly once
-- Edit hex values to customize your theme

local c = {
  -- ============================================
  -- EDITOR UI - BACKGROUNDS
  -- ============================================
  editor_bg = "NONE",
  -- float_bg = "#181825",
  inactive_window_bg = "NONE",

  cursorline_bg = "#141c17",
  cursorcolumn_bg = "#313244",
  colorcolumn_bg = "#313244",

  statusline_bg = "#181825",
  statusline_inactive_fg = "#45475a",
  statusline_inactive_bg = "#181825",

  tabline_inactive_fg = "#45475a",
  tabline_fill_bg = "#181825",
  tabline_selected_fg = "#cdd6f4",
  tabline_selected_bg = "#313244",

  pmenu_bg = "#313244",
  pmenu_selected_fg = "#101018",
  pmenu_selected_bg = "#a6a3a1",
  pmenu_scrollbar_bg = "#45475a",
  pmenu_thumb_bg = "#6c7086",

  visual_selection_bg = "#ff1493",
  visual_selection_fg = "#000000",
  visual_nos_bg = "#ff1493",

  fold_bg = "#313244",
  foldcolumn_bg = "NONE",

  signcolumn_fg = "#45475a",
  signcolumn_bg = "NONE",

  -- ============================================
  -- EDITOR UI - BORDERS & SPLITS
  -- ============================================
  vertsplit_fg = "#11111b",
  winseparator_fg = "#11111b",

  telescope_border = "#89b4fa",
  telescope_prompt_border = "#89b4fa",
  telescope_results_border = "#89b4fa",
  telescope_preview_border = "#89b4fa",

  -- ============================================
  -- EDITOR UI - TEXT & FOREGROUND
  -- ============================================
  editor_fg = "#bdb6b4",
  float_fg = "#cdd6f4",
  inactive_window_fg = "#cdd6f4",

  cursor_fg = "#000000",
  cursor_bg = "#ff1493",

  statusline_fg = "#cdd6f4",

  modemsg_fg = "#cdd6f4",

  telescope_selection_fg = "#cdd6f4",
  telescope_selection_bg = "#313244",

  nvimtree_fg = "#cdd6f4",
  nvimtree_bg = "#181825",

  -- ============================================
  -- EDITOR UI - LINE NUMBERS
  -- ============================================
  linenr_fg = "#7f849c",
  cursorlinenr_fg = "#a4ee0e",
  linenr_above_fg = "#6c7086",
  linenr_below_fg = "#6c7086",

  -- ============================================
  -- SEARCH & HIGHLIGHT
  -- ============================================
  search_fg = "#101018",
  search_bg = "#09e2af",
  incsearch_fg = "#101018",
  incsearch_bg = "#5ded7a",
  cursearch_fg = "#101018",
  cursearch_bg = "#f38ba8",

  matchparen_fg = "#ff1493",
  matchparen_bg = "#000000",

  telescope_matching = "#89b4fa",

  -- ============================================
  -- MESSAGES & ALERTS
  -- ============================================
  error_msg = "#f38ba8",
  warning_msg = "#09e2af",
  info_msg = "#89b4fa",
  question_msg = "#89b4fa",

  -- ============================================
  -- DIFF COLORS
  -- ============================================
  diff_add_bg = "#a6a3a1",
  diff_add_fg = "#101018",
  diff_change_bg = "#09e2af",
  diff_change_fg = "#101018",
  diff_delete_bg = "#f38ba8",
  diff_delete_fg = "#101018",
  diff_text_bg = "#89b4fa",
  diff_text_fg = "#101018",

  gitsigns_add = "#a6a3a1",
  gitsigns_change = "#09e2af",
  gitsigns_delete = "#f38ba8",

  -- ============================================
  -- SPELL CHECKING
  -- ============================================
  spell_bad = "#f38ba8",
  spell_cap = "#09e2af",
  spell_local = "#89b4fa",
  spell_rare = "#a6a3a1",

  -- ============================================
  -- SYNTAX - COMMENTS
  -- ============================================
  comment = "#6c7086",
  comment_special = "#6c7086",
  ts_comment = "#6c7086",
  comment_error_fg = "#101018",
  comment_error_bg = "#f38ba8",
  comment_warning_fg = "#101018",
  comment_warning_bg = "#09e2af",
  comment_note_fg = "#101018",
  comment_note_bg = "#89b4fa",
  comment_todo_fg = "#101018",
  comment_todo_bg = "#09e2af",
  todo_fg = "#101018",
  todo_bg = "#09e2af",

  -- ============================================
  -- SYNTAX - CONSTANTS & LITERALS
  -- ============================================
  constant = "#5ded7a",
  number = "#5ded7a",
  boolean = "#5ded7a",
  float = "#5ded7a",
  ts_constant = "#5ded7a",
  ts_constant_builtin = "#5ded7a",
  ts_number = "#5ded7a",
  ts_boolean = "#5ded7a",
  ts_float = "#5ded7a",
  label = "#5ded7a",
  debug = "#5ded7a",
  ts_function_builtin = "#5ded7a",
  ts_string_regex = "#5ded7a",
  rainbow_orange = "#5ded7a",

  -- ============================================
  -- SYNTAX - STRINGS & CHARACTERS
  -- ============================================
  string = "#a6a3a1",
  ts_string = "#a6a3a1",
  character = "#94e2d5",
  ts_character = "#94e2d5",

  -- ============================================
  -- SYNTAX - FUNCTIONS & METHODS
  -- ============================================
  function_name = "#7dd3fc",
  ts_function = "#7dd3fc",
  ts_function_method = "#7dd3fc",
  lsp_function = "#7dd3fc",
  lsp_method = "#7dd3fc",
  fold_fg = "#89b4fa",
  foldcolumn_fg = "#6c7086",
  nvimtree_folder = "#89b4fa",
  nvimtree_folder_icon = "#89b4fa",
  nvimtree_folder_opened = "#89b4fa",

  -- ============================================
  -- SYNTAX - KEYWORDS & STATEMENTS
  -- ============================================
  keyword = "#8b26c7",
  statement = "#8b26c7",
  conditional = "#8b26c7",
  repeat_kw = "#8b26c7",
  exception = "#8b26c7",
  ts_keyword = "#8b26c7",
  ts_keyword_function = "#8b26c7",
  ts_keyword_return = "#8b26c7",
  ts_keyword_operator = "#8b26c7",
  ts_conditional = "#8b26c7",
  ts_repeat = "#8b26c7",
  ts_exception = "#8b26c7",
  ts_constant_macro = "#8b26c7",
  ts_function_macro = "#8b26c7",
  ts_attribute = "#3dd9e8",
  ts_type_qualifier = "#8b26c7",
  tag = "#8b26c7",
  ts_tag = "#8b26c7",
  lsp_decorator = "#8b26c7",
  lsp_macro = "#8b26c7",
  rainbow_violet = "#8b26c7",

  -- ============================================
  -- SYNTAX - TYPES
  -- ============================================
  type = "#09e2af",
  storage_class = "#09e2af",
  structure = "#09e2af",
  typedef = "#09e2af",
  ts_type = "#09e2af",
  ts_type_builtin = "#09e2af",
  ts_type_definition = "#09e2af",
  lsp_class = "#09e2af",
  lsp_enum = "#09e2af",
  lsp_interface = "#09e2af",
  lsp_struct = "#09e2af",
  lsp_type = "#09e2af",
  lsp_type_parameter = "#09e2af",
  rainbow_yellow = "#09e2af",

  -- ============================================
  -- SYNTAX - SPECIAL & PREPROCESSOR
  -- ============================================
  special = "#e54287",
  special_char = "#e54287",
  preprocessor = "#e54287",
  include = "#e54287",
  define = "#e54287",
  macro = "#e54287",
  precondit = "#e54287",
  ts_string_escape = "#e54287",
  nvimtree_root = "#e54287",
  rainbow_pink = "#e54287",

  -- ============================================
  -- SYNTAX - OPERATORS & LINKS
  -- ============================================
  operator = "#49ece0",
  ts_operator = "#89dceb",
  ts_punctuation_special = "#89dceb",
  ts_tag_delimiter = "#89dceb",
  rainbow_cyan = "#89dceb",

  -- ============================================
  -- SYNTAX - IDENTIFIERS & PROPERTIES
  -- ============================================
  identifier = "#02cdcd",
  telescope_caret = "#02cdcd",
  nvimtree_special_file = "#02cdcd",

  -- ============================================
  -- SYNTAX - VARIABLES & PARAMETERS
  -- ============================================
  ts_variable = "#cdd6f4",
  lsp_variable = "#cdd6f4",

  variable_builtin = "#5ded7a",
  ts_variable_builtin = "#5ded7a",

  variable_parameter = "#5a6b5e",
  ts_variable_parameter = "#5a6b5e",
  lsp_parameter = "#5a6b5e",

  -- ============================================
  -- SYNTAX - ACCENTS & MODULES
  -- ============================================
  variable_member = "#a4ee0e",
  ts_variable_member = "#a4ee0e",
  ts_module = "#a4ee0e",
  ts_property = "#a4ee0e",
  lsp_namespace = "#a4ee0e",
  lsp_property = "#a4ee0e",

  -- ============================================
  -- SYNTAX - CONSTRUCTORS & HINTS
  -- ============================================
  constructor = "#08d7fc",
  ts_constructor = "#74c7ec",
  ts_label = "#74c7ec",

  -- ============================================
  -- SYNTAX - SUCCESS & ENUMS
  -- ============================================
  tag_attribute = "#94e2d5",
  ts_tag_attribute = "#94e2d5",
  lsp_enum_member = "#94e2d5",
  diagnostic_hint = "#94e2d5",
  diagnostic_hint_underline = "#94e2d5",

  -- ============================================
  -- SYNTAX - DELIMITERS & PUNCTUATION
  -- ============================================
  delimiter = "#9399b2",
  ts_punctuation_delimiter = "#9399b2",
  ts_punctuation_bracket = "#9399b2",

  -- ============================================
  -- SYNTAX - MISC
  -- ============================================
  ignore = "#6c7086",
  error_syntax = "#f38ba8",

  -- ============================================
  -- DIAGNOSTICS
  -- ============================================
  diagnostic_error = "#f38ba8",
  diagnostic_error_underline = "#f38ba8",

  diagnostic_warn = "#09e2af",
  diagnostic_warn_underline = "#09e2af",

  diagnostic_info = "#89b4fa",
  diagnostic_info_underline = "#89b4fa",

  -- ============================================
  -- RAINBOW DELIMITERS
  -- ============================================
  rainbow_red = "#f38ba8",
  rainbow_blue = "#89b4fa",
  rainbow_green = "#a6a3a1",

  -- ============================================
  -- MARKDOWN - murky sea/forest with purple
  -- ============================================
  markdown_h1 = "#e84408",            -- forest green
  markdown_h2 = "#8a7f2e",            -- sea blue
  markdown_h3 = "#a4ee0e",            -- yellowish green
  markdown_h4 = "#42e070",            -- cyan
  markdown_h5 = "#412c55",            -- purple
  markdown_h6 = "#6c8a7d",            -- muted teal

  markdown_italic = "#29e2bf",        -- bright sea green
  markdown_bold = "#f9fcfb",          -- light cyan
  markdown_bold_italic = "#74c7ec",   -- soft cyan

  markdown_code = "#5a7c6f",          -- murky forest
  markdown_code_block = "#445f57",    -- darker murky

  markdown_link = "#4da6a6",          -- sea teal
  markdown_link_label = "#89b4fa",    -- light blue
  markdown_url = "#5a9eb0",           -- ocean blue

  markdown_plain_text = "#6c7086",    -- darker gray
  markdown_list_marker = "#585b70",   -- even darker gray
  markdown_quote = "#6c7086",         -- muted gray
  markdown_rule = "#45475a",          -- dark divider

  markdown_raw = "#8b7da6",           -- purple mist
  markdown_raw_delimiter = "#6c6086", -- darker purple mist

  -- ============================================
  -- DEPRECATED (unused but kept for reference)
  -- ============================================
}

-- ============================================
-- APPLY HIGHLIGHTS
-- ============================================

-- Core UI
vim.api.nvim_set_hl(0, "Normal", { fg = c.editor_fg, bg = c.editor_bg })
vim.api.nvim_set_hl(0, "NormalFloat", { fg = c.float_fg, bg = c.float_bg })
vim.api.nvim_set_hl(0, "NormalNC", { fg = c.inactive_window_fg, bg = c.inactive_window_bg })

-- Cursor
vim.api.nvim_set_hl(0, "Cursor", { fg = c.cursor_fg, bg = c.cursor_bg })
vim.api.nvim_set_hl(0, "lCursor", { fg = c.cursor_fg, bg = c.cursor_bg })
vim.api.nvim_set_hl(0, "CursorIM", { fg = c.cursor_fg, bg = c.cursor_bg })
vim.api.nvim_set_hl(0, "TermCursor", { fg = c.cursor_fg, bg = c.cursor_bg })
vim.api.nvim_set_hl(0, "vCursor", { fg = "#000000", bg = "#ff1493" })
vim.api.nvim_set_hl(0, "CursorLine", { bg = c.cursorline_bg })
vim.api.nvim_set_hl(0, "CursorColumn", { bg = c.cursorcolumn_bg })

-- Line numbers
vim.api.nvim_set_hl(0, "LineNr", { fg = c.linenr_fg })
vim.api.nvim_set_hl(0, "CursorLineNr", { fg = c.cursorlinenr_fg, bold = true })
vim.api.nvim_set_hl(0, "LineNrAbove", { fg = c.linenr_above_fg })
vim.api.nvim_set_hl(0, "LineNrBelow", { fg = c.linenr_below_fg })

-- Columns and splits
vim.api.nvim_set_hl(0, "ColorColumn", { bg = c.colorcolumn_bg })
vim.api.nvim_set_hl(0, "VertSplit", { fg = c.vertsplit_fg })
vim.api.nvim_set_hl(0, "WinSeparator", { fg = c.winseparator_fg })

-- Folds
vim.api.nvim_set_hl(0, "Folded", { fg = c.fold_fg, bg = c.fold_bg })
vim.api.nvim_set_hl(0, "FoldColumn", { fg = c.foldcolumn_fg, bg = c.foldcolumn_bg })

-- Sign column
vim.api.nvim_set_hl(0, "SignColumn", { fg = c.signcolumn_fg, bg = c.signcolumn_bg })

-- Status line
vim.api.nvim_set_hl(0, "StatusLine", { fg = c.statusline_fg, bg = c.statusline_bg })
vim.api.nvim_set_hl(0, "StatusLineNC", { fg = c.statusline_inactive_fg, bg = c.statusline_inactive_bg })

-- Tab line
vim.api.nvim_set_hl(0, "TabLine", { fg = c.tabline_inactive_fg, bg = c.tabline_fill_bg })
vim.api.nvim_set_hl(0, "TabLineFill", { bg = c.tabline_fill_bg })
vim.api.nvim_set_hl(0, "TabLineSel", { fg = c.tabline_selected_fg, bg = c.tabline_selected_bg })

-- Popup menu (completion)
vim.api.nvim_set_hl(0, "Pmenu", { fg = c.editor_fg, bg = c.pmenu_bg })
vim.api.nvim_set_hl(0, "PmenuSel", { fg = c.pmenu_selected_fg, bg = c.pmenu_selected_bg, bold = true })
vim.api.nvim_set_hl(0, "PmenuSbar", { bg = c.pmenu_scrollbar_bg })
vim.api.nvim_set_hl(0, "PmenuThumb", { bg = c.pmenu_thumb_bg })

-- Search
vim.api.nvim_set_hl(0, "Search", { fg = c.search_fg, bg = c.search_bg })
vim.api.nvim_set_hl(0, "IncSearch", { fg = c.incsearch_fg, bg = c.incsearch_bg })
vim.api.nvim_set_hl(0, "CurSearch", { fg = c.cursearch_fg, bg = c.cursearch_bg })

-- Matching parentheses
vim.api.nvim_set_hl(0, "MatchParen", { fg = c.matchparen_fg, bg = c.matchparen_bg, bold = true })

-- Visual selection
vim.api.nvim_set_hl(0, "Visual", { fg = c.visual_selection_fg, bg = c.visual_selection_bg, bold = true })
vim.api.nvim_set_hl(0, "VisualNOS", { fg = c.visual_selection_fg, bg = c.visual_nos_bg })

-- Messages
vim.api.nvim_set_hl(0, "ErrorMsg", { fg = c.error_msg, bold = true })
vim.api.nvim_set_hl(0, "WarningMsg", { fg = c.warning_msg, bold = true })
vim.api.nvim_set_hl(0, "ModeMsg", { fg = c.modemsg_fg, bold = true })
vim.api.nvim_set_hl(0, "MoreMsg", { fg = c.info_msg })
vim.api.nvim_set_hl(0, "Question", { fg = c.question_msg })

-- Diff colors
vim.api.nvim_set_hl(0, "DiffAdd", { bg = c.diff_add_bg, fg = c.diff_add_fg })
vim.api.nvim_set_hl(0, "DiffChange", { bg = c.diff_change_bg, fg = c.diff_change_fg })
vim.api.nvim_set_hl(0, "DiffDelete", { bg = c.diff_delete_bg, fg = c.diff_delete_fg })
vim.api.nvim_set_hl(0, "DiffText", { bg = c.diff_text_bg, fg = c.diff_text_fg })

-- Spell checking
vim.api.nvim_set_hl(0, "SpellBad", { sp = c.spell_bad, undercurl = true })
vim.api.nvim_set_hl(0, "SpellCap", { sp = c.spell_cap, undercurl = true })
vim.api.nvim_set_hl(0, "SpellLocal", { sp = c.spell_local, undercurl = true })
vim.api.nvim_set_hl(0, "SpellRare", { sp = c.spell_rare, undercurl = true })

-- Syntax highlighting
vim.api.nvim_set_hl(0, "Comment", { fg = c.comment, italic = true })

vim.api.nvim_set_hl(0, "Constant", { fg = c.constant })
vim.api.nvim_set_hl(0, "String", { fg = c.string })
vim.api.nvim_set_hl(0, "Character", { fg = c.character })
vim.api.nvim_set_hl(0, "Number", { fg = c.number })
vim.api.nvim_set_hl(0, "Boolean", { fg = c.boolean })
vim.api.nvim_set_hl(0, "Float", { fg = c.float })

vim.api.nvim_set_hl(0, "Identifier", { fg = c.identifier })
vim.api.nvim_set_hl(0, "Function", { fg = c.function_name })

vim.api.nvim_set_hl(0, "Statement", { fg = c.statement })
vim.api.nvim_set_hl(0, "Conditional", { fg = c.conditional })
vim.api.nvim_set_hl(0, "Repeat", { fg = c.repeat_kw })
vim.api.nvim_set_hl(0, "Label", { fg = c.label })
vim.api.nvim_set_hl(0, "Operator", { fg = c.operator })
vim.api.nvim_set_hl(0, "Keyword", { fg = c.keyword })
vim.api.nvim_set_hl(0, "Exception", { fg = c.exception })

vim.api.nvim_set_hl(0, "PreProc", { fg = c.preprocessor })
vim.api.nvim_set_hl(0, "Include", { fg = c.include })
vim.api.nvim_set_hl(0, "Define", { fg = c.define })
vim.api.nvim_set_hl(0, "Macro", { fg = c.macro })
vim.api.nvim_set_hl(0, "PreCondit", { fg = c.precondit })

vim.api.nvim_set_hl(0, "Type", { fg = c.type })
vim.api.nvim_set_hl(0, "StorageClass", { fg = c.storage_class })
vim.api.nvim_set_hl(0, "Structure", { fg = c.structure })
vim.api.nvim_set_hl(0, "Typedef", { fg = c.typedef })

vim.api.nvim_set_hl(0, "Special", { fg = c.special })
vim.api.nvim_set_hl(0, "SpecialChar", { fg = c.special_char })
vim.api.nvim_set_hl(0, "Tag", { fg = c.tag })
vim.api.nvim_set_hl(0, "Delimiter", { fg = c.delimiter })
vim.api.nvim_set_hl(0, "SpecialComment", { fg = c.comment_special })
vim.api.nvim_set_hl(0, "Debug", { fg = c.debug })

vim.api.nvim_set_hl(0, "Underlined", { underline = true })
vim.api.nvim_set_hl(0, "Ignore", { fg = c.ignore })
vim.api.nvim_set_hl(0, "Error", { fg = c.error_syntax })
vim.api.nvim_set_hl(0, "Todo", { fg = c.todo_fg, bg = c.todo_bg, bold = true })

-- Treesitter highlights
vim.api.nvim_set_hl(0, "@variable", { fg = c.ts_variable })
vim.api.nvim_set_hl(0, "@variable.builtin", { fg = c.ts_variable_builtin })
vim.api.nvim_set_hl(0, "@variable.parameter", { fg = c.ts_variable_parameter })
vim.api.nvim_set_hl(0, "@variable.member", { fg = c.ts_variable_member })

vim.api.nvim_set_hl(0, "@constant", { fg = c.ts_constant })
vim.api.nvim_set_hl(0, "@constant.builtin", { fg = c.ts_constant_builtin })
vim.api.nvim_set_hl(0, "@constant.macro", { fg = c.ts_constant_macro })

vim.api.nvim_set_hl(0, "@module", { fg = c.ts_module })
vim.api.nvim_set_hl(0, "@label", { fg = c.ts_label })

vim.api.nvim_set_hl(0, "@string", { fg = c.ts_string })
vim.api.nvim_set_hl(0, "@string.regex", { fg = c.ts_string_regex })
vim.api.nvim_set_hl(0, "@string.escape", { fg = c.ts_string_escape })

vim.api.nvim_set_hl(0, "@character", { fg = c.ts_character })
vim.api.nvim_set_hl(0, "@number", { fg = c.ts_number })
vim.api.nvim_set_hl(0, "@boolean", { fg = c.ts_boolean })
vim.api.nvim_set_hl(0, "@float", { fg = c.ts_float })

vim.api.nvim_set_hl(0, "@function", { fg = c.ts_function })
vim.api.nvim_set_hl(0, "@function.builtin", { fg = c.ts_function_builtin })
vim.api.nvim_set_hl(0, "@function.macro", { fg = c.ts_function_macro })
vim.api.nvim_set_hl(0, "@function.method", { fg = c.ts_function_method })

vim.api.nvim_set_hl(0, "@constructor", { fg = c.ts_constructor })
vim.api.nvim_set_hl(0, "@operator", { fg = c.ts_operator })

vim.api.nvim_set_hl(0, "@keyword", { fg = c.ts_keyword })
vim.api.nvim_set_hl(0, "@keyword.function", { fg = c.ts_keyword_function })
vim.api.nvim_set_hl(0, "@keyword.return", { fg = c.ts_keyword_return })
vim.api.nvim_set_hl(0, "@keyword.operator", { fg = c.ts_keyword_operator })

vim.api.nvim_set_hl(0, "@conditional", { fg = c.ts_conditional })
vim.api.nvim_set_hl(0, "@repeat", { fg = c.ts_repeat })
vim.api.nvim_set_hl(0, "@exception", { fg = c.ts_exception })

vim.api.nvim_set_hl(0, "@type", { fg = c.ts_type })
vim.api.nvim_set_hl(0, "@type.builtin", { fg = c.ts_type_builtin })
vim.api.nvim_set_hl(0, "@type.definition", { fg = c.ts_type_definition })
vim.api.nvim_set_hl(0, "@type.qualifier", { fg = c.ts_type_qualifier })

vim.api.nvim_set_hl(0, "@attribute", { fg = c.ts_attribute })
vim.api.nvim_set_hl(0, "@property", { fg = c.ts_property })

vim.api.nvim_set_hl(0, "@comment", { fg = c.ts_comment, italic = true })
vim.api.nvim_set_hl(0, "@comment.error", { fg = c.comment_error_fg, bg = c.comment_error_bg })
vim.api.nvim_set_hl(0, "@comment.warning", { fg = c.comment_warning_fg, bg = c.comment_warning_bg })
vim.api.nvim_set_hl(0, "@comment.note", { fg = c.comment_note_fg, bg = c.comment_note_bg })
vim.api.nvim_set_hl(0, "@comment.todo", { fg = c.comment_todo_fg, bg = c.comment_todo_bg })

vim.api.nvim_set_hl(0, "@punctuation.delimiter", { fg = c.ts_punctuation_delimiter })
vim.api.nvim_set_hl(0, "@punctuation.bracket", { fg = c.ts_punctuation_bracket })
vim.api.nvim_set_hl(0, "@punctuation.special", { fg = c.ts_punctuation_special })

vim.api.nvim_set_hl(0, "@tag", { fg = c.ts_tag })
vim.api.nvim_set_hl(0, "@tag.attribute", { fg = c.ts_tag_attribute })
vim.api.nvim_set_hl(0, "@tag.delimiter", { fg = c.ts_tag_delimiter })

-- LSP semantic tokens
vim.api.nvim_set_hl(0, "@lsp.type.class", { fg = c.lsp_class })
vim.api.nvim_set_hl(0, "@lsp.type.decorator", { fg = c.lsp_decorator })
vim.api.nvim_set_hl(0, "@lsp.type.enum", { fg = c.lsp_enum })
vim.api.nvim_set_hl(0, "@lsp.type.enumMember", { fg = c.lsp_enum_member })
vim.api.nvim_set_hl(0, "@lsp.type.function", { fg = c.lsp_function })
vim.api.nvim_set_hl(0, "@lsp.type.interface", { fg = c.lsp_interface })
vim.api.nvim_set_hl(0, "@lsp.type.macro", { fg = c.lsp_macro })
vim.api.nvim_set_hl(0, "@lsp.type.method", { fg = c.lsp_method })
vim.api.nvim_set_hl(0, "@lsp.type.namespace", { fg = c.lsp_namespace })
vim.api.nvim_set_hl(0, "@lsp.type.parameter", { fg = c.lsp_parameter })
vim.api.nvim_set_hl(0, "@lsp.type.property", { fg = c.lsp_property })
vim.api.nvim_set_hl(0, "@lsp.type.struct", { fg = c.lsp_struct })
vim.api.nvim_set_hl(0, "@lsp.type.type", { fg = c.lsp_type })
vim.api.nvim_set_hl(0, "@lsp.type.typeParameter", { fg = c.lsp_type_parameter })
vim.api.nvim_set_hl(0, "@lsp.type.variable", { fg = c.lsp_variable })

-- Diagnostics
vim.api.nvim_set_hl(0, "DiagnosticError", { fg = c.diagnostic_error })
vim.api.nvim_set_hl(0, "DiagnosticWarn", { fg = c.diagnostic_warn })
vim.api.nvim_set_hl(0, "DiagnosticInfo", { fg = c.diagnostic_info })
vim.api.nvim_set_hl(0, "DiagnosticHint", { fg = c.diagnostic_hint })

vim.api.nvim_set_hl(0, "DiagnosticUnderlineError", { sp = c.diagnostic_error_underline, undercurl = true })
vim.api.nvim_set_hl(0, "DiagnosticUnderlineWarn", { sp = c.diagnostic_warn_underline, undercurl = true })
vim.api.nvim_set_hl(0, "DiagnosticUnderlineInfo", { sp = c.diagnostic_info_underline, undercurl = true })
vim.api.nvim_set_hl(0, "DiagnosticUnderlineHint", { sp = c.diagnostic_hint_underline, undercurl = true })

-- Git signs
vim.api.nvim_set_hl(0, "GitSignsAdd", { fg = c.gitsigns_add })
vim.api.nvim_set_hl(0, "GitSignsChange", { fg = c.gitsigns_change })
vim.api.nvim_set_hl(0, "GitSignsDelete", { fg = c.gitsigns_delete })

-- Telescope
vim.api.nvim_set_hl(0, "TelescopeBorder", { fg = c.telescope_border })
vim.api.nvim_set_hl(0, "TelescopePromptBorder", { fg = c.telescope_prompt_border })
vim.api.nvim_set_hl(0, "TelescopeResultsBorder", { fg = c.telescope_results_border })
vim.api.nvim_set_hl(0, "TelescopePreviewBorder", { fg = c.telescope_preview_border })
vim.api.nvim_set_hl(0, "TelescopeSelection",
  { fg = c.telescope_selection_fg, bg = c.telescope_selection_bg, bold = true })
vim.api.nvim_set_hl(0, "TelescopeSelectionCaret", { fg = c.telescope_caret })
vim.api.nvim_set_hl(0, "TelescopeMatching", { fg = c.telescope_matching })

-- NvimTree / File explorers
vim.api.nvim_set_hl(0, "NvimTreeFolderName", { fg = c.nvimtree_folder })
vim.api.nvim_set_hl(0, "NvimTreeFolderIcon", { fg = c.nvimtree_folder_icon })
vim.api.nvim_set_hl(0, "NvimTreeNormal", { fg = c.nvimtree_fg, bg = c.nvimtree_bg })
vim.api.nvim_set_hl(0, "NvimTreeOpenedFolderName", { fg = c.nvimtree_folder_opened })
vim.api.nvim_set_hl(0, "NvimTreeRootFolder", { fg = c.nvimtree_root, bold = true })
vim.api.nvim_set_hl(0, "NvimTreeSpecialFile", { fg = c.nvimtree_special_file })

-- Rainbow delimiters
vim.api.nvim_set_hl(0, "RainbowDelimiterRed", { fg = c.rainbow_red })
vim.api.nvim_set_hl(0, "RainbowDelimiterYellow", { fg = c.rainbow_yellow })
vim.api.nvim_set_hl(0, "RainbowDelimiterBlue", { fg = c.rainbow_blue })
vim.api.nvim_set_hl(0, "RainbowDelimiterOrange", { fg = c.rainbow_orange })
vim.api.nvim_set_hl(0, "RainbowDelimiterGreen", { fg = c.rainbow_green })
vim.api.nvim_set_hl(0, "RainbowDelimiterViolet", { fg = c.rainbow_violet })
vim.api.nvim_set_hl(0, "RainbowDelimiterCyan", { fg = c.rainbow_cyan })

-- Markdown
vim.api.nvim_set_hl(0, "@markup.heading.1.markdown", { fg = c.markdown_h1, bold = true })
vim.api.nvim_set_hl(0, "@markup.heading.2.markdown", { fg = c.markdown_h2, bold = true })
vim.api.nvim_set_hl(0, "@markup.heading.3.markdown", { fg = c.markdown_h3, bold = true })
vim.api.nvim_set_hl(0, "@markup.heading.4.markdown", { fg = c.markdown_h4, bold = true })
vim.api.nvim_set_hl(0, "@markup.heading.5.markdown", { fg = c.markdown_h5, bold = true })
vim.api.nvim_set_hl(0, "@markup.heading.6.markdown", { fg = c.markdown_h6, bold = true })

vim.api.nvim_set_hl(0, "@markup.strong", { fg = c.markdown_bold, bold = true })
vim.api.nvim_set_hl(0, "@markup.italic", { fg = c.markdown_italic, italic = true })
vim.api.nvim_set_hl(0, "@markup.strikethrough", { fg = c.comment, strikethrough = true })

vim.api.nvim_set_hl(0, "@markup.raw", { fg = c.markdown_raw })
vim.api.nvim_set_hl(0, "@markup.raw.delimiter", { fg = c.markdown_raw_delimiter })
vim.api.nvim_set_hl(0, "@markup.raw.block", { fg = c.markdown_code_block })

vim.api.nvim_set_hl(0, "@markup.link", { fg = c.markdown_link })
vim.api.nvim_set_hl(0, "@markup.link.label", { fg = c.markdown_link_label })
vim.api.nvim_set_hl(0, "@markup.link.url", { fg = c.markdown_url, italic = true })

vim.api.nvim_set_hl(0, "@markup.list", { fg = c.markdown_list_marker })
vim.api.nvim_set_hl(0, "@markup.list.checked", { fg = c.gitsigns_add })
vim.api.nvim_set_hl(0, "@markup.list.unchecked", { fg = c.markdown_list_marker })

vim.api.nvim_set_hl(0, "@markup.quote", { fg = c.markdown_quote, italic = true })
vim.api.nvim_set_hl(0, "markdownRule", { fg = c.markdown_rule })

-- Markdown plain text (non-markup content)
vim.api.nvim_set_hl(0, "@none.markdown", { fg = c.markdown_plain_text })
vim.api.nvim_set_hl(0, "@text.literal.markdown", { fg = c.markdown_plain_text })
vim.api.nvim_set_hl(0, "@text.markdown", { fg = c.markdown_plain_text })
