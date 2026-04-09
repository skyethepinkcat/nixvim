{
  description = "A Nixvim configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nixpkgs-edge.url = "nixpkgs/master";
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
      # All .nix files in ./flake/ are auto-imported (see flake/default.nix).
      imports = [ ./flake ];
    };
}
