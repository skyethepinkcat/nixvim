{
  description = "A Nixvim configuration";

  inputs = {

    treefmt-nix.url = "github:numtide/treefmt-nix";

    skyepkgs = {
      url = "github:skyethepinkcat/skyepkgs";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixvim = {
      url = "github:nix-community/nixvim";
    };

    flake-parts.url = "github:hercules-ci/flake-parts";

    nixpkgs.follows = "nixvim/nixpkgs";

    japanese-input-nvim = {
      url = "github:skyethepinkcat/japanese-input-nvim";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-parts.follows = "flake-parts";
      };
    };
  };

  outputs =
    { flake-parts, ... }@inputs:
    flake-parts.lib.mkFlake { inherit inputs; } {
      # All .nix files in ./flake/ are auto-imported (see flake/default.nix).
      imports = [ ./flake ];
    };
}
