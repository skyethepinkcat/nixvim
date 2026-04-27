{ lib, ... }:
{
  plugins = {
    markdown-preview = {
      enable = true;
    };
    render-markdown = {
      enable = true;
      settings = {
        enabled = false;
        completions = {
          lsp.enabled = true;
        };
        overrides = {
          preview = {
            enabled = true;
          };
        };
      };
    };
  };

  autoCmd = [
    {
      event = "FileType";
      pattern = "markdown";
      callback =
        lib.nixvim.mkRaw
          # lua
          ''
            function(ev)
              local opts = function(desc)
                return { buffer = ev.buf, silent = true, desc = desc }
              end
              vim.keymap.set("n", "<LocalLeader>p", "<cmd>RenderMarkdown preview<cr>", opts("Show Markdown Preview"))
              vim.keymap.set("n", "<LocalLeader>t", "<cmd>RenderMarkdown buf_toggle<cr>", opts("Toggle render mode"))
              vim.keymap.set("n", "<LocalLeader>+", "<cmd>RenderMarkdown expand<cr>", opts("Expand conceal level"))
              vim.keymap.set("n", "<LocalLeader>-", "<cmd>RenderMarkdown contract<cr>", opts("Contract conceal level"))
              vim.keymap.set("n", "<LocalLeader>P", "<cmd>MarkdownPreview<cr>", opts("Show Browser Preview"))
              vim.keymap.set("n", "<LocalLeader>n", function()
                local lines = vim.api.nvim_buf_get_lines(ev.buf, 0, -1, false)
                local counters = {}
                local new_lines = {}
                for _, line in ipairs(lines) do
                  local indent, num, rest = line:match("^(%s*)(%d+)%.%s(.+)$")
                  if indent ~= nil then
                    local level = #indent
                    counters[level] = (counters[level] or 0) + 1
                    for k in pairs(counters) do
                      if k > level then counters[k] = nil end
                    end
                    table.insert(new_lines, indent .. counters[level] .. ". " .. rest)
                  else
                    local plain_indent = line:match("^(%s*)[^%s]")
                    if plain_indent then
                      local level = #plain_indent
                      for k in pairs(counters) do
                        if k >= level then counters[k] = nil end
                      end
                    end
                    table.insert(new_lines, line)
                  end
                end
                vim.api.nvim_buf_set_lines(ev.buf, 0, -1, false, new_lines)
              end, opts("Re-number ordered lists"))
            end
          '';
    }
  ];
}
