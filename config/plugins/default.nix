{
  config,
  lib,
  ...
}:
let
  inherit (lib.nixvim) mkRaw;
in
{
  imports =
    (
      with builtins;
      with lib;
      map (fn: ./${fn}) (
        filter (fn: (fn != "default.nix" && hasSuffix ".nix" "${fn}")) (attrNames (readDir ./.))
      )
    )
    ++ [
      ./ai
      ./ui
    ];

  plugins = {
    snacks.enable = true;
    direnv.enable = true;
  };
}
