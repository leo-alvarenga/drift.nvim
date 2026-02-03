local M = {}

--- @class drift-nvim.DriftWinOpts
--- @field width number? The width of the floating window. Default is 80% of the editor width.
--- @field height number? The height of the floating window. Default is 80% of the editor height.
--- @field row number? The row position of the floating window. Default is calculated to center the editor.
--- @field col number? The column position of the floating window. Default is calculated to center the editor.
--- @field border string|table? The border style of the floating window. Default is unset, so that it uses Neovim's default.
--- @field style string? The style of the floating window. Default is unset, so that it uses Neovim's default.
--- @field on_open function? A callback function that is called when the floating window is opened.
--- @field on_close function? A callback function that is called when the floating window is closed.

--- @class drift-nvim.DriftStorageOpts
--- @field path string? The path where drift data is stored. Default is placed under neovim's data directory.

--- @class drift-nvim.DriftConfig
--- @field keymaps table<string, 'close'|'open'|'toggle'|'drift'>? Options for keymap registration.
--- @field notify boolean? Whether to show notifications. Default is false.
--- @field storage drift-nvim.DriftStorageOpts? Options for drift data storage.
--- @field win_opts drift-nvim.DriftWinOpts? Options for the drift window appearance and behavior.

--- @type drift-nvim.DriftConfig
--- @description Default configuration for drift-nvim.
M.defaults = {
	keymaps = {},

	storage = {
		-- Default storage file path: <data_dir>/drift-nvim/drift.txt
		path = vim.fn.stdpath("data") .. "/drift-nvim/",
	},

	win_opts = {
		width = 0.8,
		height = 0.8,
	},
}

--- @type drift-nvim.DriftConfig
M.options = vim.tbl_deep_extend("force", {}, M.defaults)

--- Configure drift-nvim with user options
--- @param opts drift-nvim.DriftConfig? User-provided configuration options.
function M.set_options(opts)
	if not opts then
		return
	end

	M.options = vim.tbl_deep_extend("force", M.defaults, opts)
end

--- Get the current configuration options for drift-nvim
--- @return drift-nvim.DriftConfig options current configuration options.
function M.get_options()
	return M.options
end

return M
