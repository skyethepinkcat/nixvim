{ lib, config, ... }:
let
  inherit (config.nvix.mkKey) wKeyObj;
  inherit (config.lib.keys) keyObj;
  inherit (lib) mkOption;
  inherit (lib.types) string boolean attrs oneOf nullOr;
  tl = lib.nixvim.toLuaObject;
in
{
  options = {

    keyList = mkOption {
      type = lib.types.listOf (lib.types.submodule {
        options = {
          key = mkOption {
            type = string;
            description = "What to bind to.";
            example = "<leader>a";
          };
          action = mkOption {
            type = oneOf [ string attrs ];
            description = "Action";
          };
          icon = mkOption {
            type = nullOr (oneOf [ string attrs ]);
            default = null;
            description = "Which-key icon.";
          };
          desc = mkOption {
            type = nullOr string;
            default = null;
            description = "Description.";
          };
          mode = mkOption {
            type = string;
            default = "n";
            description = "Vim mode this keybind is active in.";
          };
          hidden = mkOption {
            type = boolean;
            default = false;
            description = "Hide from which-key.";
          };
          group = mkOption {
            type = nullOr string;
            default = null;
            description = "Which-key group name.";
          };
          proxy = mkOption {
            type = nullOr string;
            default = null;
            description = "Which-key proxy key.";
          };
          cond = mkOption {
            type = nullOr (oneOf [ boolean string ]);
            default = null;
            description = "Condition for which-key to show the keybind.";
          };
          expand = mkOption {
            type = nullOr attrs;
            default = null;
            description = "Which-key expand function (as lua string or attrs).";
          };
          remap = mkOption {
            type = boolean;
            default = false;
            description = "Allow remapping.";
          };
          noremap = mkOption {
            type = boolean;
            default = true;
            description = "Non-recursive mapping.";
          };
          silent = mkOption {
            type = boolean;
            default = true;
            description = "Suppress command echo.";
          };
          extraOpts = mkOption {
            type = attrs;
            default = { };
            description = "Extra opts passed to vim.keymap.set.";
          };
        };
      });
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
