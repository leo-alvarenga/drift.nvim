local M = {}

--- Silently saves the buffer with the given ID
--- @param buf_id number Buffer ID to save
--- @param notify boolean? Whether to show a notification after saving
function M.save_silently(buf_id, notify)
	local current_buf = vim.api.nvim_get_current_buf()

	if buf_id ~= current_buf then
		vim.api.nvim_set_current_buf(buf_id)
	end

	vim.cmd("silent! write")

	if buf_id ~= current_buf then
		vim.api.nvim_set_current_buf(current_buf)
	end

	if not notify then
		return
	end
end

--- Closes the floating window and deletes its buffer
--- @param opts drift-nvim.DriftConfig for the floating window (currently unused)
--- @param win_id number? Window ID of the floating window
function M.close_window(opts, win_id)
	local win_opts = opts.win_opts or {}
	local win = vim.api.nvim_get_current_win()

	if win_id ~= nil and vim.api.nvim_win_is_valid(win_id) then
		if win_id ~= win and win ~= nil then
			vim.api.nvim_set_current_win(win_id)
		end

		vim.api.nvim_win_close(win_id, true)
	end

	if win_opts.on_close ~= nil and type(win_opts.on_close) == "function" then
		win_opts.on_close()
	end
end

--- Sets up autocmds to automatically close the floating window
--- when the buffer or window is left
--- @param opts drift-nvim.DriftConfig for the floating window (currently unused)
--- @param buf_id number Buffer ID of the floating window
--- @param win_id number Window ID of the floating window
function M.set_autoclose(opts, buf_id, win_id)
	local _consts = require("drift-nvim.constants")

	-- Auto-close on buffer leave/delete
	vim.api.nvim_create_autocmd({ "BufLeave", "BufWinLeave", "BufDelete", "WinLeave" }, {
		buffer = vim.api.nvim_win_get_buf(win_id),
		group = _consts.plugin.augroup,
		once = true,

		callback = function()
			M.save_silently(buf_id, opts.notify)
			M.close_window(opts, win_id)
		end,
	})
end

--- Draws a floating window centered in the current Neovim window
--- @param opts drift-nvim.DriftConfig for the floating window (currently unused)
--- @return table ids table containing buf_id and win_id
function M.draw_floating_window(opts)
	local _file = require("drift-nvim.file")

	local win_opts = opts.win_opts or {}

	local file_path = vim.fn.fnameescape(opts.storage.path .. "drift.md")
	_file.ensure_file_exists(file_path)

	local auto_insert = opts.auto_insert or false
	local w_ratio = win_opts.width or 0.8
	local h_ratio = win_opts.height or 0.8

	local win = vim.api.nvim_get_current_win()

	local win_width = vim.api.nvim_win_get_width(win)
	local win_height = vim.api.nvim_win_get_height(win)

	local width = math.ceil(win_width * w_ratio)
	local height = math.ceil(win_height * h_ratio)

	local col = win_opts.col or math.floor((win_width - width) / 2)
	local row = win_opts.row or math.floor((win_height - height) / 2)

	local buf_id = vim.fn.bufadd(file_path)
	vim.fn.bufload(buf_id)

	local win_id = vim.api.nvim_open_win(buf_id, true, {
		relative = "editor",
		title = " " .. require("drift-nvim.constants").plugin.name .. " ",
		title_pos = "center",
		hide = false,
		zindex = 90,
		col = col,
		row = row,
		width = width,
		height = height,
		style = win_opts.style,
		border = win_opts.border,
	})

	if win_id == nil or win_id <= 0 then
		return {
			buf_id = nil,
			win_id = nil,
		}
	end

	if auto_insert then
		vim.cmd("normal! G$")
		vim.cmd("startinsert!")
	end

	M.set_autoclose(opts, buf_id, win_id)

	if win_opts.on_open ~= nil and type(win_opts.on_open) == "function" then
		win_opts.on_open()
	end

	return {
		buf_id = buf_id,
		win_id = win_id,
	}
end

return M
