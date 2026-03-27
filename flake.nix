{
  description = "A Nixvim configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    treefmt-nix.url = "github:numtide/treefmt-nix";

    skyepkgs.url = "github:skyethepinkcat/skyepkgs";
    skyepkgs.inputs.nixpkgs.follows = "nixpkgs";

    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
    };
  };

  outputs =
    {
      nixvim,
      flake-parts,
      treefmt-nix,
      ...
    }@inputs:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];
      imports = [
        treefmt-nix.flakeModule
        ./flake
      ];

      flake.homeModules = {
        nixvim =
          {
            config,
            lib,
            ...
          }:
          {
            imports = [
              nixvim.homeModules.nixvim
            ];
            programs.nixvim = {
              enable = lib.mkDefault true;
              imports = [
                {
                  _module.args = {
                    inherit inputs;
                  };
                }
                ./config
              ];
            };
          };
        default =
          {
            config,
            lib,
            ...
          }:
          {
            imports = [
              nixvim.homeModules.nixvim
            ];
            programs.nixvim = {
              enable = lib.mkDefault true;
              imports = [
                {
                  _module.args = {
                    inherit inputs;
                  };
                }
                ./config
              ];
            };
          };
      };

      perSystem =
        { system, ... }:
        let
          pkgs = import inputs.nixpkgs {
            inherit system;
          };
          nixvimLib = nixvim.lib.${system};
          nixvim' = nixvim.legacyPackages.${system};
          nixvimModule = {
            inherit pkgs;
            module = import ./config; # import the module directly
            # You can use `extraSpecialArgs` to pass additional arguments to your module files
            extraSpecialArgs = {
              inherit inputs;
              # inherit (inputs) foo;
            };
          };
          nvim = nixvim'.makeNixvimWithModule nixvimModule;
          nvim-trivial = nixvim'.makeNixvimWithModule (nixvimModule // {
            module = {
              imports = [
                nixvimModule.module
                ./variants/trivial.nix
              ];
            };
          });
          nixvim-wrapped = pkgs.symlinkJoin {
            name = "nixvim";
            paths = [ nvim ];
            buildInputs = [ pkgs.makeWrapper ];
            postBuild = ''
              rm $out/bin/nvim
              makeWrapper ${nvim}/bin/nvim $out/bin/nixvim
            '';
          };
        in
        {
          checks = {
            # Run `nix flake check .` to verify that your config is not broken
            default = nixvimLib.check.mkTestDerivationFromNixvimModule nixvimModule;
          };

          packages = {
            inherit nvim nvim-trivial;
            # Lets you run `nix run .` to start nixvim
            default = nvim;
            neovim = nvim;
            nixvim = nixvim-wrapped;
            nixvim-print-init = pkgs.writeShellScriptBin "nixvim-print-init" ''
              ${nvim}/bin/nixvim-print-init
            '';
          };

          devShells.default = pkgs.mkShell {
            packages = with pkgs; [
              statix
              nixd
              nixfmt
              lua-language-server
            ];
          };

        };
    };
}
