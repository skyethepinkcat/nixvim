{
  lib,
  pkgs,
  config,
  inputs,
  ...
}:
{
  config = lib.mkIf (pkgs.stdenv.hostPlatform.system == "aarch64-darwin") {
    plugins.japanese-input = {
      enable = true;
    };
  };
}
