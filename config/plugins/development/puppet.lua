local M = {}

-- Walk up from current buffer dir until finding one with a `modules/` subdir.
local function find_repo_root()
	local path = vim.fn.expand("%:p:h")
	if path == "" then
		path = vim.fn.getcwd()
	end
	while path ~= "/" and path ~= "" do
		if vim.fn.isdirectory(path .. "/modules") == 1 then
			return path
		end
		local parent = vim.fn.fnamemodify(path, ":h")
		if parent == path then
			break
		end
		path = parent
	end
	return vim.fn.getcwd()
end

-- Walk back from cursor to find the nearest top-level (col-0) yaml key.
local function get_yaml_top_key()
	local cur = vim.api.nvim_win_get_cursor(0)[1]
	for i = cur, 1, -1 do
		local line = vim.fn.getline(i)
		local key = line:match("^([%w_%-]+):%s*$")
		if key then
			return key
		end
	end
	return nil
end

-- If cursor is inside a template(...) or epp(...) call, return the path arg.
local function get_template_path()
	local line = vim.fn.getline(".")
	local col = vim.fn.col(".")
	local patterns = {
		[[(template)%s*%(%s*["']([^"']+)["']%s*%)]],
		[[(epp)%s*%(%s*["']([^"']+)["']%s*%)]],
	}
	for _, pat in ipairs(patterns) do
		local init = 1
		while true do
			local s, e, _fn, path = line:find(pat, init)
			if not s then
				break
			end
			if col >= s and col <= e then
				return path
			end
			init = e + 1
		end
	end
	return nil
end

-- Get a puppet:// URI under cursor, if any.
local function get_puppet_uri()
	local line = vim.fn.getline(".")
	local col = vim.fn.col(".")
	if #line == 0 then
		return nil
	end

	local function is_uri(c)
		return c and c:match("[%w_%-%./:]") ~= nil
	end
	if not is_uri(line:sub(col, col)) then
		return nil
	end

	local s = col
	while s > 1 and is_uri(line:sub(s - 1, s - 1)) do
		s = s - 1
	end
	local e = col
	while e <= #line and is_uri(line:sub(e, e)) do
		e = e + 1
	end
	local tok = line:sub(s, e - 1)
	-- Strip surrounding punctuation
	tok = tok:gsub("^[%.:/]+", ""):gsub("[%.:/]+$", "")
	if tok:match("^puppet://") then
		return tok
	end
	return nil
end

-- Get full puppet identifier (word chars + `::`) under cursor.
local function get_puppet_ident()
	local line = vim.fn.getline(".")
	local col = vim.fn.col(".")
	if #line == 0 then
		return ""
	end

	local function is_ident(c)
		return c and c:match("[%w_:]") ~= nil
	end

	-- If cursor sits on whitespace, bail.
	if not is_ident(line:sub(col, col)) then
		return ""
	end

	local s = col
	while s > 1 and is_ident(line:sub(s - 1, s - 1)) do
		s = s - 1
	end
	local e = col
	while e <= #line and is_ident(line:sub(e, e)) do
		e = e + 1
	end
	local ident = line:sub(s, e - 1)
	-- Strip stray leading/trailing colons
	ident = ident:gsub("^:+", ""):gsub(":+$", "")
	return ident
end

local function split_parts(ident)
	local parts = {}
	for p in ident:gmatch("[^:]+") do
		if p ~= "" then
			table.insert(parts, p)
		end
	end
	return parts
end

function M.goto_definition()
	local root = find_repo_root()

	-- Try template('mod/file.erb') / epp('mod/file.epp') -> modules/mod/templates/file.*
	local tpl = get_template_path()
	if tpl then
		local mod, rest = tpl:match("^([^/]+)/(.+)$")
		if mod and rest then
			local target = root .. "/modules/" .. mod .. "/templates/" .. rest
			vim.cmd("edit " .. vim.fn.fnameescape(target))
			if vim.fn.filereadable(target) ~= 1 then
				vim.notify("puppet: file does not exist yet: " .. target, vim.log.levels.INFO)
			end
			return
		end
		vim.notify("puppet: unrecognized template path: " .. tpl, vim.log.levels.WARN)
		return
	end

	-- Try puppet:// URI (e.g. puppet:///modules/foo/bar.conf -> modules/foo/files/bar.conf).
	local uri = get_puppet_uri()
	if uri then
		local module, rest = uri:match("^puppet://[^/]*/modules/([^/]+)/(.+)$")
		if module and rest then
			local target = root .. "/modules/" .. module .. "/files/" .. rest
			vim.cmd("edit " .. vim.fn.fnameescape(target))
			if vim.fn.filereadable(target) ~= 1 then
				vim.notify("puppet: file does not exist yet: " .. target, vim.log.levels.INFO)
			end
			return
		end
		vim.notify("puppet: unrecognized URI: " .. uri, vim.log.levels.WARN)
		return
	end

	local ident = get_puppet_ident()
	if ident == "" then
		vim.notify("puppet: no identifier under cursor", vim.log.levels.WARN)
		return
	end

	local parts = split_parts(ident)
	if #parts == 0 then
		vim.notify("puppet: empty identifier", vim.log.levels.WARN)
		return
	end

	local yaml_prefixed = false

	if vim.bo.filetype == "yaml" then
		local top = get_yaml_top_key()
		local yaml_map = { profiles = "profile", roles = "role" }
		local mod = yaml_map[top]
		if mod then
			table.insert(parts, 1, mod)
			yaml_prefixed = true
		end
	end

	local target
	if #parts == 1 then
		-- Bare single word: only resolve if modules/<word>/ exists.
		local mod = parts[1]
		local mod_dir = root .. "/modules/" .. mod
		if vim.fn.isdirectory(mod_dir) ~= 1 then
			vim.notify("puppet: module not found: " .. mod, vim.log.levels.WARN)
			return
		end
		target = mod_dir .. "/manifests/init.pp"
	else
		local module = parts[1]
		local subpath = table.concat(parts, "/", 2)
		target = root .. "/modules/" .. module .. "/manifests/" .. subpath .. ".pp"
	end

	vim.cmd("edit " .. vim.fn.fnameescape(target))
	if vim.fn.filereadable(target) ~= 1 then
		vim.notify("puppet: file does not exist yet: " .. target, vim.log.levels.INFO)
	end
	-- Suppress unused-var warning
	_ = yaml_prefixed
end

return M
