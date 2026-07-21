{ lib, config, ... }:
let
  isEnabled = plugin: config.plugins."${plugin}".enable;
in
{
  colorschemes.catppuccin = {
    enable = true;
    settings = {
      term_colors = true;
      background.dark = "mocha";
      integrations = {
        native_lsp = {
          enabled = true;
          underlines = {
            errors = [ "undercurl" ];
            hints = [ "undercurl" ];
            warnings = [ "undercurl" ];
            information = [ "undercurl" ];
          };
        };
        blink_cmp.enabled = isEnabled "blink-cmp";
        dashboard = isEnabled "dashboard";
        # blink_indent.enabled = true;
        ghost.enabled = true;
        noice.enabled = isEnabled "noice";
        which_key.enabled = isEnabled "which-key";
        nvim_surround = true;
        mini = {
          enabled = isEnabled "mini-indentscope";
          indentscope_color = "";
        };
      };
      flavor = "mocha";
      italic = true;
      bold = true;
      dimInactive = false;
      transparent_background = lib.mkForce false;
    };
  };
  highlight.ColortilsCurrentLine.bg = "#313244";
}
