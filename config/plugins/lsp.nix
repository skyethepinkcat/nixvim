{
  inputs,
  pkgs,
  lib,
  ...
}:
let
  inherit (lib.nixvim) mkRaw;
  skyepkgs = inputs.skyepkgs.packages.${pkgs.stdenv.hostPlatform.system};
in
{
  plugins.lspconfig.enable = true;
  plugins.tiny-inline-diagnostic.enable = true;
  # plugins.lsp-lines.enable = true;
  lsp = {
    inlayHints.enable = true;
    servers = {
      nixd = {
        enable = true;
        config = {
          nixpkgs = {
            expr = "import (builtins.getFlake \"nixpkgs\").{ }";
          };
          formatting = {
            command = [
              "nix fmt"
              "treefmt"
              "nixfmt"
            ];
          };
          options = {
            nixos = {
              expr =
                mkRaw
                  # lua
                  ''
                    string.format("(builtins.getFlake (\"%s/Configuration/nix\")).nixosConfigurations.honnoji.options", os.getenv("HOME"))
                  '';
            };
            # nix-darwin = {
            #   expr =
            #     mkRaw
            #       # lua
            #       ''
            #         string.format("(builtins.getFlake (\"%s/Configuration/nix\")).darwinConfigurations.lydian.options", os.getenv("HOME"))
            #       '';
            # };
            home-manager = {
              expr =
                mkRaw
                  # lua
                  ''
                    string.format("(builtins.getFlake (builtins.toString \"%s/Configuration/home-manager\")).homeConfigurations.%s.options", os.getenv("HOME"), os.getenv("USER"))
                  '';
            };
            # nixvim = {
            #   expr = mkRaw
            #       ''
            #         string.format("(builtins.getFlake (builtins.toString \"%s/Configuration/nixvim\")).options", os.getenv("USER"))
            #       '';
            # };
            #
          };
        };
      };
      puppet = {
        enable = true;
        package = skyepkgs.puppet-editor-services;
        config = {
          cmd = [
            "puppet-languageserver"
            "--stdio"
          ];
        };
        packageFallback = false;
      };
      statix.enable = true;
      lua_ls.enable = true;

      solargraph = {
        enable = true;
        packageFallback = true; # Prefer any already installed solargraph
      };
    };
  };
}
