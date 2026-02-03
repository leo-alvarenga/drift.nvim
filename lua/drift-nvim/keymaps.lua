local M = {}

--- Register keymaps
--- @param opts drift-nvim.DriftConfig Options for keymap registration.
function M.register_keymaps(opts)
	local keymaps = opts.keymaps

	if not keymaps then
		return
	end

	local _consts = require("drift-nvim.constants")

	for key, cmd in pairs(keymaps) do
		if not _consts.commands[cmd] then
			vim.notify(
				string.format("[drift-nvim] Invalid command '%s' for keymap '%s'", cmd, key),
				vim.log.levels.WARN,
				{ title = "[drift-nvim] Keymap Registration" }
			)

			goto continue
		end

		vim.keymap.set("n", key, "<cmd>" .. _consts.commands[cmd] .. "<cr>", { noremap = true, silent = true })

		::continue::
	end
end

return M
