{
  config,
  lib,
  ...
}:
let
  inherit (lib) mkOption;
  tl = lib.nixvim.toLuaObject;
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
      remap ? false,
      noremap ? true,
      silent ? true,
      extraOpts ? { },
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
        extraOpts
        cond
        proxy
        expand
        remap
        noremap
        silent
        ;
    };
  # Creates a which-key object from our key object using the nvix function
  mkwKey =
    key:
    (
      {
        __unkeyed_1 = key.key;
        __unkeyed_2 = key.action;
        inherit (key)
          desc
          mode
          icon
          hidden
          group
          cond
          proxy
          expand
          remap
          noremap
          silent
          ;
      }
      // key.extraOpts
    );
  mkftKeyAutocmd = filetype: keys: {
    event = "FileType";
    pattern = filetype;
    callback = lib.nixvim.mkRaw (
      # lua
      ''
        function(ev)
          local wk = require("which-key")
      ''
      + builtins.concatStringsSep "\n" (
        map (
          key:
          # lua
          ''
            wk.add({{${tl key.key}, ${tl key.action},

                mode = ${tl key.mode},
                desc = ${tl key.desc},
                buffer = ev.buf,
                silent = ${tl key.silent},
                remap = ${tl key.remap},
                noremap = ${tl key.noremap},
                icon = ${tl key.icon};
            }})
          '') (map keyObj keys)
      )
      +
        # lua
        ''
          end
        ''
    );

  };
in
{
  config = {
    # This is used to define functions
    lib.keys = {
      # Create a key object with defaults and basic arg checking.
      inherit keyObj;
    };

    wKeyList = map mkwKey config.keyList;
    autoCmd = builtins.attrValues (builtins.mapAttrs mkftKeyAutocmd config.ftKeyList);

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

    ftKeyList = mkOption {
      type = lib.types.attrsOf (lib.types.listOf lib.types.attrs);
      default = { };
      description = "Attrset of filetypes and a corresponding list of keyObjs, which will be loaded when the the corresponding filetype is entered.";
    };

    lib.keys.keyObj = mkOption {
      type = lib.types.anything;
    };

  };

}
