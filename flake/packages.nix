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
      lib,
      ...
    }:
    let
      # Alias for the auto-generated default package (set by nixvim.packages.enable).
      nvim = config.packages.default;
      mods = self.nixvimModules;
    in
    {
      # Evaluated nixvim configurations. nixvim.packages/checks.enable (settings.nix)
      # automatically derives packages.{default,export} and checks.{default,export}.
      nixvimConfigurations =
        let
          baseModules = {
            default = {
              inherit system;
              modules = with mods; [
                default
                ui
                lsp
                extra
              ];
              extraSpecialArgs = { inherit inputs; };
            };
            full = {
              inherit system;
              modules = with mods; [
                default
                ui
                lsp
                extra
                ai
              ];
              extraSpecialArgs = { inherit inputs; };
            };
            scratch = {
              inherit system;
              modules = with mods; [
                scratch
              ];
              extraSpecialArgs = { inherit inputs; };
            };
            simple = {
              inherit system;
              modules = with mods; [
                default
              ];
              extraSpecialArgs = { inherit inputs; };
            };
          };
        in
        # Create additional modules with export set.
        lib.concatMapAttrs (name: value: {
          "${name}" = inputs.nixvim.lib.evalNixvim value;
        }) baseModules;

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
      };
    };
}
