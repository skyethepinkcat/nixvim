local Terminal = require("toggleterm.terminal").Terminal

local function on_open(term)
	vim.keymap.set("t", "<C-d>", function()
		term:toggle()
	end, { buffer = term.bufnr, noremap = true, silent = true })
end

local _ai_last = nil

if vim.fn.executable("opencode") == 1 then
	local opencode = Terminal:new({ cmd = "opencode", hidden = true, direction = "float", on_open = on_open })
	local opencode_resume =
		Terminal:new({ cmd = "opencode --continue", hidden = true, direction = "float", on_open = on_open })

	local _opencode_last = opencode
	local _opencode_all = { opencode, opencode_resume }

	function _opencode_toggle()
		_ai_last = _opencode_toggle
		_opencode_last:toggle()
	end

	function _opencode_resume_toggle()
		_opencode_last = opencode_resume
		_ai_last = _opencode_toggle
		opencode_resume:toggle()
	end

	function _opencode_close_all()
		for _, term in ipairs(_opencode_all) do
			term:close()
		end
	end
end

if vim.fn.executable("claude") == 1 then
	local claude = Terminal:new({ cmd = "claude", hidden = true, direction = "float", on_open = on_open })
	local claude_resume =
		Terminal:new({ cmd = "claude --continue", hidden = true, direction = "float", on_open = on_open })

	local _claude_last = claude
	local _claude_all = { claude, claude_resume }

	function _claude_toggle()
		_ai_last = _claude_toggle
		_claude_last:toggle()
	end

	function _claude_resume_toggle()
		_claude_last = claude_resume
		_ai_last = _claude_toggle
		claude_resume:toggle()
	end

	function _claude_close_all()
		for _, term in ipairs(_claude_all) do
			term:close()
		end
	end
end

function _ai_last_toggle()
	if _ai_last then
		_ai_last()
	end
end
