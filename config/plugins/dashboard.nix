{
  config,
  lib,
  ...
}:
let
  inherit (config.lib.telescope) openPicker;
  inherit (lib.nixvim) mkRaw;
in
{
  plugins.dashboard = {
    enable = true;
    settings = {
      shortcut_type = "number";
      config = {
        shortcut = [
          {
            action = openPicker "find_files";
            desc = "Files";
            group = "Label";
            icon = "󰱼 ";
            icon_hl = "@variable";
            key = "f";
          }
          {
            action = openPicker "live_grep";
            desc = "Grep";
            group = "Label";
            icon = "󱎸 ";
            icon_hl = "@variable";
            key = "g";
          }
          {
            action =
              mkRaw
                # lua
                ''
                  function()
                    vim.cmd("q")
                    end
                '';
            desc = "Quit";
            group = "Label";
            icon = " ";
            icon_hl = "@variable";
            key = "q";
          }
        ];
        header = [
          "███╗   ██╗██╗██╗  ██╗██╗   ██╗██╗███╗   ███╗"
          "████╗  ██║██║╚██╗██╔╝██║   ██║██║████╗ ████║"
          "██╔██╗ ██║██║ ╚███╔╝ ██║   ██║██║██╔████╔██║"
          "██║╚██╗██║██║ ██╔██╗ ╚██╗ ██╔╝██║██║╚██╔╝██║"
          "██║ ╚████║██║██╔╝ ██╗ ╚████╔╝ ██║██║ ╚═╝ ██║"
          "╚═╝  ╚═══╝╚═╝╚═╝  ╚═╝  ╚═══╝  ╚═╝╚═╝     ╚═╝"
        ];
        packages.enable = false;
        mru.cwd_only = true;
      };
    };
  };
}
