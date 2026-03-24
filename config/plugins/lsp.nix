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
    # puppet = {
    #   enable = true;
    #   package = skyepkgs.puppet-editor-services;
    #   config = {
    #     cmd = [
    #       "puppet-languageserver"
    #       "--stdio"
    #     ];
    #   };
    #   packageFallback = false;
    # };
  };
}
