{
  plugins.lsp = {
    enable = true;
    servers = {
      nil_ls = {
        enable = true;
      };
      puppet = {
        enable = true;
        package = null;
      };
      solargraph = {
        enable = true;
      };
    };
  };
}
