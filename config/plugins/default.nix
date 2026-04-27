{
  config,
  lib,
  pkgs,
  ...
}:
{
  imports = with builtins;
    with lib;
    map (fn: ./${fn}) (
      filter (fn: (fn != "default.nix" && (hasSuffix ".nix" "${fn}" || pathExists ./${fn}/default.nix))) (
        attrNames (readDir ./.)
      )
    );

  plugins = {
    direnv.enable = true;
    notify.enable = true;
  };
  extraPlugins = with pkgs.vimPlugins; [
    nvim-sops
  ];
}
