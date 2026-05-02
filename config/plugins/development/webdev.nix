{ lib, pkgs, ... }: let
  colortils = pkgs.vimUtils.buildVimPlugin {
    name = "colortils.nvim";
    src = pkgs.fetchFromGitHub {
      owner = "max397574";
      repo = "colortils.nvim";
      rev = "948d4eddbd20c3e9eac79368dc50c7929d4fb823";
      sha256 = "03lj24zm48rc7rj69j2z3345k7frrzvn6jqr51d34adkv682180r";
    };
  };
in {
  extraPlugins = [
    colortils
  ];
  plugins.colorizer = {
    enable = true;
    lazyLoad = {
      settings.ft = [
        "html"
        "css"
        "scss"
        "js"
        "php"
        "less"
      ];
    };
  };

  extraConfigLua = ''
    require("colortils").setup()
  '';

  autoCmd = [
    {
      event = "FileType";
      pattern = [ "html" "css" "scss" "less" "javascript" "php" ];
      callback =
        lib.nixvim.mkRaw
          # lua
          ''
            function(ev)
              local opts = function(desc)
                return { buffer = ev.buf, silent = true, desc = desc }
              end
              vim.keymap.set("n", "<LocalLeader>cp", "<cmd>Colortils picker<cr>", opts("Color picker"))
              vim.keymap.set("n", "<LocalLeader>cl", "<cmd>Colortils lighten<cr>", opts("Lighten color"))
              vim.keymap.set("n", "<LocalLeader>cd", "<cmd>Colortils darken<cr>", opts("Darken color"))
              vim.keymap.set("n", "<LocalLeader>cg", "<cmd>Colortils greyscale<cr>", opts("Greyscale color"))
              vim.keymap.set("n", "<LocalLeader>cr", "<cmd>Colortils gradient<cr>", opts("Color gradient"))
              vim.keymap.set("n", "<LocalLeader>cc", "<cmd>Colortils css list<cr>", opts("CSS color list"))
            end
          '';
    }
  ];
}
