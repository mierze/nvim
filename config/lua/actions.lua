local MY_TIMEZONE = "PT"

vim.api.nvim_create_autocmd("VimLeavePre", {
  callback = function()
    vim.cmd("silent! rshada")
    vim.cmd("wshada")
  end,
})

vim.api.nvim_create_autocmd("BufWritePost", {
  callback = function()
    vim.cmd("silent! rshada")
    require("./marks").apply()
    vim.cmd("silent! wshada")
  end,
})

-- Oil buffer: friendly mark setting with gm<letter>
vim.api.nvim_create_autocmd("FileType", {
  pattern = "oil",
  callback = function(args)
    vim.keymap.set("n", "gm", "m", { buffer = args.buf, noremap = true, silent = true, desc = "Set mark" })

    -- Ensure Oil buffer has a proper name for shada persistence
    local oil_dir = require("oil").get_current_dir()
    if oil_dir then
      vim.api.nvim_buf_set_name(args.buf, "oil://" .. oil_dir)
    end

    -- Force save shada after setting marks in Oil buffers
    vim.api.nvim_create_autocmd("BufLeave", {
      buffer = args.buf,
      callback = function()
        vim.cmd("silent! wshada")
      end,
    })
  end,
})

-- Auto-update global marks (A-Z) to last cursor position on buffer leave (off: marks stay where set)
-- vim.api.nvim_create_autocmd("BufLeave", {
--   callback = function()
--     local current_buf = vim.api.nvim_get_current_buf()
--     local cursor_pos = vim.api.nvim_win_get_cursor(0)
--
--     -- Check each global mark A-Z
--     for i = 65, 90 do
--       local mark_char = string.char(i)
--       local mark_pos = vim.api.nvim_buf_get_mark(current_buf, mark_char)
--
--       -- If mark exists in this buffer (line > 0), update it to current cursor position
--       if mark_pos[1] > 0 then
--         vim.api.nvim_buf_set_mark(current_buf, mark_char, cursor_pos[1], cursor_pos[2], {})
--       end
--     end
--   end,
-- })

-- TODO should be bound keys user custom actions
vim.api.nvim_create_user_command("VS", function()
  vim.cmd("vsplit | wincmd l | vertical resize +10")
end, {})
vim.api.nvim_create_user_command("Va", function()
  vim.cmd("vertical resize +10")
end, {})
vim.api.nvim_create_user_command("Vx", function()
  vim.cmd("vertical resize -10")
end, {})
vim.api.nvim_create_user_command("Hx", function()
  vim.cmd("horizontal resize -10")
end, {})
vim.api.nvim_create_user_command("Ha", function()
  vim.cmd("horizontal resize +10")
end, {})

local settings = require("profile_settings")
vim.g.project_roots = vim.list_extend({
  vim.fn.stdpath("config"), settings.config_dir, settings.notes,
  settings.workspace, settings.projects,
}, settings.project_roots)

-- :Z <workspace worktree | zoxide query> - sets global cwd (pins workspace worktree for <D-d>/<D-f>)
vim.api.nvim_create_user_command("Z", function(o)
  local d = vim.fs.joinpath(settings.workspace, o.args)
  if #o.fargs ~= 1 or vim.fn.isdirectory(d) == 0 then
    d = vim.fn.trim(vim.fn.system({ "zoxide", "query", unpack(o.fargs) }))
    if vim.v.shell_error ~= 0 then
      return vim.notify("zoxide: no match", vim.log.levels.WARN)
    end
  end
  vim.cmd.cd(vim.fn.fnameescape(d))
  vim.cmd.edit(vim.fn.fnameescape(d))
end, { nargs = "*" })

vim.api.nvim_create_user_command("RG", function(opts)
  local args = {}
  for _, arg in ipairs(opts.fargs) do
    if arg:match("%.c$") or arg:match("%.h$") then
      table.insert(args, "**/" .. arg)
    else
      table.insert(args, arg)
    end
  end
  vim.cmd("grep " .. table.concat(args, " "))
  vim.cmd("copen")
end, {
  nargs = "+",
  complete = "file",
})

vim.api.nvim_create_user_command("W", function()
  vim.cmd("w")
end, {})

vim.api.nvim_create_user_command("Wq", function()
  vim.cmd("wq")
end, {})

vim.api.nvim_create_user_command("WQ", function()
  vim.cmd("wq")
end, {})

vim.api.nvim_create_user_command("Q", function()
  vim.cmd("q")
end, {})

-- Sort visually selected lines by their leading number (descending)
-- Lines with leading whitespace are kept with their parent
-- Special handling: [~] items go to top, [x] items go to bottom with number stripped
-- :Beam a / :Beam A - move the current line and its indented children (or a visual range) to just below the mark's
-- line: a-z in this buffer, A-Z in whatever file the global mark points to.
-- :Beam! a / :Beam! A - same file, but right under its first heading instead (the mark only picks the file).
-- frontmatter (--- ... ---) is skipped; a heading is `# x` or a setext title (text over === / ---). no heading = right
-- after the frontmatter, else line 1. a target that isn't open is loaded and left unsaved
local function first_heading_row(buf)
  local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
  local start = 1
  if lines[1] == "---" then
    for i = 2, #lines do
      if lines[i] == "---" then
        start = i + 1
        break
      end
    end
  end
  for i = start, #lines do
    if lines[i]:match("^#+%s") then
      return i
    end
    local nxt = lines[i + 1]
    if lines[i]:match("%S") and nxt and (nxt:match("^=+%s*$") or nxt:match("^%-%-%-+%s*$")) then
      return i + 1
    end
  end
  return start - 1
end

vim.api.nvim_create_user_command("Beam", function(opts)
  local name = opts.args
  local mark
  if name:match("^%u$") then
    mark = vim.api.nvim_get_mark(name, {})
  elseif name:match("^%l$") then
    -- local mark: this buffer, lands just below the mark's line (like :Beam!)
    local pos = vim.api.nvim_buf_get_mark(0, name)
    mark = { pos[1], pos[2], vim.api.nvim_get_current_buf(), "" }
  else
    return vim.notify("Beam: needs a mark a-z (this file) or A-Z (global)", vim.log.levels.WARN)
  end
  if mark[1] == 0 then
    return vim.notify("Beam: mark " .. name .. " is not set", vim.log.levels.WARN)
  end
  local at_mark = not opts.bang
  local src = vim.api.nvim_get_current_buf()
  local first, last
  if opts.range > 0 then
    first, last = opts.line1, opts.line2
  else
    first = vim.fn.line(".")
    last = first
    local base = vim.fn.indent(first)
    for l = first + 1, vim.fn.line("$") do
      local text = vim.fn.getline(l)
      if text:match("%S") then
        if vim.fn.indent(l) <= base then
          break
        end
        last = l
      end
    end
  end
  local lines = vim.api.nvim_buf_get_lines(src, first - 1, last, false)
  local dst = mark[3] ~= 0 and mark[3] or vim.fn.bufadd(mark[4])
  vim.fn.bufload(dst)
  vim.bo[dst].buflisted = true
  local row = at_mark and mark[1] or first_heading_row(dst)
  if dst == src then
    if row >= first and row <= last then
      return vim.notify("Beam: mark " .. name .. " is inside the lines being moved", vim.log.levels.WARN)
    end
    vim.api.nvim_buf_set_lines(src, first - 1, last, false, {})
    if row > last then
      row = row - #lines
    end
    vim.api.nvim_buf_set_lines(src, row, row, false, lines)
  else
    vim.api.nvim_buf_set_lines(dst, row, row, false, lines)
    vim.api.nvim_buf_set_lines(src, first - 1, last, false, {})
  end
  vim.notify(("beamed %d line%s → %s:%d"):format(#lines, #lines == 1 and "" or "s",
    vim.fn.fnamemodify(vim.api.nvim_buf_get_name(dst), ":t"), row + 1))
end, {
  nargs = 1,
  range = true,
  bang = true,
  complete = function()
    local out = {}
    -- this buffer's a-z, then the global A-Z
    for _, m in ipairs(vim.fn.getmarklist(vim.api.nvim_get_current_buf())) do
      local c = m.mark:sub(2, 2)
      if c:match("%l") then
        table.insert(out, c)
      end
    end
    for _, m in ipairs(vim.fn.getmarklist()) do
      local c = m.mark:sub(2, 2)
      if c:match("%u") then
        table.insert(out, c)
      end
    end
    return out
  end,
})

vim.api.nvim_create_user_command("Sort", function()
  -- Get visual selection range
  local start_line = vim.fn.line("'<")
  local end_line = vim.fn.line("'>")

  -- Get the lines
  local lines = vim.api.nvim_buf_get_lines(0, start_line - 1, end_line, false)

  -- Group lines: parent lines and their children
  local groups = {}
  local current_group = nil

  for i, line in ipairs(lines) do
    -- Check if line starts with whitespace (child line)
    if line:match("^[ \t]") then
      -- Add to current group if one exists
      if current_group then
        table.insert(current_group.children, line)
      else
        -- No parent, create group with 0 sort value
        current_group = { sort_value = 0, checkbox_state = "normal", parent = line, children = {}, original_index = i }
        table.insert(groups, current_group)
      end
    else
      -- Parent line: detect checkbox state
      local checkbox_state = "normal"
      if line:match("^%- %[~%]") then
        checkbox_state = "in_progress"
      elseif line:match("^%- %[x%]") then
        checkbox_state = "done"
      elseif line:match("^%- %[%?%]") then
        checkbox_state = "triage"
      elseif line:match("^%- %[r%]") then
        checkbox_state = "rejected"
      elseif line:match("^%- %[v%]") then
        checkbox_state = "review"
      end

      -- Strip prefixes to extract number (first number after checkbox)
      local stripped = line:gsub("^%- %[[.~x?rv ]%] ", ""):gsub("^%- ", "")
      local num = tonumber(stripped:match("^(%d+)")) or 0

      current_group = {
        sort_value = num,
        checkbox_state = checkbox_state,
        parent = line,
        children = {},
        original_index = i
      }
      table.insert(groups, current_group)
    end
  end

  -- Sort groups: [~] top, [ ] middle, [v] review, [?] triage, [r] rejected, [x] bottom
  table.sort(groups, function(a, b)
    -- Tier priority: in_progress > normal > review > triage > rejected > done
    local tier_order = {
      in_progress = 6,
      normal = 5,
      review = 4,
      triage = 3,
      rejected = 2,
      done = 1
    }

    if tier_order[a.checkbox_state] ~= tier_order[b.checkbox_state] then
      return tier_order[a.checkbox_state] > tier_order[b.checkbox_state]
    end

    -- Within tier sorting
    if a.checkbox_state == "done" then
      -- Done items: preserve original order (stable sort)
      return a.original_index < b.original_index
    else
      -- All other tiers: descending by number
      return a.sort_value > b.sort_value
    end
  end)

  -- Flatten groups back into lines
  local sorted_lines = {}
  for _, group in ipairs(groups) do
    local parent_line = group.parent

    -- Strip number from [x] items
    if group.checkbox_state == "done" then
      parent_line = parent_line:gsub("^(%- %[x%] )%d+ ", "%1")
    end

    table.insert(sorted_lines, parent_line)
    for _, child in ipairs(group.children) do
      table.insert(sorted_lines, child)
    end
  end

  -- Replace the lines
  vim.api.nvim_buf_set_lines(0, start_line - 1, end_line, false, sorted_lines)
end, { range = true })

-- ============================================================================
-- TIMEZONE & COUNTDOWN CONFIGURATION
-- ============================================================================

-- Set your current timezone here: "PT", "ET", "CT", or "UTC"

-- Timezone mappings
local TIMEZONES = {
  PT = "America/Los_Angeles",
  ET = "America/New_York",
  CT = "America/Chicago",
  UTC = "UTC",
}

-- ============================================================================
-- TIME UTILITIES
-- ============================================================================

local uv = vim.loop

-- Get current time in specified timezone
local function get_time_in_tz(tz_name)
  local tz = TIMEZONES[tz_name]
  if not tz then
    error("Invalid timezone: " .. tz_name)
  end

  local original_tz = os.getenv("TZ")
  vim.fn.setenv("TZ", tz)
  local now = os.time()
  if original_tz then
    vim.fn.setenv("TZ", original_tz)
  else
    vim.fn.setenv("TZ", "")
  end
  return now
end

-- Get time string (HH:MM) in specified timezone
local function get_time_str_in_tz(tz_name)
  local tz = TIMEZONES[tz_name]
  if not tz then
    error("Invalid timezone: " .. tz_name)
  end

  local original_tz = os.getenv("TZ")
  vim.fn.setenv("TZ", tz)
  local time_str = os.date("%H:%M")
  if original_tz then
    vim.fn.setenv("TZ", original_tz)
  else
    vim.fn.setenv("TZ", "")
  end
  return time_str
end

-- Format seconds to "XhYm" format
local function format_time(seconds)
  local hours = math.floor(seconds / 3600)
  local minutes = math.floor((seconds % 3600) / 60)
  return string.format("%dh%02dm", hours, minutes)
end

-- Parse relative time like "+30m", "+2h", "+8:00" (8 hours)
local function parse_relative_time(time_str)
  if not time_str:match("^%+") then
    return nil
  end

  -- Remove the leading '+'
  local value_str = time_str:sub(2)

  -- Check for formats like "+8:00" meaning 8 hours
  local hours_colon = value_str:match("^(%d+):00$")
  if hours_colon then
    return tonumber(hours_colon) * 3600
  end

  -- Check for minutes: "+30m"
  local minutes = value_str:match("^(%d+)m$")
  if minutes then
    return tonumber(minutes) * 60
  end

  -- Check for hours: "+2h"
  local hours = value_str:match("^(%d+)h$")
  if hours then
    return tonumber(hours) * 3600
  end

  return nil, "Invalid relative time format. Use +Xm, +Xh, or +X:00"
end

-- Parse "HH:MM" string to epoch seconds today in specified timezone
local function parse_absolute_time(time_str, tz_name)
  local hour, min = time_str:match("^(%d%d?):(%d%d)$")
  if not min then
    min = "00"
  end
  if not hour then
    hour = time_str:match("^(%d%d?)$")
  end
  if not hour or not min then
    return nil, "Invalid time format, expected HH:MM"
  end
  hour = tonumber(hour)
  min = tonumber(min)

  local tz = TIMEZONES[tz_name]
  if not tz then
    return nil, "Invalid timezone: " .. tz_name
  end

  local original_tz = os.getenv("TZ")
  vim.fn.setenv("TZ", tz)
  local now = os.date("*t")
  now.hour = hour
  now.min = min
  now.sec = 0
  local target_epoch = os.time(now)
  if original_tz then
    vim.fn.setenv("TZ", original_tz)
  else
    vim.fn.setenv("TZ", "")
  end

  return target_epoch
end

-- ============================================================================
-- COUNTDOWN
-- ============================================================================

local countdown = {}

-- Start countdown from seconds
function countdown.start(total_seconds)
  local timer = uv.new_timer()
  local remaining = total_seconds

  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_option(buf, "bufhidden", "wipe")

  local width = 7
  local height = 1
  local opts = {
    relative = "editor",
    width = width,
    height = height,
    row = 1,
    col = vim.o.columns - width - 1,
    style = "minimal",
    focusable = false,
  }
  local win = vim.api.nvim_open_win(buf, false, opts)

  local function update()
    if remaining <= 0 then
      vim.api.nvim_buf_set_lines(buf, 0, -1, false, { "DONE!" })
      timer:stop()
      timer:close()
      return
    end
    local time_str = format_time(remaining)
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, { time_str })
    remaining = remaining - 60
  end

  update()
  timer:start(60000, 60000, vim.schedule_wrap(update))
end

-- Start countdown to a target time (absolute HH:MM or relative +Xm/+Xh/+X:00)
function countdown.start_to_time(time_str, tz_name)
  tz_name = tz_name or MY_TIMEZONE

  -- Check if it's a relative time
  if time_str:match("^%+") then
    local seconds, err = parse_relative_time(time_str)
    if not seconds then
      vim.api.nvim_err_writeln("Countdown error: " .. err)
      return
    end
    countdown.start(seconds)
    return
  end

  -- Otherwise, parse as absolute time
  local target_epoch, err = parse_absolute_time(time_str, tz_name)
  if not target_epoch then
    vim.api.nvim_err_writeln("Countdown error: " .. err)
    return
  end

  local now = get_time_in_tz(tz_name)

  -- If target is in the past, assume tomorrow
  if target_epoch <= now then
    target_epoch = target_epoch + 24 * 3600
  end

  local diff = target_epoch - now
  countdown.start(diff)
end

-- ============================================================================
-- COMMANDS
-- ============================================================================

-- :Cd 18:00 or :Cd +30m or :Cd +2h or :Cd +8:00
vim.api.nvim_create_user_command("Cd", function(opts)
  local time_str = opts.args
  countdown.start_to_time(time_str)
end, {
  nargs = 1,
  desc = "Start countdown to HH:MM (absolute) or +Xm/+Xh/+X:00 (relative)",
})

-- :Time - Show current time in your timezone
vim.api.nvim_create_user_command("Time", function()
  local time_str = get_time_str_in_tz(MY_TIMEZONE)

  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_option(buf, "bufhidden", "wipe")
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, { time_str .. " " .. MY_TIMEZONE })

  local width = 10
  local height = 1
  local opts = {
    relative = "editor",
    width = width,
    height = height,
    row = 0,
    col = vim.o.columns - width - 1,
    style = "minimal",
    focusable = false,
  }

  vim.api.nvim_open_win(buf, false, opts)
end, {
  nargs = 0,
  desc = "Show current time in your timezone",
})
