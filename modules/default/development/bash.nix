{ pkgs, ... }:
{
  extraPlugins = [
    (pkgs.vimUtils.buildVimPlugin {
      name = "bash-indent-queries";
      src = pkgs.writeTextDir "queries/bash/indents.scm" ''
        ; extends

        (if_statement) @indent.begin
        (if_statement "fi" @indent.end)

        [
          (elif_clause)
          (else_clause)
        ] @indent.branch
      '';
    })
  ];
}
