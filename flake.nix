{
  description = "A Nixvim configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
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
      ...
    }@inputs:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];

      flake.homeModules = {
        nixvim =
          {
            config,
            lib,
            pkgs,
            ...
          }:
          {
            imports = [
              nixvim.homeModules.nixvim
            ];
            programs.nixvim = {
              enable = lib.mkDefault true;
              imports = [ ./config ];
            };
          };
        default =
          {
            config,
            lib,
            pkgs,
            ...
          }:
          {
            imports = [
              nixvim.homeModules.nixvim
            ];
            programs.nixvim = {
              enable = lib.mkDefault true;
              imports = [ ./config ];
            };
          };
      };

      perSystem =
        { system, ... }:
        let
          pkgs = inputs.nixpkgs.legacyPackages.${system};
          nixvimLib = nixvim.lib.${system};
          nixvim' = nixvim.legacyPackages.${system};
          nixvimModule = {
            inherit system; # or alternatively, set `pkgs`
            module = import ./config; # import the module directly
            # You can use `extraSpecialArgs` to pass additional arguments to your module files
            extraSpecialArgs = {
              inherit inputs;
              # inherit (inputs) foo;
            };
          };
          nvim = nixvim'.makeNixvimWithModule nixvimModule;
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
            inherit nvim;
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
              nil
              nixfmt
              lua-language-server
            ];
          };

          formatter = pkgs.nixfmt;
        };
    };
}
