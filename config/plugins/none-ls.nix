{ lib, ... }:
let
  inherit (lib.nixvim) mkRaw;
in
{
  plugins = {
    none-ls = {
      enable = true;
      sources = {
        diagnostics = {
          statix.enable = true;
          rubocop = {
            enable = true;
            package = null;
          };
          yamllint.enable = true;
          puppet_lint = {
            enable = true;
            package = null;
            settings = {
              method = mkRaw "require('null-ls').methods.DIAGNOSTICS_ON_SAVE";
            };
          };
        };
        formatting = {
          rubocop = {
            enable = true;
            package = null;
          };
          stylua.enable = true;
          yamlfix.enable = true;
          puppet_lint = {
            enable = true;
            package = null;
          };
          nixfmt.enable = true;
          nix_flake_fmt.enable = true;
        };
      };
    };
  };
}
