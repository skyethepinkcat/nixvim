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
    none-ls = {
      enable = true;
      sources.diagnostics.rubocop.enable = true;
      sources.formatting.rubocop.enable = true;
    };
    snacks.enable = true;
    direnv.enable = true;
  };
}
