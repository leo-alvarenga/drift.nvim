local _consts = require("drift-nvim.constants")
local _api = require("drift-nvim.api")

--- @param desc string
--- @return string
local function to_desc(desc)
	return _consts.plugin.actual_name .. ": " .. desc
end

local window = _api.win_controller

local M = {}

M.functions = {
	[_consts.commands.drift] = function()
		window:toggle(require("drift-nvim.config").get_options())
	end,
	[_consts.commands.toggle] = function()
		window:toggle(require("drift-nvim.config").get_options())
	end,
	[_consts.commands.open] = function()
		window:open(require("drift-nvim.config").get_options())
	end,
	[_consts.commands.close] = function()
		window:close()
	end,
}

M.commands = {
	--- @type vim.api.keyset.user_command
	[_consts.commands.drift] = {
		desc = to_desc("Start drifting"),
	},
	--- @type vim.api.keyset.user_command
	[_consts.commands.toggle] = {
		desc = to_desc("Toggle"),
	},
	--- @type vim.api.keyset.user_command
	[_consts.commands.open] = {
		desc = to_desc("Open"),
	},
	--- @type vim.api.keyset.user_command
	[_consts.commands.close] = {
		desc = to_desc("Close"),
	},
}

function M.register_commands()
	for cmd, opts in pairs(M.commands) do
		vim.api.nvim_create_user_command(cmd, M.functions[cmd], opts)
	end
end

return M
