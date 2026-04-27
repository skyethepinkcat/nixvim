{ pkgs, lib, ... }:
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
          "    filter (fn: (fn != \"default.nix\" && hasSuffix \".nix\" \"\\\${fn}\")) (attrNames (readDir ./.))"
          "  );"
        ];
        description = "Imports all nix files in directory";
      };
    };
  };

  snippetFiles = lib.mapAttrsToList (ft: defs: {
    name = "${ft}.json";
    path = pkgs.writeText "${ft}.json" (builtins.toJSON defs);
  }) snippets;

  packageJson = pkgs.writeText "package.json" (
    builtins.toJSON {
      name = "nixvim-snippets";
      contributes.snippets = lib.mapAttrsToList (ft: _: {
        language = ft;
        path = "./${ft}.json";
      }) snippets;
    }
  );

  snippetPkg = pkgs.linkFarm "nixvim-snippets" (
    [
      {
        name = "package.json";
        path = packageJson;
      }
    ]
    ++ snippetFiles
  );
in
{
  plugins = {
    friendly-snippets.enable = true;
    blink-cmp.settings.sources.providers.snippets.opts.search_paths = [
      (lib.nixvim.mkRaw "vim.fn.stdpath('config') .. '/snippets'")
      snippetPkg
    ];
  };

}
