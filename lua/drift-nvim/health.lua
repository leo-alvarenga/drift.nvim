local M = {}

--- Perform health checks for the drift-nvim plugin
function M.check()
	local _consts = require("drift-nvim.constants")

	vim.health.start(_consts.plugin.actual_name .. " health check")
	vim.health.ok("Plugin loaded successfully; " .. _consts.plugin.actual_name .. " is working")

	local ok, plugin = pcall(require, _consts.plugin.register)

	if ok and plugin then
		local win_controller = plugin.win_controller

		if win_controller then
			vim.health.ok("win_controller is present")

			if type(win_controller.toggle) == "function" then
				vim.health.ok("win_controller.toggle is a function")
			else
				vim.health.error("win_controller.toggle is not a function")
			end

			local status, err = pcall(win_controller.toggle, win_controller)
			status, err = pcall(win_controller.toggle, win_controller)

			if status then
				vim.health.ok("win_controller.toggle() executed without errors")
			else
				vim.health.error("win_controller.toggle() raised an error: " .. err)
			end
		else
			vim.health.warn(
				"win_controller return `nil`. This probably means the plugin was not initialized correctly. Make sure to call `require('"
					.. _consts.plugin.register
					.. "').setup()` in your config."
			)
		end
	else
		vim.health.error("Failed to load win_controller function")
	end
end

return M
