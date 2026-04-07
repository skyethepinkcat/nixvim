{
  config,
  lib,
  ...
}:
let
  inherit (lib) mkOption;

  # Creates a which-key object from our key object using the nvix function
  mkwKey =
    key:
    (
      {
        __unkeyed_1 = key.key;
        __unkeyed_2 = key.action;
        inherit (key)
          icon
          desc
          group
          hidden
          proxy
          cond
          remap
          silent
          ;
      }
      // key.extraWhichOpts
    );
in
{
  config = {
    # This is used to define functions
    lib.keys = {
      # Create a key object with defaults and basic arg checking.
      keyObj =
        {
          key,
          action,
          icon ? null,
          desc ? null,
          mode ? "n",
          hidden ? false,
          group ? null,
          proxy ? null,
          cond ? null,
          expand ? null,
          remap ? true,
          noremap ? true,
          silent ? true,
          extraVimOpts ? { },
          extraWhichOpts ? { },
        }:
        {
          inherit
            key
            action
            desc
            mode
            icon
            hidden
            group
            extraVimOpts
            extraWhichOpts
            cond
            proxy
            expand
            remap
            noremap
            silent
            ;
        };
    };

    wKeyList = map mkwKey config.keyList;

  };
  options = {

    keyList = mkOption {
      type = lib.types.listOf lib.types.attrs;
      default = [ ];
      description = "List of key objects to be converted into which-key and keymap entries.";
      example =
        # nix
        ''
          keyList = [
            (keyObj {
              action = "z=";
              key = "<leader>cs";
              icon = "󰓆";
              desc = "Spelling Suggestions";
            })
          ];
        '';
    };

    lib.keys.keyObj = mkOption {
      type = lib.types.anything;
    };

  };

}
