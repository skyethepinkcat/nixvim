{
  lib,
  ...
}:
{
  colorschemes.catppuccin = {
    enable = true;
    settings = {
      # term_colors = true;
      background.dark = "mocha";

      integrations = {
        blink_cmp.enabled = true;
        dashboard = true;
        blink_indent.enabled = true;
        ghost.enabled = true;
        noice.enabled = true;
        which_key.enabled = true;
        nvim_surround = true;
        mini = {
          enabled = true;
          indentscope_color = "";
        };
        native_lsp = {
          enabled = true;
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
