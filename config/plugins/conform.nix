{ pkgs, ... }:
{
  plugins.conform-nvim = {
    enable = true;
    settings = {
      formatters_by_ft = {
        lua = [ "stylua" ];
        nix = [
          "nixfmt"
          "nix_flake_fmt"
        ];
        yaml = [ "yamlfix" ];
        ruby = [ "rubocop" ];
        puppet = [ "puppet_lint" ];
        javascript = [ "biome" ];
        javascriptreact = [ "biome" ];
        typescript = [ "biome" ];
        typescriptreact = [ "biome" ];
        json = [ "biome" ];
        jsonc = [ "biome" ];
      };
      format_on_save = {
        timeout_ms = 3000;
        lsp_fallback = true;
      };
    };
    formatters = {
      rubocop = {
        package = null;
      };
      puppet_lint = {
        package = null;
      };
    };
  };
}
