{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (config.lib.telescope) openPicker;
  inherit (lib.nixvim) mkRaw;
in
{
  plugins.dashboard = {
    enable = true;
    # package = pkgs.vimUtils.buildVimPlugin {
    #   pname = "dashboard-nvim";
    #   version = "0-unstable-2026-04-14";
    #   src = pkgs.fetchFromGitHub {
    #     owner = "skyethepinkcat";
    #     repo = "dashboard-nvim";
    #     rev = "0eda18b79813745203a57c1e26a058c2df8b573e";
    #     hash = "sha256-ElzyvHxlbn6zoCvbWZseV2DUIIrChkuXNR1BOeWV+QU=";
    #   };
    #   meta.homepage = "https://github.com/nvimdev/dashboard-nvim/";
    #   meta.hydraPlatforms = [ ];
    # };
    # luaConfig.content =
    #   # lua
    #   ''
    #     require("dashboard").setup({
    #       config = {
    #         project = {
    #           shortcut_type = "letter",
    #         },
    #       },
    #     })
    #   '';
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
