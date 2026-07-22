{
  lib,
  config,
  utils,
  ...
}:
let
  inherit (utils) mkFunc;
in
{
  plugins = {
    markdown-preview = {
      enable = true;
      lazyLoad = {
        settings.ft = "markdown";
      };
    };
    render-markdown = {
      enable = true;
      lazyLoad = {
        settings.ft = "markdown";
      };
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

  ftKeyList = {
    "markdown" =
      let
        renderHelper = key: command: desc: {
          mode = "n";
          key = "<LocalLeader>${key}";
          inherit desc;
          action = "<cmd>RenderMarkdown ${command}<cr>";
        };
      in
      [
        (renderHelper "p" "preview" "Show Markdown Preview")
        (renderHelper "t" "buf_toggle" "Toggle render mode")
        (renderHelper "+" "expand" "Expand conceal level")
        (renderHelper "-" "contract" "Contract conceal level")
        {
          key = "<LocalLeader>n";
          mode = "n";
          desc = "Re-number ordered lists";
          action = mkFunc ''
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
          '';
        }
      ];
  };

  # Set options for text files
  autoCmd = [
    {
      event = [ "FileType" ];
      pattern = [
        "markdown"
        "text"
      ];
      callback = utils.mkFunc ''
        vim.opt.formatoptions:append("t") -- Have neovim handle line wrapping everywhere
      '';
    }
  ];

  ftplugin.markdown.localOpts = {
    formatexpr = "";
    textwidth = 100;
  };
}
