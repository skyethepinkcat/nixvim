{
  config,
  lib,
  inputs,
  ...
}:
let
  # Generate modules out of everything in modules/
  modules =
    with builtins;
    with lib;
    genAttrs (attrNames (readDir ../modules)) (module: {
      imports = [
        ../framework
        ../modules/${module}
      ];
      config.nixpkgs.source = inputs.nixpkgs;
    });
in
{
  # Reusable nixvim modules exposed as flake outputs.
  # Consumed by nixvimConfigurations in packages.nix and importable by other flakes.
  flake.nixvimModules = modules;
}
