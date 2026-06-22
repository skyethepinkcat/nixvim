{
  description = "A Nixvim configuration";

  inputs = {

    treefmt-nix.url = "github:numtide/treefmt-nix";

    devenv.url = "github:cachix/devenv";

    skyepkgs = {
      url = "github:skyethepinkcat/skyepkgs";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    flake-parts.url = "github:hercules-ci/flake-parts";

    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    japanese-input-nvim = {
      url = "github:skyethepinkcat/japanese-input-nvim";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-parts.follows = "flake-parts";
      };
    };
  };

  nixConfig = {
    extra-trusted-public-keys = "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw=";
    extra-substituters = "https://devenv.cachix.org";
  };

  outputs =
    { flake-parts, ... }@inputs:
    flake-parts.lib.mkFlake { inherit inputs; } {
      # All .nix files in ./flake/ are auto-imported (see flake/default.nix).
      imports = [ ./flake ];
    };
}
