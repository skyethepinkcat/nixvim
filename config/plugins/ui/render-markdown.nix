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
            end
          '';
    }
  ];
}
