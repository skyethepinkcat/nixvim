{ pkgs, inputs, ... }:
{
  imports = [
    inputs.japanese-input-nvim.nixvimModules.default
  ];
  plugins.japanese-input = {
    enable = pkgs.stdenv.hostPlatform.isDarwin;
  };
}
