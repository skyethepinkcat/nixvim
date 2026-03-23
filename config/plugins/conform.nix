{
  pkgs,
  lib,
  inputs,
  ...
}:
let
  skyepkgs = inputs.skyepkgs.packages.${pkgs.stdenv.hostPlatform.system};
  mkFormatters = formatters: [ "nf" ] ++ formatters;
in
{
  # plugins.conform-nvim = {
  #   enable = true;
  #   settings = {
  #     formatters_by_ft = {
  #       puppet = [ "puppet-lint" ];
  #       nix = mkFormatters [ "nixfmt" ];
  #       ruby = {
  #         timeout_ms = 5000; # is real slow rubocop
  #         lsp_format = "first";
  #         stop_after_first = true;
  #         __unkeyed-1 = "rubocop";
  #       };
  #       # ruby = [ "rubocop" ];
  #       sh = mkFormatters [ "shfmt" ];
  #       zsh = mkFormatters [ "shfmt" ];
  #       bash = mkFormatters [ "shfmt" ];
  #       rust = mkFormatters [ "rustfmt" ];
  #     };
  #     formatters = {
  #       nf = {
  #         args = [
  #           "fmt"
  #           "--"
  #           "$FILENAME"
  #         ];
  #         command = "nix";
  #         timeout_ms = 5000;
  #       };
  #       nixfmt.command = lib.getExe pkgs.nixfmt;
  #       treefmt.command = lib.getExe pkgs.treefmt;
  #       rubocop = {
  #         timeout_ms = 5000;
  #         command = lib.getExe pkgs.rubocop; # Ruby environments cause weirdness, just use the first available version
  #       };
  #       stylua.command = lib.getExe pkgs.stylua;
  #       shfmt.command = lib.getExe pkgs.shfmt;
  #       puppet-lint.command = lib.getExe skyepkgs.openvox-lint;
  #       rustfmt.command = lib.getExe pkgs.rustfmt;
  #     };
  #     format_on_save =
  #       # lua
  #       ''
  #         function(bufnr)
  #           -- Disable with a global or buffer-local variable
  #           if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
  #             return
  #           end
  #           local bufname = vim.api.nvim_buf_get_name(bufnr)
  #            -- local buftype = vim.api.nvim_buf_get_type(bufnr)
  #           if bufname:match "/Puppetfile" then
  #             return
  #           end
  #           return { timeout_ms = 500, lsp_format = "fallback" }
  #         end
  #       '';
  #   };
  # };
}
