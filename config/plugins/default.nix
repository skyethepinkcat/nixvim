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
      sources = {
        diagnostics = {
          statix.enable = true;
          rubocop.enable = true;
          puppet_lint.enable = true;
        };
        formatting = {
          rubocop.enable = true;
          stylua.enable = true;
          puppet_lint.enable = true;
          # nixfmt.enable = true;
          nix_flake_fmt.enable = true;
        };
      };
    };
    snacks.enable = true;
    direnv.enable = true;
  };
}
