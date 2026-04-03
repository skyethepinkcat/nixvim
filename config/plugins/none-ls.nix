{ lib, pkgs, ... }:
let
  inherit (lib.nixvim) mkRaw;
in
{
  plugins = {
    none-ls = {
      enable = true;
      sources = {
        code_actions = {
          statix.enable = true;
        };
        completion = {
          spell.enable = false;
          tags.enable = false;
        };
        diagnostics = {
          statix.enable = true;
          rubocop = {
            enable = true;
            package = null;
          };
          markdownlint.enable = true;
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
          markdownlint.enable = true;
          stylua.enable = true;
          yamlfix.enable = true;
          puppet_lint = {
            enable = true;
            package = null;
          };
          nixfmt.enable = true;
          nix_flake_fmt.enable = true;
        };
        hover = {
          dictionary.enable = true;
          printenv.enable = true;
        };
      };
    };
  };
}
