{ lib, config, ... }:
{

  config = lib.mkIf (!config.isDocs) {
    files = lib.concatMapAttrs (name: value: {
      "ftplugin/${name}.lua" = value;
    }) config.ftplugin;
  };

  options = {
    ftplugin = lib.mkOption {
      type = with lib.types; attrsOf anything;
      description = "Filetype specific configurations (wrapper for config.files).";
      default = { };
      example = {
        "lua" = {
          localOpts = {
            tabstop = 4;
            shiftwidth = 4;
            expandtab = true;
          };
        };
      };
    };
  };
}
