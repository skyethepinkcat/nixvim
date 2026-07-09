{ pkgs, lib, ... }:
{
  plugins.japanese-input = {
    enable = lib.mkDefault pkgs.stdenv.hostPlatform.isDarwin;
  };
}
