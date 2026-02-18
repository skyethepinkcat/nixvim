{
  plugins.lspconfig.enable = true;
  plugins.tiny-inline-diagnostic.enable = true;
  # plugins.lsp-lines.enable = true;
  lsp = {
    inlayHints.enable = true;
    servers = {
      nil_ls = {
        enable = true;
      };
      puppet = {
        enable = true;
        package = null;
        packageFallback = true;
      };
      statix.enable = true;
      lua_ls.enable = true;

      solargraph = {
        enable = true;
      };
    };
  };
}
