--- @class nix
local M = {
	output = nil,
	nix_path = "/run/current-system/sw/bin/nix",
	flake = ".",
	jq_path = "jq",
}

local function dump(o)
	if type(o) == "table" then
		local s = "{ "
		for k, v in pairs(o) do
			if type(k) ~= "number" then
				k = '"' .. k .. '"'
			end
			s = s .. "[" .. k .. "] = " .. dump(v) .. ","
		end
		return s .. "} "
	else
		return tostring(o)
	end
end

local api = vim.api

local ts = vim.treesitter

--- @param path string
local function add_dot(path)
	if path == "" then
		return path
	end
	return path .. "."
end

--- @param node vim.treesitter.LanguageTree
--- @param fullpath string
local function print_node(node, fullpath)
	if node:type() == "binding" then
		local attrpath = node:field("attrpath")[1]
		if attrpath ~= nil then
			return add_dot(fullpath) .. ts.get_node_text(attrpath, 0, {})
		end
	end
	return fullpath
end

-- @param TSNODE
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

function M.print_config_path()
	local path = M.get_option_path()
	vim.notify(path)
end

function M.copy_config_path()
	local path = M.get_option_path()
	vim.notify("Copied: " .. path)
	vim.fn.setreg("+", path)
end

function M.nix_eval(flake_output, apply)
	local apply_command = ""
	if apply ~= nil and apply ~= "" then
		apply_command = string.format('--apply "%s"', apply)
	end

	local result = vim.system({
		"bash",
		"-c",
		string.format("%s eval %s#%s %s --json", M.nix_path, M.flake, flake_output, apply_command),
	}, { text = true }):wait()

	if result.code ~= 0 then
		-- See https://github.com/NixOS/nix/issues/11576
		vim.notify("Unable to evaluate as JSON, trying regular eval...", "warn")
		return vim.system({
			"bash",
			"-c",
			string.format("%s eval %s#%s %s", M.nix_path, M.flake, flake_output, apply_command),
		}, { text = true }):wait()
	end
	return result
end

function M.set_output(setting)
	if setting == nil then
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
		local result = M.nix_eval(string.format(M.output .. "." .. M.get_option_path()), nil)
		if result.code == 0 then
			local buf = vim.api.nvim_create_buf(false, true) -- listed=false, scratch=true
			local formatted_json = vim.system(M.jq_path, { text = true }):write(result.stdout):wait()
			vim.api.nvim_open_win(buf, true, window_config())

			vim.api.nvim_buf_set_lines(buf, 0, -1, false, vim.split(formatted_json, "\n"))
			vim.api.nvim_set_option_value("filetype", "json", { buf = buf })
			vim.api.nvim_set_option_value("readonly", true, { buf = buf })
			vim.api.nvim_set_option_value("modifiable", false, { buf = buf })
			vim.api.nvim_set_option_value("bufhidden", "wipe", { buf = buf })
		else
			vim.notify(string.format("Unable to evaluate:\n%s", result.stderr), "error")
		end
	end
end

return M
