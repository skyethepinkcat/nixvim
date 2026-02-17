{
  config,
  lib,
  ...
}:
let
  inherit (lib.nixvim) mkRaw;
in
{
  imports = [
    ./ai
    ./git.nix
    ./completion.nix
    ./conform.nix
    ./dashboard.nix
    ./dashboard.nix
    ./explorer.nix
    ./lsp.nix
    ./toggleterm.nix
    ./treesitter.nix
    ./ui
  ];
  plugins.snacks.enable = true;
  plugins.direnv.enable = true;
  plugins.which-key = {
    enable = true;
    settings = {
      spec = config.wKeyList;
      win = {
        width = {
          min = 30;
          max = 60;
        };
        height = {
          min = 4;
          max = 0.75;
        };
        padding = [
          0
          1
        ];
        col = 1;
        row = -1;
        border = "rounded";
        title = true;
        title_pos = "left";
      };
      layout = {
        width = {
          min = 30;
        };
      };
    };
  };
}
