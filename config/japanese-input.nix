{
  lib,
  pkgs,
  config,
  inputs,
  ...
}:
{

  imports = [ inputs.japanese-input-nvim.nixvimModules.default ];

  config.plugins.japanese-input = {
    enable = true;
  };
}
