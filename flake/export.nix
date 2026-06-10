{
  self,
  inputs,
  ...
}:
{
  perSystem =
    {
      system,
      config,
      pkgs,
      ...
    }:
    let
      mods = self.nixvimModules;
    in
    {
      # Evaluated nixvim configurations. nixvim.packages/checks.enable (settings.nix)
      # automatically derives packages.{default,export} and checks.{default,export}.
      nixvimConfigurations.export = inputs.nixvim.lib.evalNixvim {
        inherit system;
        modules = with mods; [
          default
          export
        ];
        extraSpecialArgs = { inherit inputs; };
      };

      # Extra packages beyond the auto-generated ones.
      packages = rec {
        nixvim-config-export =
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
          let
            nixvimCfg = config.nixvimConfigurations.export.config;
            inherit (nixvimCfg.build) initFile plugins extraFiles;

            # Build a proper vim pack directory using the same mechanism nixvim uses
            # internally. vimUtils.packDir handles transitive plugin dependencies via
            # propagatedBuildInputs, unlike manually iterating the plugin list.
            packDir = pkgs.vimUtils.packDir {
              nixvim = {
                # Creates all the regular plugins pack
                start = map (p: p.plugin) (pkgs.lib.filter (p: !p.optional) plugins);
                # Creates an optional pack for lazy loaded plugins
                opt = map (p: p.plugin) (pkgs.lib.filter (p: p.optional) plugins);
              };
            };
          in
          pkgs.runCommand "nixvim-config-export" { nativeBuildInputs = [ pkgs.gnused ]; } ''
            TMPOUT=.config/nvim
            mkdir -p $TMPOUT
            mkdir -p $TMPOUT
            # Copy the vim-pack-dir derivation (resolving symlinks for portability).
            cp -rL "${packDir}/pack" "$TMPOUT/pack"


            cp -rL '${extraFiles}/.' $TMPOUT
            cp -L '${initFile}' $TMPOUT/init.lua
            # Used to store permissions
            chmod -R u+w "$TMPOUT/"

            # Strip /nix/store/... paths from all Lua files (init.lua + plugins).
            # Plugins patched by nixpkgs may embed store paths for external tools
            # (fzf, ripgrep, etc.); clearing them lets the target system's PATH win.
            # Compiled binaries/shared libs with embedded paths are not fixable here.
            find "$TMPOUT" -type f -exec sed -i 's|"/nix/store/[^"]*"|""|g' {} +

            chmod -R u-w "$TMPOUT/pack"

            mkdir -p $out
            cp -r $TMPOUT/. $out
            # tar -czf $out/nvim.tar.gz $TMPOUT
          '';

        nixvim-config-export-archive = pkgs.runCommand "nixvim-config-export-archive" {
          nativeBuildInputs = [ nixvim-config-export ];
        } ''
        mkdir -p $out
        mkdir -p tmp
        tar -chzf $out/nvim.tar.gz --no-same-permissions -C ${nixvim-config-export} .

        '';
      };
    };
}
