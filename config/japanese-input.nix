{
  lib,
  pkgs,
  config,
  inputs,
  ...
}:
{
  imports = [ inputs.japanese-input-nvim.nixvimModules.default ];
  plugins.japanese-input = {
    enable = pkgs.stdenv.hostPlatform.system == "aarch64-darwin";
  };
}
