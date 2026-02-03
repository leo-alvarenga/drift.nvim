local M = {}

--- @class drift-nvim.Window
--- @field buf_id number|nil Buffer ID of the floating window
--- @field win_id number|nil Window ID of the floating window
--- @field opened boolean Indicates whether the window is open
--- @field is_open fun(self: drift-nvim.Window): boolean Checks if the floating window is currently open
--- @field open fun(self: drift-nvim.Window, opts: drift-nvim.DriftConfig): table?|nil Opens the floating window
--- @field close fun(self: drift-nvim.Window, opts: drift-nvim.DriftConfig): table?|nil Closes the floating window
--- @field toggle fun(self: drift-nvim.Window, opts: drift-nvim.DriftConfig): table?|nil Toggles the floating window

--- @type drift-nvim.Window
Window = {
	buf_id = nil,
	win_id = nil,

	opened = false,

	is_open = function(self)
		return self.opened == true
			and self.buf_id ~= nil
			and vim.api.nvim_buf_is_valid(self.buf_id)
			and self.win_id ~= nil
			and vim.api.nvim_win_is_valid(self.win_id)
	end,

	open = function(self, opts)
		if self:is_open() then
			return nil
		end

		local _ui = require("drift-nvim.ui")

		local result = _ui.draw_floating_window(opts)

		self.buf_id = result.buf_id
		self.win_id = result.win_id

		if self.win_id == nil then
			return nil
		end

		self.opened = true

		return {
			buf_id = self.buf_id,
			win_id = self.win_id,
		}
	end,

	close = function(self, opts)
		if not self:is_open() then
			return nil
		end

		local _ui = require("drift-nvim.ui")

		local buf_id = self.buf_id
		local win_id = self.win_id
		_ui.close_floating_window(opts, buf_id, win_id)

		self.opened = false

		self.buf_id = nil
		self.win_id = nil

		return {
			buf_id = buf_id,
			win_id = win_id,
		}
	end,

	toggle = function(self, opts)
		if self:is_open() then
			return self:close(opts)
		end

		return self:open(opts)
	end,
}

M.win_controller = Window

return M
