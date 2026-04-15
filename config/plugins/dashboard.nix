{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
let
  inherit (config.lib.telescope) openPicker;
  inherit (lib.nixvim) mkRaw;
in
{
  plugins.dashboard = {
    enable = true;
    package = pkgs.vimPlugins.dashboard;
    luaConfig.content =
      # lua
      ''
        require("dashboard").setup({
          config = {
            project = {
              shortcut_type = "letter",
            },
          },
        })
      '';
    settings = {
      shortcut_type = "number";
      config = {
        # project = {
        #   shortcut_type = "letter";
        # };
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
