{
  lib,
  pkgs,
  ...
}:
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
          yamllint = {
            enable = true;
            settings = {
              extra_args = [
                "-d"
                (lib.strings.toJSON {
                  yaml-files = [
                    "*.yaml"
                    "*.yml"
                    ".yamllint"
                  ];
                  rules = {
                    anchors = "enable";
                    braces = "enable";
                    brackets = "enable";
                    colons = "enable";
                    commas = "enable";
                    comments = {
                      level = "warning";
                    };
                    comments-indentation = {
                      level = "warning";
                    };
                    document-end = "disable";
                    document-start = {
                      level = "warning";
                    };
                    empty-lines = "enable";
                    empty-values = "disable";
                    float-values = "disable";
                    hyphens = "enable";
                    indentation = "enable";
                    key-duplicates = "enable";
                    key-ordering = "disable";
                    line-length = "disable";
                    new-line-at-end-of-file = "enable";
                    new-lines = "enable";
                    octal-values = "disable";
                    quoted-strings = "disable";
                    trailing-spaces = "enable";
                    truthy = {
                      level = "warning";
                    };
                  };
                })
              ];
            };
          };
          puppet_lint = {
            enable = true;
            package = null;
            settings = {
              method = mkRaw "require('null-ls').methods.DIAGNOSTICS_ON_SAVE";
            };
          };
        };
        formatting = {
          biome.enable = true;
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
          prettier = {
            enable = true;
            disableTsServerFormatter = true;
          };
        };
      };
    };
  };
  extraPackagesAfter = with pkgs; [
    rubocop
  ];
}
