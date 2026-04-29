local function _tab_entries(filter_current)
  local tabs = vim.api.nvim_list_tabpages()
  local current = vim.api.nvim_get_current_tabpage()
  local entries = {}
  for i, tab in ipairs(tabs) do
    if not filter_current or tab ~= current then
      local wins = vim.api.nvim_tabpage_list_wins(tab)
      local label, bufnr = "Tab " .. i, nil
      if #wins > 0 then
        bufnr = vim.api.nvim_win_get_buf(wins[1])
        local name = vim.api.nvim_buf_get_name(bufnr)
        if name ~= "" then
          label = i .. ": " .. vim.fn.fnamemodify(name, ":t")
        end
      end
      entries[#entries + 1] = { display = label, ordinal = label, tab = tab, tabnr = i, bufnr = bufnr }
    end
  end
  return entries
end

local function _tab_previewer()
  local previewers = require("telescope.previewers")
  return previewers.new_buffer_previewer({
    define_preview = function(self, entry)
      local wins = vim.api.nvim_tabpage_list_wins(entry.tab)
      local lines = {}
      for _, win in ipairs(wins) do
        local buf = vim.api.nvim_win_get_buf(win)
        local name = vim.api.nvim_buf_get_name(buf)
        if name ~= "" then
          lines[#lines + 1] = vim.fn.fnamemodify(name, ":~:.")
        end
      end
      vim.api.nvim_buf_set_lines(self.state.bufnr, 0, -1, false, lines)
    end,
  })
end
