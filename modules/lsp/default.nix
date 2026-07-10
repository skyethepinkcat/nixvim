{ lib, utils, ... }:
{
  # Import all your configuration modules here
  imports =
    with builtins;
    with lib;
    map (fn: ./${fn}) (
      filter (fn: (fn != "default.nix" && hasSuffix ".nix" "${fn}") || pathExists ./${fn}/default.nix) (
        attrNames (readDir ./.)
      )
    );
}
