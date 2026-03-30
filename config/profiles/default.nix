{
  lib,
  ...
}:
{

  imports =
    with builtins;
    with lib;
    map (fn: ./${fn}) (
      filter (fn: (fn != "default.nix" && hasSuffix ".nix" "${fn}")) (attrNames (readDir ./.))
    );

  options = {
    profiles = {
      full = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Include LSP Configs and other 'large' packages.";
      };
      ai = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Include ai configurations.";
      };
      export = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Strip configurations related to nix.";
      };
    };
  };

}
