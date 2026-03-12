{
  pkgs,
  lib,
  inputs,
  ...
}:
let
  skyepkgs = inputs.skyepkgs.packages.${pkgs.stdenv.hostPlatform.system};
in
{
  plugins.conform-nvim = {
    enable = true;
    settings = {
      formatters_by_ft = {
        lua = [ "stylua" ];
        puppet = [ "puppet-lint" ];
        nix = [
          "nf"
          "nixfmt"
        ];
        ruby = {
          timeout_ms = 5000; # is real slow rubocop
          lsp_format = "first";
          stop_after_first = true;
          __unkeyed-1 = "rubocop";
        };
        # ruby = [ "rubocop" ];
        sh = [ "shfmt" ];
        zsh = [ "shfmt" ];
        bash = [ "shfmt" ];
        rust = [ "rustfmt" ];
      };
      formatters.nf.command = "nix fmt";
      formatters.nixfmt.command = lib.getExe pkgs.nixfmt;
      formatters.rubocop = {
        timeout_ms = 5000;
        command = lib.getExe pkgs.rubocop; # Ruby environments cause weirdness, just use the first available version
      };
      formatters.stylua.command = lib.getExe pkgs.stylua;
      formatters.shfmt.command = lib.getExe pkgs.shfmt;
      formatters.puppet-lint.command = lib.getExe skyepkgs.openvox-lint;
      formatters.rustfmt.command = lib.getExe pkgs.rustfmt;
      #   format_on_save =
      #     # lua
      #     ''
      #       function(bufnr)
      #         -- Disable with a global or buffer-local variable
      #         if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
      #           return
      #         end
      #         local bufname = vim.api.nvim_buf_get_name(bufnr)
      #          -- local buftype = vim.api.nvim_buf_get_type(bufnr)
      #         if bufname:match "/Puppetfile" then
      #           return
      #         end
      #         return { timeout_ms = 500, lsp_format = "fallback" }
      #       end
      #     '';
    };
  };
}
