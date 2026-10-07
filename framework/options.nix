{
  pkgs,
  lib,
  config,
  ...
}:
{
  options.plugins.lazygit.configuration = lib.mkOption {
    type = with lib.types; nullOr attrs;
    default = null;
    description = "Attribute set of lazygit configuration, which gets turned into a yaml file.";
  };
  config = {
    extraFiles."lazygit.yaml".source = lib.mkIf (config.plugins.lazygit.configuration != null) (
      lib.toString (
        pkgs.writeText "config.yaml" (lib.strings.toJSON config.plugins.lazygit.configuration)
      )
    );

    plugins.lazygit.settings = lib.mkIf (config.plugins.lazygit.configuration != null) {
      config_file_path = config.extraFiles."lazygit.yaml".finalSource;
      use_custom_config_file_path = 1;
    };
  };
}
