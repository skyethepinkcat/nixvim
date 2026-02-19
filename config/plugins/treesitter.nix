{
  pkgs,
  config,
  ...
}:
{
  plugins = {
    treesitter = {
      enable = true;
      settings = {
        highlight.enable = true;
        indent.enable = true;
        folding.enable = true;
        grammarPackages = pkgs.vimPlugins.nvim-treesitter.allGrammars;
        autoLoad = true;
      };
    };
    treesitter-context = {
      enable = true;
      settings = {
        max_lines = 4;
        min_window_height = 40;
      };
    };
    # tpope's indent fixes
    sleuth.enable = true;
  };
}
