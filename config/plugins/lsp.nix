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
  plugins = {
    lspconfig.enable = true;
    tiny-inline-diagnostic.enable = true;
    lsp-lines.enable = true;
  };

  lsp = {
    inlayHints.enable = true;
    servers = {
      nixd = {
        enable = true;
        config = {
          nixpkgs = {
            expr = "import (builtins.getFlake \"nixpkgs\").{ }";
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
