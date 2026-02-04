local M = {}

M.actions = {
	close = "close",
	open = "open",
	toggle = "toggle",
	drift = "drift",
}

M.plugin = {
	name = "Drift",
	register = "drift-nvim",
	actual_name = "drift.nvim",
}

--- @param name string?
--- @return string
function M.to_cmd(name)
	return M.plugin.name .. (name or "")
end

M.commands = {
	close = M.to_cmd("Close"),
	open = M.to_cmd("Open"),
	toggle = M.to_cmd("Toggle"),
	drift = M.to_cmd(),
}

return M
