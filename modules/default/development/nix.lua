local M = { output = nil }

local api = vim.api

local ts = vim.treesitter

local function add_dot(path)
	if path == "" then
		return path
	end
	return path .. "."
end

local function print_node(node, fullpath)
	if node:type() == "binding" then
		local attrpath = node:field("attrpath")[1]
		if attrpath ~= nil then
			return add_dot(fullpath) .. ts.get_node_text(attrpath, 0, {})
		end
	end
	return fullpath
end

local function concat_nodes(root, dest, fullPath)
	if root:type() == "list_expression" then
		return fullPath
	elseif root:id() == dest:id() then
		return print_node(root, fullPath)
	else
		return concat_nodes(root:child_with_descendant(dest), dest, print_node(root, fullPath))
	end
end

function M.get_option_path()
	local buf = api.nvim_get_current_buf()

	local cur = api.nvim_win_get_cursor(0)
	local node = ts.get_node(cur)
	local root = node:tree():root()

	return concat_nodes(root, node, "config")
end

function M.copy_config_path()
	local path = M.get_option_path()
	vim.notify("Copied: " .. path)
	vim.fn.setreg("+", path)
end

function M.set_output(setting)
	if setting ~= nil then
		vim.ui.input({ prompt = "Enter the nix output to use.", scope = "project" }, function(input)
			M.output = input
		end)
	else
		M.output = setting
	end
end

local function window_config()
	local WIDTH_RATIO = 0.5
	local HEIGHT_RATIO = 0.8
	local win_w = vim.api.nvim_win_get_width(0)
	local win_h = vim.api.nvim_win_get_height(0)
	local window_w = win_w * WIDTH_RATIO
	local window_h = win_h * HEIGHT_RATIO
	local window_w_int = math.floor(window_w)
	local window_h_int = math.floor(window_h)
	local center_x = (win_w - window_w) / 2
	local center_y = (win_h - window_h) / 2
	return {
		border = "rounded",
		relative = "win",
		row = center_y,
		col = center_x,
		width = window_w_int,
		height = window_h_int,
	}
end

function M.eval_config()
	if M.output == nil then
		M.set_output(nil)
	end
	if M.output ~= nil then
		local full_path = M.output .. "." .. M.get_option_path()
		local result = vim.system({
			"bash",
			"-c",
			string.format(
				'/run/current-system/sw/bin/nix eval .#%s.config --apply "config: %s" --json | jq',
				M.output,
				M.get_option_path()
			),
		}, {
			text = true,
		}):wait()
		if result.code == 0 then
			local buf = vim.api.nvim_create_buf(false, true) -- listed=false, scratch=true
			vim.api.nvim_open_win(buf, true, window_config())

			vim.api.nvim_set_option_value("filetype", "json", { buf = buf })
			vim.api.nvim_buf_set_lines(buf, 0, -1, false, vim.split(result.stdout, "\n"))
		else
			vim.notify(result.stderr)
		end
	end
end

return M
