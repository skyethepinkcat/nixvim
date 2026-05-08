{ lib, config, ... }:
let
  inherit (lib) mkOption;
  inherit (lib.types)
    str
    bool
    attrs
    oneOf
    nullOr
    listOf
    rawLua
    ;
  tl = lib.nixvim.toLuaObject;

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
          '') keys
      )
      +
        # lua
        ''
          end
        ''
    );

  };

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

  keyObj = lib.types.submodule {
    options = {
      key = mkOption {
        type = str;
        description = "What key to bind to.";
        example = "<leader>a";
      };
      action = mkOption {
        type = nullOr (oneOf [
          str
          rawLua
        ]);
        description = "The action to be taken.";
      };
      icon = mkOption {
        type = nullOr (oneOf [
          str
          rawLua
        ]);
        default = null;
        description = "Which-key icon.";
      };
      desc = mkOption {
        type = nullOr str;
        default = null;
        description = "Description.";
      };
      mode = mkOption {
        type = oneOf [
          str
          (listOf str)
        ];
        default = "n";
        description = "Vim mode this keybind is active in.";
      };
      hidden = mkOption {
        type = bool;
        default = false;
        description = "Hide from which-key.";
      };
      group = mkOption {
        type = nullOr str;
        default = null;
        description = "Which-key group name.";
      };
      proxy = mkOption {
        type = nullOr str;
        default = null;
        description = "Which-key proxy key.";
      };
      cond = mkOption {
        type = nullOr (oneOf [
          bool
          str
          rawLua
        ]);
        default = null;
        description = "Condition for which-key to show the keybind.";
      };
      expand = mkOption {
        type = nullOr rawLua;
        default = null;
        description = "Which-key expand function.";
      };
      remap = mkOption {
        type = bool;
        default = false;
        description = "Allow remapping.";
      };
      noremap = mkOption {
        type = bool;
        default = true;
        description = "Non-recursive mapping.";
      };
      silent = mkOption {
        type = bool;
        default = true;
        description = "Suppress command echo.";
      };
      extraOpts = mkOption {
        type = attrs;
        default = { };
        description = "Extra opts passed to vim.keymap.set.";
      };
    };
  };
in
{
  config = {
    wKeyList = map mkwKey config.keyList;
    autoCmd = builtins.attrValues (builtins.mapAttrs mkftKeyAutocmd config.ftKeyList);
  };
  options = {

    keyList = mkOption {
      type = listOf keyObj;
      default = [ ];
      description = "List of key objects to be converted into which-key and keymap entries.";
      example =
        # nix
        ''
          keyList = [
             {
              action = "z=";
              key = "<leader>cs";
              icon = "󰓆";
              desc = "Spelling Suggestions";
            }
          ];
        '';
    };

    ftKeyList = mkOption {
      type = lib.types.attrsOf (listOf keyObj);
      default = { };
      description = "Attrset of filetypes and a corresponding list of key
      objects, which will be loaded when the the corresponding filetype is entered.";
    };

  };

}
