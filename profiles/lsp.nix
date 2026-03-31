{
  lib,
  config,
  ...
}:
let
  cfg = config.profiles.lsp;
in
{
  config.profiles.lsp = {
    lua.enable = lib.mkDefault cfg.enable;
    nix.enable = lib.mkDefault cfg.enable;
    cpp.enable = lib.mkDefault cfg.enable;
  };

  options = {
    profiles = {
      lsp = {

        enable = lib.mkOption {
          description = "LSP Configuration and Packages";
          default = true;
          example = false;
          type = lib.types.bool;
        };
        packages = lib.mkEnableOption "Use Nix Packages";

        lua = {
          enable = lib.mkEnableOption "Lua Lsp Configuration";
          vim-global = lib.mkOption {
            type = lib.types.bool;
            default = true;
            example = false;
            description = "Include 'vim' as a global in diganostics.";
          };
        };

        nix = {
          enable = lib.mkEnableOption "Nix Lsp Configuration";
        };

        cpp = {
          enable = lib.mkEnableOption "C++ Lsp Configuration";
        };

      };
    };
  };
}
