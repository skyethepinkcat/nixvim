{ pkgs, ... }:
{
  plugins.japanese-input = {
    enable = pkgs.stdenv.hostPlatform.system == "aarch64-darwin";
  };
}
