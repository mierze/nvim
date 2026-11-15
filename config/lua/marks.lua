-- pinned global marks: letter = { file, line }. reapplied on startup and after every shada sync,
-- and ` + a pinned letter refuses to overwrite. edit here to move a mark; remove a line to unpin it
local M = {}

M.pins = require("profile_settings").marks

function M.apply()
	for letter, pin in pairs(M.pins) do
		local path = vim.fn.expand(pin[1])
		if vim.fn.filereadable(path) == 1 then
			vim.fn.setpos("'" .. letter, { vim.fn.bufadd(path), pin[2], 1, 0 })
		end
	end
end

-- set a mark, unless it's pinned
function M.set()
	local c = vim.fn.getcharstr()
	if M.pins[c] then
		return vim.notify("mark " .. c .. " is pinned (local.lua)", vim.log.levels.WARN)
	end
	vim.cmd("normal! m" .. c)
end

-- shada is read after init, so pins go on once startup is done
vim.api.nvim_create_autocmd("VimEnter", { callback = M.apply })

return M
