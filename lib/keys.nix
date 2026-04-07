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
        __unkeyed = key.key;
        inherit (key)
          icon
          desc
          group
          hidden
          ;
      }
      // key.extraWhichOpts
    );

  # Creates a vim keymap from our key object.
  mkVimKey = key: {
    inherit (key) key action mode;
    options = {
      inherit (key) desc;
      # Pulled from
      silent = true;
      noremap = true;
      remap = true;
    }
    // key.extraVimOpts;
  };
  needsWKey = key: (key.icon != null || key.hidden || key.extraWhichOpts != null);
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
            ;
        };
    };

    # Here we create the actual keymaps.
    keymaps = map mkVimKey config.keyList;

    # which-key is really only used to set icons, so we filter those that don't need them.
    wKeyList = map mkwKey (lib.filter needsWKey config.keyList);

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
