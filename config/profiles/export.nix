{
  lib,
  config,
  pkgs,
  utils,
  ...
}:
let
  inherit (lib) mkForce;
in
lib.mkIf config.profiles.export {
  # Variant used for the portable nvim-config-export package.
  # Strips all nix-managed tool references so the generated init.lua contains
  # no /nix/store paths and works on any system with tools in PATH.

  # Skip bundling treesitter parsers — :TSInstall on the target system instead.
  plugins = {
    japanese-input.enable = mkForce false;
    treesitter.nixGrammars = mkForce false;
    blink-cmp.settings.fuzzy.implementation = "lua";
    none-ls.sources = {
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
    # Fzf-Native won't work for obvious reasons
    telescope.extensions.fzf-native.enable = mkForce false;
    lazygit.settings.config_file_path = lib.mkForce (
      lib.nixvim.mkRaw ''
        vim.fn.stdpath("config") .. "/lazygit.yaml"
      ''
    );
    # japanese-input.enable = lib.mkForce false;
  };
  extraPlugins = with pkgs.vimPlugins; [
    mason-nvim
    mason-lspconfig-nvim
  ];
  extraConfigLua = ''
    -- Mason: install LSP servers, formatters, and linters on non-Nix systems.
    -- Run :Mason to open the installer UI.
    require("mason").setup()
    require("mason-lspconfig").setup()
  '';
  impureRtp = mkForce true;
}
