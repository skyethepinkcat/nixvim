{
  inputs,
  ...
}:
{
  imports = [ inputs.treefmt-nix.flakeModule ];
  perSystem =
    { pkgs, lib, ... }:
    {
      treefmt = {
        programs = {
          nixfmt = {
            enable = pkgs.lib.meta.availableOn pkgs.stdenv.buildPlatform pkgs.nixfmt.compiler;
            package = pkgs.nixfmt;
          };
          statix = {
            enable = true;
            package = pkgs.statix;
          };
          stylua = {
            enable = true;
            package = pkgs.stylua;
          };
        };
      };
    };
}
