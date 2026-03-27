{ lib, ... }:
{
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

  ai.enable = lib.mkForce false;
}
