{ ... }:
{
  plugins.lualine = {
    enable = true;
    settings = {
      sections = {
        lualine_x = [
          "lsp_status"
          "encoding"
          "fileformat"
          "filetype"
        ];
      };
      tabline = {
        # lualine_a = [
        #   {
        #     __unkeyed-1 = "buffers";
        #     symbols = {
        #       alternate_file = "";
        #     };
        #   }
        # ];
        lualine_b = [ ];
        lualine_c = [ ];
        lualine_x = [ ];
        lualine_y = [ ];
        lualine_z = [ "tabs" ];
      };
    };
  };
}
