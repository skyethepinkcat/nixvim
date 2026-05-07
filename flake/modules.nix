{ inputs, ... }:
{
  # Reusable nixvim modules exposed as flake outputs.
  # Consumed by nixvimConfigurations in packages.nix and importable by other flakes.
  flake.nixvimModules = {
    default = {
      imports = [
        inputs.japanese-input-nvim.nixvimModules.default
        {
          nixpkgs.overlays = [
            inputs.skyepkgs.overlays.default

          ];
        }
        ../config
        ../lib
      ];
    };
    full = {
      profiles.ai = true;
    };
    scratch = {
      imports = [
        ../scratch.nix
      ];
    };
    # Export variant layers on top of the default config, stripping nix-managed
    # tool paths so the generated config is portable to non-Nix systems.
    export = {
      config.profiles.export = true;
    };
  };
}
