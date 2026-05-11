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

-- Resolve the file path the cursor points at. Returns (path, err).
local function resolve_target()
	local root = find_repo_root()

	-- template('mod/file.erb') / epp('mod/file.epp') -> modules/mod/templates/file.*
	local tpl = get_template_path()
	if tpl then
		local mod, rest = tpl:match("^([^/]+)/(.+)$")
		if mod and rest then
			return root .. "/modules/" .. mod .. "/templates/" .. rest
		end
		return nil, "unrecognized template path: " .. tpl
	end

	-- puppet:///modules/mod/path -> modules/mod/files/path
	local uri = get_puppet_uri()
	if uri then
		local module, rest = uri:match("^puppet://[^/]*/modules/([^/]+)/(.+)$")
		if module and rest then
			return root .. "/modules/" .. module .. "/files/" .. rest
		end
		return nil, "unrecognized URI: " .. uri
	end

	local ident = get_puppet_ident()
	if ident == "" then
		return nil, "no identifier under cursor"
	end

	local parts = split_parts(ident)
	if #parts == 0 then
		return nil, "empty identifier"
	end

	if vim.bo.filetype == "yaml" then
		local top = get_yaml_top_key()
		local yaml_map = { profiles = "profile", roles = "role" }
		local mod = yaml_map[top]
		if mod then
			table.insert(parts, 1, mod)
		end
	end

	if #parts == 1 then
		local mod = parts[1]
		local mod_dir = root .. "/modules/" .. mod
		if vim.fn.isdirectory(mod_dir) ~= 1 then
			return nil, "module not found: " .. mod
		end
		return mod_dir .. "/manifests/init.pp"
	end

	local module = parts[1]
	local subpath = table.concat(parts, "/", 2)
	return root .. "/modules/" .. module .. "/manifests/" .. subpath .. ".pp"
end

function M.goto_definition()
	local target, err = resolve_target()
	if not target then
		vim.notify("puppet: " .. err, vim.log.levels.WARN)
		return
	end
	vim.cmd("edit " .. vim.fn.fnameescape(target))
	if vim.fn.filereadable(target) ~= 1 then
		vim.notify("puppet: file does not exist yet: " .. target, vim.log.levels.INFO)
	end
end

-- Keys allowed inside the preview window. Anything else closes it.
local PREVIEW_NAV = {
	["j"] = true,
	["k"] = true,
	["h"] = true,
	["l"] = true,
	["<Down>"] = true,
	["<Up>"] = true,
	["<Left>"] = true,
	["<Right>"] = true,
	["<C-D>"] = true,
	["<C-U>"] = true,
	["<C-F>"] = true,
	["<C-B>"] = true,
	["<C-E>"] = true,
	["<C-Y>"] = true,
	["G"] = true,
	["H"] = true,
	["M"] = true,
	["L"] = true,
	["{"] = true,
	["}"] = true,
	["0"] = true,
	["$"] = true,
	["^"] = true,
	["w"] = true,
	["b"] = true,
	["e"] = true,
	["W"] = true,
	["B"] = true,
	["E"] = true,
	["n"] = true,
	["N"] = true,
}

local function open_preview(path)
	local buf = vim.fn.bufadd(path)
	vim.fn.bufload(buf)

	-- Compact float anchored near cursor, flipping anchor near screen edges.
	local width = math.min(80, math.floor(vim.o.columns * 0.5))
	local height = math.min(20, math.floor(vim.o.lines * 0.4))
	local screen_row = vim.fn.winline()
	local screen_col = vim.fn.wincol()
	local anchor_v = (screen_row + height + 2 > vim.o.lines) and "S" or "N"
	local anchor_h = (screen_col + width + 2 > vim.o.columns) and "E" or "W"
	local anchor = anchor_v .. anchor_h
	local row = (anchor_v == "N") and 1 or 0
	local col = (anchor_h == "W") and 1 or 0

	local win = vim.api.nvim_open_win(buf, false, {
		relative = "cursor",
		anchor = anchor,
		width = width,
		height = height,
		row = row,
		col = col,
		style = "minimal",
		border = "rounded",
		title = " " .. vim.fn.fnamemodify(path, ":~:.") .. " ",
		title_pos = "center",
	})

	local function close()
		if vim.api.nvim_win_is_valid(win) then
			vim.api.nvim_win_close(win, true)
		end
	end

	vim.schedule(function()
		while vim.api.nvim_win_is_valid(win) do
			vim.cmd("redraw")
			local ok, ch = pcall(vim.fn.getcharstr)
			if not ok or not ch or ch == "" then
				break
			end
			local key = vim.fn.keytrans(ch)
			if key == "<CR>" then
				close()
				vim.cmd("edit " .. vim.fn.fnameescape(path))
				return
			elseif key == "g" then
				-- Allow `gg`; otherwise close.
				local ok2, ch2 = pcall(vim.fn.getcharstr)
				if ok2 and vim.fn.keytrans(ch2) == "g" then
					vim.api.nvim_win_call(win, function()
						vim.cmd("normal! gg")
					end)
				else
					break
				end
			elseif PREVIEW_NAV[key] then
				vim.api.nvim_win_call(win, function()
					vim.cmd("normal! " .. ch)
				end)
			else
				break
			end
		end
		close()
	end)
end

function M.preview_definition()
	local target, err = resolve_target()
	if not target then
		vim.notify("puppet: " .. err, vim.log.levels.WARN)
		return
	end
	if vim.fn.filereadable(target) ~= 1 then
		vim.notify("puppet: file does not exist: " .. target, vim.log.levels.WARN)
		return
	end
	open_preview(target)
end

return M
