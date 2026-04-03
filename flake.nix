{
  description = "A Nixvim configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    treefmt-nix.url = "github:numtide/treefmt-nix";

    skyepkgs = {
      url = "github:skyethepinkcat/skyepkgs";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    flake-parts.url = "github:hercules-ci/flake-parts";
  };

  outputs =
    { flake-parts, ... }@inputs:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "aarch64-darwin"
      ];

      imports = [
        # Adds perSystem.nixvimConfigurations and flake.nixvimModules outputs.
        # Also enables the nixvim auto-config options below.
        inputs.nixvim.flakeModules.default
        # All .nix files in ./flake/ are auto-imported (see flake/default.nix).
        ./flake
      ];

      # Automatically derive packages and checks from nixvimConfigurations
      # (defined in flake/nvim.nix). Runs via `nix build` and `nix flake check`.
      nixvim = {
        packages.enable = true;
        checks.enable = true;
      };
    };
}
