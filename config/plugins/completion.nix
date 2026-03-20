{ lib, config, ... }:
let
  inherit (lib.nixvim) mkRaw;
in
{
  plugins = {
    blink-cmp-copilot.enable = config.ai.suggestions;
    blink-cmp = {
      enable = true;
      settings = {
        completion = {
          menu.border = "rounded";
          # list.selection.preselect = false;
          menu.auto_show = false;
          ghost_text = {
            enabled = true;
            show_with_menu = false;
            show_without_selection = true;
          };
        };
        keymap = {
          preset = "enter";
          "<Tab>" = [
            "show"
            "select_next"
            "fallback"
          ];
          "<S-Tab>" = [
            "select_prev"
            "fallback"
          ];
        };
        sources = {
          default = lib.optionals config.ai.suggestions [ "copilot" ] ++ [
            "lsp"
            "path"
            "snippets"
            "buffer"
          ];
          providers = lib.mkIf config.ai.suggestions {
            copilot = {
              async = true;
              module = "blink-cmp-copilot";
              name = "copilot";
            };
          };
        };
      };
    };
    noice = {
      enable = true;
    };
  };
}
