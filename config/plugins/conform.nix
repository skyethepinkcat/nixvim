{
  pkgs,
  lib,
  ...
}:
{
  plugins.conform-nvim = {
    enable = true;
    settings = {
      formatters_by_ft = {
        lua = [ "stylua" ];
        puppet = [ "puppet-lint" ];
        nix = [ "nixfmt" ];
        ruby = [ "rubocop" ];
      };
      formatters.nixfmt.command = lib.getExe pkgs.nixfmt;
      formatters.rubycop.command = lib.getExe pkgs.rubocop;
      formatters.lua.command = lib.getExe pkgs.stylua;
      format_on_save = ''
        function(bufnr)
          -- Disable with a global or buffer-local variable
          if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
            return
          end
          local bufname = vim.api.nvim_buf_get_name(bufnr)
          if bufname:match "/Puppetfile" then
            return
          end
          return { timeout_ms = 500, lsp_format = "fallback" }
        end
      '';
    };
  };
}
