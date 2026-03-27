{ self, inputs, ... }:
{
  # Reusable nixvim modules exposed as flake outputs.
  # Consumed by nixvimConfigurations below and importable by other flakes.
  flake.nixvimModules = {
    default = ../config;
    # Trivial variant layers on top of the default config.
    trivial.imports = [
      ../config
      ../variants/trivial.nix
    ];
  };

  perSystem =
    { system, config, pkgs, ... }:
    let
      # Alias for the auto-generated default package (set by nixvim.packages.enable).
      nvim = config.packages.default;
    in
    {
      # Evaluated nixvim configurations. nixvim.packages/checks.enable (flake.nix)
      # automatically derives packages.{default,trivial} and checks.{default,trivial}.
      nixvimConfigurations = {
        default = inputs.nixvim.lib.evalNixvim {
          inherit system;
          modules = [ self.nixvimModules.default ];
          extraSpecialArgs = { inherit inputs; };
        };
        trivial = inputs.nixvim.lib.evalNixvim {
          inherit system;
          modules = [ self.nixvimModules.trivial ];
          extraSpecialArgs = { inherit inputs; };
        };
      };

      # Extra packages beyond the auto-generated ones.
      packages = {
        # Alias: `nix build .#neovim`
        neovim = nvim;
        # Wrapper that exposes the binary as `nixvim` instead of `nvim`.
        nixvim = pkgs.symlinkJoin {
          name = "nixvim";
          paths = [ nvim ];
          buildInputs = [ pkgs.makeWrapper ];
          postBuild = ''
            rm $out/bin/nvim
            makeWrapper ${nvim}/bin/nvim $out/bin/nixvim
          '';
        };
        # Prints the generated init.lua: `nix run .#nixvim-print-init`
        nixvim-print-init = pkgs.writeShellScriptBin "nixvim-print-init" ''
          ${nvim}/bin/nixvim-print-init
        '';

        # Portable export for use on non-Nix systems.
        #
        # Produces a directory you can copy to ~/.config/nvim/:
        #   init.lua         — full generated config (tree-sitter paths stripped)
        #   pack/nixvim/start/... — all plugins (+ deps), ready for Vim's package loader
        #
        # Note: tree-sitter parsers are not included. Run :TSInstall on the target.
        # Note: external tools (LSPs, formatters) must be installed separately.
        #
        # Usage:
        #   nix build .#nvim-config-export
        #   cp -r result/ ~/.config/nvim
        nvim-config-export =
          let
            nixvimCfg = config.nixvimConfigurations.default.config;
            inherit (nixvimCfg.build) initSource plugins;
            # Extra plugins added only in the portable export (absent from nixvim config).
            exportExtraPlugins = with pkgs.vimPlugins; [
              # Mason is excluded from nixvim (nix manages tools), but useful on non-Nix
              # systems for installing LSP servers, formatters, and linters via :Mason.
              mason-nvim
              mason-lspconfig-nvim
            ];
            # Build a proper vim pack directory using the same mechanism nixvim uses
            # internally. vimUtils.packDir handles transitive plugin dependencies via
            # propagatedBuildInputs, unlike manually iterating the plugin list.
            packDir = pkgs.vimUtils.packDir {
              nixvim = {
                start =
                  map (p: p.plugin) (pkgs.lib.filter (p: !p.optional) plugins)
                  ++ exportExtraPlugins;
                opt = map (p: p.plugin) (pkgs.lib.filter (p: p.optional) plugins);
              };
            };
            masonSetup = pkgs.writeText "mason-setup.lua" ''

              -- Mason: install LSP servers, formatters, and linters on non-Nix systems.
              -- Run :Mason to open the installer UI.
              require("mason").setup()
              require("mason-lspconfig").setup()
            '';
          in
          pkgs.runCommand "nvim-config-export"
            { nativeBuildInputs = [ pkgs.gnused ]; }
            ''
              mkdir -p "$out"
              # Copy the vim-pack-dir derivation (resolving symlinks for portability).
              cp -rL "${packDir}/pack" "$out/pack"
              chmod -R u+w "$out/"

              # Strip /nix/store/... paths from all Lua files (init.lua + plugins).
              # Plugins patched by nixpkgs may embed store paths for external tools
              # (fzf, ripgrep, etc.); clearing them lets the target system's PATH win.
              # Compiled binaries/shared libs with embedded paths are not fixable here.
              find "$out" -type f -name "*.lua" -exec sed -i 's|"/nix/store/[^"]*"|""|g' {} +
              sed 's|"/nix/store/[^"]*"|""|g' "${initSource}" > "$out/init.lua"
              cat ${masonSetup} >> "$out/init.lua"
            '';
      };

      # `nix develop` — tools for editing this config
      devShells.default = pkgs.mkShell {
        packages = with pkgs; [
          statix
          nixd
          nixfmt
          lua-language-server
        ];
      };
    };
}
