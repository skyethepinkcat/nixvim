{ lib, config, ... }:
let
  inherit (lib.nixvim) mkRaw;
in
{
  plugins = {
    cmp = {
      enable = true;
      settings = {
        mapping = {
          "<C-Space>" = "cmp.mapping.complete()";
          "<C-d>" = "cmp.mapping.scroll_docs(-4)";
          "<C-e>" = "cmp.mapping.close()";
          "<C-f>" = "cmp.mapping.scroll_docs(4)";
          "<CR>" = "cmp.mapping.confirm({ select = true })";
          "<S-Tab>" = "cmp.mapping(cmp.mapping.select_prev_item(), {'i', 's'})";
          "<Tab>" = "cmp.mapping(cmp.mapping.select_next_item(), {'i', 's'})";
        };
      };
    };
    # blink-cmp-copilot.enable = config.ai.suggestions;
    # blink-cmp = {
    #   enable = true;
    #   settings = {
    #     completion = {
    #       menu.border = "rounded";
    #       # list.selection.preselect = false;
    #       menu.auto_show = false;
    #       ghost_text = {
    #         enabled = true;
    #         show_with_menu = false;
    #         show_without_selection = true;
    #       };
    #     };
    #     keymap = {
    #       preset = "enter";
    #       "<Tab>" = [
    #         "show"
    #         "select_next"
    #         "fallback"
    #       ];
    #       "<S-Tab>" = [
    #         "select_prev"
    #         "fallback"
    #       ];
    #     };
    #     sources = {
    #       default = lib.optionals config.ai.suggestions [ "copilot" ] ++ [
    #         "lsp"
    #         "path"
    #         "snippets"
    #         "buffer"
    #       ];
    #       providers = lib.mkIf config.ai.suggestions {
    #         copilot = {
    #           async = true;
    #           module = "blink-cmp-copilot";
    #           name = "copilot";
    #         };
    #       };
    #     };
    #   };
    # };
    noice = {
      enable = true;
    };
  };
}
