{
  lib,
  pkgs,
  utils,
  inputs,
  ...
}:
let
  inherit (utils.telescope) openPicker;
  inherit (lib.nixvim) mkRaw;
  spkgs = inputs.skyepkgs.legacyPackages."${pkgs.stdenv.hostPlatform.system}";
in
{
  plugins.dashboard = {
    enable = true;
    package = spkgs.vimPlugins.dashboard-nvim;
    settings = {
      shortcut_type = "number";
      config = {
        project = {
          enable = false;
        };
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
        packages.enable = true;
        mru.cwd_only = true;
      };
    };
  };
  extraConfigLua =
    #lua
    ''
      vim.opt.shortmess:append("I") -- Disables default intro message
    '';
}
