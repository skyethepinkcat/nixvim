{
  pkgs,
  config,
  ...
}:
{

  extraPlugins = [
    (pkgs.vimUtils.buildVimPlugin {
      name = "my-nix-injections";
      src = pkgs.writeTextDir "queries/nix/injections.scm" ''
        ; extends
        (apply_expression
          function: (_) @_func
          argument: [
            (string_expression (string_fragment) @injection.content)
            (indented_string_expression (string_fragment) @injection.content)
          ]
          (#match? @_func "(^|\\.)mkFunc$")
          (#set! injection.language "lua"))
      '';
    })
  ];
  extraFiles."queries/nix/myinjections.scm".source = ./injections.scm;
  plugins = {
    treesitter = {
      enable = true;
      settings = {
        highlight.enable = true;
        indent.enable = false;
        folding.enable = true;
        grammarPackages = pkgs.vimPlugins.nvim-treesitter.allGrammars;
        autoLoad = true;
      };
    };
    treesitter-context = {
      enable = true;
      settings = {
        max_lines = 4;
        min_window_height = 40;
      };
    };
    treesitter-textobjects = {
      enable = true;
    };
    # tpope's indent fixes
    sleuth.enable = true;
  };
}
