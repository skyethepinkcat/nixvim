{
  inputs,
  pkgs,
  lib,
  ...
}:
let
  skyepkgs = inputs.skyepkgs.packages.${pkgs.stdenv.hostPlatform.system};
in
{
  plugins.lspconfig.enable = true;
  plugins.tiny-inline-diagnostic.enable = true;
  # plugins.lsp-lines.enable = true;
  lsp = {
    inlayHints.enable = true;
    servers = {
      nil_ls = {
        enable = true;
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
      };
    };
  };
}
