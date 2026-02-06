{
  pkgs,
  config,
  ...
}: {
  plugins.treesitter = {
    enable = true;
    highlight = true;
    indent = true;
    folding = true;
  };
}
