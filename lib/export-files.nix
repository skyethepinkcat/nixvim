{ lib, ... }:
with lib;
{
  options.exportFiles = mkOption {
    description = "Config files to include in the portable export, with store-path-to-stdpath rewrite.";
    type = types.listOf (types.submodule {
      options = {
        source = mkOption { type = types.path; };
        name = mkOption { type = types.str; };
        recursive = mkOption { type = types.bool; default = false; };
      };
    });
    default = [ ];
  };
}
