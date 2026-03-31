{ config, pkgs, ... }:
let
  inherit (config.nvix.mkKey) wKeyObj;
in
{

  plugins.nvim-tree = {
    enable = true;
  };
  keymaps = [
    {
      action = "<cmd>NvimTreeToggle<cr>";
      key = "<leader>e";
      mode = "n";
    }
  ];
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
  wKeyList = [
    (wKeyObj [
      "<leader>e"
      "󰙅"
      "Explorer"
    ])
  ];
}
