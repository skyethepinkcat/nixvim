{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (config.nvix.mkKey) mkKeymap wKeyObj;
in {
  plugins.snacks.settings.explorer.enabled = true;
  keymaps = [(mkKeymap "n" "<leader>e" "<cmd>:lua Snacks.explorer()<cr>" "Explorer")];
}
