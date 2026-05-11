{ pkgs, ... }:
{
  extraPlugins = [
    (pkgs.vimUtils.buildVimPlugin {
      name = "chess";
      src = pkgs.fetchFromGitHub {
        repo = "nvim-chess";
        owner = "linuxswords";
        rev = "v0.6.0";
        hash = "sha256-YIkdXLDbU8ThrLwc0JXefkbm45K+/auoPmpVtj2Djw0=";
      };
      dependencies = [ pkgs.vimPlugins.plenary-nvim ];
    })

  ];
  extraConfigLua =
    # lua
    ''
      require("nvim-chess").setup({})

    '';
}
