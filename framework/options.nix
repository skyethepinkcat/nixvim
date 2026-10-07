{
  pkgs,
  lib,
  config,
  ...
}:
{
  options.plugins.lazygit.configuration = lib.mkOption {
    type = with lib.types; nullOr (attrsOf anything);
    default = null;
    description = "Attribute set of lazygit configuration, which gets turned into a yaml file.";
    example = {
      gui = {
        theme = {
          activeBorderColor = [
            "#89b4fa"
            "bold"
          ];
          inactiveBorderColor = [ "#a6adc8" ];
        };
      };
    };
  };
  config =
    let
      # toYAML and toJSON are the same, so just use toJSON here.
      lazygit_config_file = pkgs.writeText "config.yaml" (
        lib.strings.toJSON config.plugins.lazygit.configuration
      );
    in
    {
      extraFiles."lazygit.yaml".source =
        lib.mkIf (config.plugins.lazygit.configuration != null)
          "${lazygit_config_file}";

      plugins.lazygit.settings = lib.mkIf (config.plugins.lazygit.configuration != null) {
        config_file_path = config.extraFiles."lazygit.yaml".finalSource;
        use_custom_config_file_path = 1;
      };
    };
}
