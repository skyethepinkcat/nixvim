{ pkgs, ... }:
{
  plugins.japanese-input = {
    enable = pkgs.stdenv.hostPlatform.isDarwin;
  };
}
