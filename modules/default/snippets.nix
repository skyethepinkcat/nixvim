{
  pkgs,
  lib,
  ...
}:
let
  snippets = {
    nix = {
      importDir = {
        prefix = "imports";
        body = [
          "imports ="
          "  with builtins;"
          "  with lib;"
          "  map (fn: ./\\${"$"}{fn}) ("
          "    filter (fn: (fn != \"default.nix\" && hasSuffix \".nix\" \"\\\${fn}\") || pathExists ./\\\${fn}/default.nix) (attrNames (readDir ./.))"
          "  );"
        ];
        description = "Imports all nix files in directory";
      };
      mkRaw = {
        prefix = "mkRaw";
        body = [
          "inherit (lib.nixvim) mkRaw;"
        ];
        description = "Inherit mkRaw";
      };
    };
  };

in
{
  # Convert the snippets hash to extraFiles
  extraFiles = lib.concatMapAttrs (name: value: {
    "snippets/${name}.json".text = builtins.toJSON value;
  }) snippets;

  plugins = {
    friendly-snippets.enable = true;
    blink-cmp.settings.sources.providers.snippets.opts.search_paths = [
      (lib.nixvim.mkRaw "vim.fn.stdpath('config') .. '/snippets'")
    ];
  };
}
