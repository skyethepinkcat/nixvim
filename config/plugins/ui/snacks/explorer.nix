{
  config,
  pkgs,
  lib,
  ...
}:
let
  inherit (config.nvix.mkKey) mkKeymap;
in
{
  extraPackagesAfter = with pkgs; [
    trash-cli
  ];
  dependencies = {
    fd.enable = true;
    ripgrep.enable = true;
    grep.enable = true;
    tree-sitter = {
      enable = true;
    };
  };
  plugins.snacks.settings.explorer.enabled = true;
  keymaps = [ (mkKeymap "n" "<leader>e" "<cmd>:lua Snacks.explorer()<cr>" "Explorer") ];
}
