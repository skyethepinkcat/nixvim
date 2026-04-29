_: {
  plugins.tabby = {
    enable = true;
    settings = {
      option = {
        lualine_theme = "auto";
      };
    };
  };
  plugins.lualine = {
    enable = true;
    settings = {
      options = {
        globalstatus = true;
      };

      sections = {
        lualine_x = [
          "lsp_status"
          "encoding"
          "fileformat"
          "filetype"
        ];
      };
    };
  };
}
