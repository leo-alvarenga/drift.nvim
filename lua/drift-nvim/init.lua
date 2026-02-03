local M = {}

--- Setup drift-nvim with user options
--- @param opts drift-nvim.DriftConfig? User-provided configuration options.
function M.setup(opts)
	local _cmds = require("drift-nvim.commands")
	local _config = require("drift-nvim.config")
	local _keymaps = require("drift-nvim.keymaps")

	_config.set_options(opts)

	_cmds.register_commands()

	_keymaps.register_keymaps(_config.get_options())
end

M.win_controller = require("drift-nvim.api").win_controller

M.version = "0.1.0"

return M
