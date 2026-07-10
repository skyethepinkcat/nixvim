{
  pkgs,
  config,
  inputs,
  ...
}:
let
  puppet_grammar = pkgs.tree-sitter.buildGrammar {
    language = "puppet";
    version = "1.3.0+rev=personal-fixes";
    src = pkgs.fetchFromGitHub {
      owner = "skyethepinkcat";
      repo = "tree-sitter-puppet";
      rev = "personal-fixes";
      hash = "sha256-xi06RST1YtJ6F5uJ19/BQK1gemeo19sRHalBeUwYmVM=";
    };
    meta.homepage = "https://github.com/skyethepinkcat/tree-sitter-puppet";
  };
in
{

  extraPlugins = [
    puppet_grammar
    (pkgs.vimUtils.buildVimPlugin {
      name = "my-nix-injections";
      src =
        pkgs.writeTextDir "queries/nix/injections.scm"
          # scm
          ''
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
  plugins = {
    treesitter = {
      enable = true;
      highlight.enable = true;
      indent.enable = true;
      folding.enable = true;
      grammarPackages =
        (builtins.filter (
          plugin: plugin.language != "puppet"
        ) config.plugins.treesitter.package.allGrammars)
        ++ [
          puppet_grammar
        ];
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
