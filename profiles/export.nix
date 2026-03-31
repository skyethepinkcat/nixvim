{ lib, config, ... }:
lib.mkIf config.profiles.export {
  # Variant used for the portable nvim-config-export package.
  # Strips all nix-managed tool references so the generated init.lua contains
  # no /nix/store paths and works on any system with tools in PATH.

  # Skip bundling treesitter parsers — :TSInstall on the target system instead.
  plugins.treesitter.settings.grammarPackages = [ ];

  plugins.none-ls.sources = {
    diagnostics = {
      statix.package = null;
      rubocop.package = null;
      yamllint.package = null;
    };
    formatting = {
      rubocop.package = null;
      stylua.package = null;
      yamlfix.package = null;
      nixfmt.package = null;
    };
  };

  profiles.ai = lib.mkForce false;
  profiles.lsp.packages = lib.mkForce false;
}
