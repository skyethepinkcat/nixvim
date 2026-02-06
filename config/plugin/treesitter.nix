{
  pkgs,
  config,
  ...
}: {
  plugins.treesitter = {
    enable = true;
  };
}
