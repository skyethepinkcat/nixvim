{
  lib,
  config,
  pkgs,
  ...
}:
let
  inherit (lib.nixvim) mkRaw;
in
{
  extraPlugins = with pkgs.vimPlugins; [
    blink-cmp-conventional-commits
  ];
  plugins = {
    blink-cmp = {
      enable = true;
      settings = {
        completion = {
          menu.border = "rounded";
          # list.selection.preselect = false;
          menu.auto_show = false;
          ghost_text = {
            enabled = true;
            show_with_menu = true;
            show_without_selection = true;
          };
        };
        keymap = {
          preset = "default";
          # "<Tab>" = [
          #   "show"
          #   "select_next"
          #   "fallback"
          # ];
          # "<S-Tab>" = [
          #   "select_prev"
          #   "fallback"
          # ];
        };
        sources = {
          default = [
            "lsp"
            "path"
            "snippets"
            "buffer"
          ];
        };
      };
    };
  };
}
