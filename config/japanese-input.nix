{
  lib,
  pkgs,
  config,
  inputs,
  ...
}:
{

  imports = [ ];

  plugins.japanese-input = {
    enable = true;
  };
}
