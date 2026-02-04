local M = {}

--- Persist buffer contents to disk, safely
--- @param buf number
local function save_buffer(buf)
	if not buf or not vim.api.nvim_buf_is_valid(buf) then
		return
	end

	vim.api.nvim_buf_call(buf, function()
		vim.cmd("silent! write")
	end)
end

--- Close window + delete buffer, ensuring save happens once
--- @param buf number
--- @param win number
--- @param opts drift-nvim.DriftConfig
local function close(buf, win, opts)
	save_buffer(buf)

	if win and vim.api.nvim_win_is_valid(win) then
		pcall(vim.api.nvim_win_close, win, true)
	end

	if buf and opts.buffer_lifetime ~= "hide" and vim.api.nvim_buf_is_valid(buf) then
		pcall(vim.api.nvim_buf_delete, buf, { force = true })
	end
end

--- Attach autocmds that guarantee save + close on any escape action
--- @param buf number
--- @param win number
--- @param opts drift-nvim.DriftConfig
local function attach_autoclose(buf, win, opts)
	local constants = require("drift-nvim.constants")
	local group = vim.api.nvim_create_augroup(constants.plugin.register .. "_autoclose_" .. buf, { clear = true })

	local closed = false

	local function once()
		if closed then
			return
		end
		closed = true
		close(buf, win, opts)
	end

	vim.api.nvim_create_autocmd({
		"BufLeave",
		"BufWinLeave",
		"BufDelete",
		"WinLeave",
		"TabLeave",
	}, {
		group = group,
		buffer = buf,
		once = true,
		callback = once,
	})
end

--- Draw the floating Drift window
--- @param opts drift-nvim.DriftConfig
--- @return { buf_id: number, win_id: number } | nil
function M.draw_floating_window(opts)
	local file = require("drift-nvim.file")
	local constants = require("drift-nvim.constants")

	local win_opts = opts.win_opts or {}
	local storage_path = opts.storage.path .. "/drift.md"

	file.ensure_file_exists(storage_path)

	-- create buffer
	local buf = vim.fn.bufadd(storage_path)
	vim.fn.bufload(buf)

	-- buffer options (modern API)
	vim.api.nvim_set_option_value("bufhidden", opts.buffer_lifetime or "wipe", { buf = buf })
	vim.api.nvim_set_option_value("swapfile", false, { buf = buf })
	vim.api.nvim_set_option_value("buftype", "", { buf = buf })

	-- window geometry
	local editor_w = vim.o.columns
	local editor_h = vim.o.lines

	local width = math.floor(editor_w * (win_opts.width or 0.8))
	local height = math.floor(editor_h * (win_opts.height or 0.8))

	local col = win_opts.col or math.floor((editor_w - width) / 2)
	local row = win_opts.row or math.floor((editor_h - height) / 2)

	-- open floating window
	local win = vim.api.nvim_open_win(buf, true, {
		relative = "editor",
		col = col,
		row = row,
		width = width,
		height = height,
		border = win_opts.border,
		style = win_opts.style,
		title = " " .. constants.plugin.name .. " ",
		title_pos = "center",
		zindex = 90,
	})

	if not win or win <= 0 then
		return nil
	end

	attach_autoclose(buf, win, opts)

	if opts.auto_insert then
		vim.api.nvim_buf_call(buf, function()
			vim.cmd("normal! G$")
		end)
		vim.cmd("startinsert")
	end

	if type(win_opts.on_open) == "function" then
		win_opts.on_open()
	end

	return {
		buf_id = buf,
		win_id = win,
	}
end

--- Explicit close entrypoint (used by toggle)
--- @param win number
--- @param opts drift-nvim.DriftConfig
function M.close_window(win, opts)
	if not win or not vim.api.nvim_win_is_valid(win) then
		return
	end

	local buf = vim.api.nvim_win_get_buf(win)
	close(buf, win, opts)
end

return M
