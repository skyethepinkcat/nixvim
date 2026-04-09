_: {
  # Reusable nixvim modules exposed as flake outputs.
  # Consumed by nixvimConfigurations in packages.nix and importable by other flakes.
  flake.nixvimModules = {
    default = {
      imports = [
        ../config
        ../lib
      ];
    };
    # Export variant layers on top of the default config, stripping nix-managed
    # tool paths so the generated config is portable to non-Nix systems.
    export = {
      config.profiles.export = true;
      imports = [
        ../config
        ../lib
      ];
    };
  };
}
