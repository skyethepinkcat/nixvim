{ lib, config, ... }:
let
  inherit (config.nvix.mkKey) wKeyObj;
  inherit (config.lib.keys) keyObj;
  inherit (lib) mkOption;
  inherit (lib.types) string boolean attrs oneOf;
  tl = lib.nixvim.toLuaObject;
in
{
  options = {
    #
   #{
   #  key,
   #  action,
   #  icon ? null,
   #  desc ? null,
   #  mode ? "n",
   #  hidden ? false,
   #  group ? null,
   #  proxy ? null,
   #  cond ? null,
   #  expand ? null,
   #  remap ? false,
   #  noremap ? true,
   #  silent ? true,
   #  extraOpts ? { },
   #}:

    keyList = mkOption {
      type = lib.types.listOf lib.types.submodule {
        key = mkOption {
          type = lib.types.string;
          description = "What to bind to.";
          example = "<leader>a";
        };
        action = mkOption {
          type = lib.types.oneOf string attrs;
          description = "Action";
        };
        icon = mkOption {
          type = oneOf string attrs;
          description = "Which-key icon.";
        };
        desc = mkOption {
          type = string;
          description = "Description.";
        };
        mode = mkOption {
          type = string;
          description = "Vim mode this keybind is active in.";
        };

      };
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

  };

}
