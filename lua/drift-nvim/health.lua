local M = {}

--- Perform health checks for the drift-nvim plugin
function M.check()
	local _consts = require("drift-nvim.constants")

	vim.health.start(_consts.plugin.actual_name .. " health check")
	vim.health.ok("Plugin loaded successfully; " .. _consts.plugin.actual_name .. " is working")

	local ok, plugin = pcall(require, _consts.plugin.register)

	if ok and plugin then
		local window = plugin.window

		if window then
			vim.health.ok("window is present")

			if type(window.toggle) == "function" then
				vim.health.ok("window.toggle is a function")
			else
				vim.health.error("window.toggle is not a function")
			end

			local status, err = pcall(window.toggle, window)
			status, err = pcall(window.toggle, window)

			if status then
				vim.health.ok("window.toggle() executed without errors")
			else
				vim.health.error("window.toggle() raised an error: " .. err)
			end
		else
			vim.health.warn(
				"window return `nil`. This probably means the plugin was not initialized correctly. Make sure to call `require('"
					.. _consts.plugin.register
					.. "').setup()` in your config."
			)
		end
	else
		vim.health.error("Failed to load window function")
	end
end

return M
