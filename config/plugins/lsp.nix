{
  inputs,
  pkgs,
  lib,
  config,
  ...
}:
let
  inherit (lib.nixvim) mkRaw;
  cfg = config.programs.nixvim.lsp;
in
{
  config = {
    plugins = {
      lspconfig.enable = true;
      tiny-inline-diagnostic.enable = true;
      lsp-lines.enable = true;
    };

    lsp = {
      inlayHints.enable = true;
      servers = {
        nixd = {
          enable = cfg.full;
        };
        lua_ls = {
          enable = cfg.full;
        };
        clangd = {
          enable = cfg.full;
        };
      };
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
  };

  options = {
    programs.nixvim.lsp.full = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Include LSP Configs";
    };
  };

}
