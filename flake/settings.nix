{ inputs, ... }:
{
  imports = [
    # Adds perSystem.nixvimConfigurations and flake.nixvimModules outputs.
    # Also declares the nixvim.packages/checks options used below.
    inputs.nixvim.flakeModules.default
  ];

  systems = [
    "x86_64-linux"
    "aarch64-linux"
    "aarch64-darwin"
  ];

  # Automatically derive packages.{default,export} and checks.{default,export}
  # from nixvimConfigurations (defined in packages.nix).
  nixvim = {
    packages.enable = true;
    checks.enable = true;
  };
}
