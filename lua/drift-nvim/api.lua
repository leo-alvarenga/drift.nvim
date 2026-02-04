local M = {}

--- @class drift-nvim.Window
--- @field buf_id number|nil Buffer ID of the floating window
--- @field win_id number|nil Window ID of the floating window
--- @field is_open fun(self: drift-nvim.Window): boolean Checks if the floating window is currently open
--- @field open fun(self: drift-nvim.Window, opts: drift-nvim.DriftConfig): table?|nil Opens the floating window
--- @field close fun(self: drift-nvim.Window, opts: drift-nvim.DriftConfig): table?|nil Closes the floating window
--- @field toggle fun(self: drift-nvim.Window, opts: drift-nvim.DriftConfig): table?|nil Toggles the floating window

--- @type drift-nvim.Window
local Window = {
	buf_id = nil,
	win_id = nil,

	is_open = function(self)
		return (
			self.buf_id
			and self.win_id
			and vim.api.nvim_buf_is_valid(self.buf_id)
			and vim.api.nvim_win_is_valid(self.win_id)
		) or false
	end,

	open = function(self, opts)
		if self:is_open() then
			return nil
		end

		local _ui = require("drift-nvim.ui")
		local result = _ui.draw_floating_window(opts)

		if not result or not result.win_id or not result.buf_id then
			return nil
		end

		self.buf_id = result.buf_id
		self.win_id = result.win_id

		return result
	end,

	close = function(self, opts)
		if not self:is_open() then
			return nil
		end

		require("drift-nvim.ui").close_window(self.win_id, opts)

		local result = {
			buf_id = self.buf_id,
			win_id = self.win_id,
		}

		self.buf_id = nil
		self.win_id = nil

		return result
	end,

	toggle = function(self, opts)
		if self:is_open() then
			return self:close(opts)
		end

		return self:open(opts)
	end,
}

M.window = Window

return M
