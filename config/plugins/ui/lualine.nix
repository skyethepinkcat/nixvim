{ lib, ... }:
let
  inherit (lib.nixvim) mkRaw;
in
{
  plugins.lualine = {
    enable = true;
    settings = {
      options = {
        globalstatus = true;
      };

      sections = {
        lualine_c = [
          "filename"
          (mkRaw ''
            {
              require("noice").api.status.mode.get,
              cond = require("noice").api.status.mode.has,
              color = { fg = "#ff9e64" },
            }
          '')
        ];
        lualine_x = [
          "lsp_status"
          "encoding"
          "fileformat"
          "filetype"
        ];
      };
      tabline = {
        lualine_a = [
          {
            __unkeyed-1 = "buffers";
            symbols = {
              alternate_file = " ";
            };
          }
        ];
        lualine_b = [ ];
        lualine_c = [ ];
        lualine_x = [ ];
        lualine_y = [ ];
        lualine_z = [
          {
            __unkeyed-1 = "tabs";
            mode = 2;

          }
        ];
      };
    };
  };
}
