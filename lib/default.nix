{ lib, ... }:
let
  inherit (lib.nixvim) mkRaw;
  namespaces = {
    telescope = import ./telescope.nix { inherit lib mkRaw; };
  };
in
{
  _module.args.lib = lib.extend (_: prev: {
    nixvim = prev.nixvim // namespaces;
  });
}
