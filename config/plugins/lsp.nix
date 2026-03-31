{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf optionalDrvAttr;
  cfg = config.profiles.lsp;
  inherit (cfg) packages;
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
      servers = mkIf cfg.enable {

        nixd = {
          inherit (cfg.nix) enable;
          package = optionalDrvAttr packages pkgs.nixd;
        };

        lua_ls = {
          inherit (cfg.lua) enable;
          package = optionalDrvAttr packages pkgs.lua-language-server;
          config = {
            settings = {
              Lua = {
                diagnostics = {
                  globals = lib.optionals cfg.lua.vim-global [ "vim" ];
                };
              };
            };
          };
        };

        clangd = {
          inherit (cfg.cpp) enable;
          package = optionalDrvAttr packages pkgs.clang-tools;
        };

      };
    };
  };

}
