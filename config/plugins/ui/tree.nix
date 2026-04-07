{ config, pkgs, ... }:
let
  inherit (config.lib.keys) keyObj;
in
{

  plugins.nvim-tree = {
    enable = true;
  };
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
  keyList = [
    (keyObj {
      action = "<cmd>NvimTreeToggle<cr>";
      key = "<leader>e";
      icon = "󰙅";
      desc = "Explorer";
    })
  ];
}
