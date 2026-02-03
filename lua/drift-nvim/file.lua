local M = {}

--- Ensures that a file exists at the given path. If the file does not exist,
--- it creates any necessary parent directories and an empty file.
--- @param file_path string The file path to ensure existence.
--- @return boolean success True if the file_path exists or was created successfully, false otherwise.
function M.ensure_file_exists(file_path)
	if vim.fn.filereadable(file_path) ~= 0 then
		return true
	end

	local dir = vim.fn.fnamemodify(file_path, ":h")

	if dir ~= "" and vim.fn.isdirectory(dir) == 0 then
		vim.fn.system({ "mkdir", "-p", dir })
	end

	local file = io.open(file_path, "a")
	if file then
		file:close()
	end

	return vim.fn.filereadable(file_path) ~= 0
end

return M
