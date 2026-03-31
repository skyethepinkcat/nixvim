{
  config,
  ...
}:
{
  config = {
    plugins = {
      lspconfig.enable = true;
      tiny-inline-diagnostic.enable = true;
      lsp-lines.enable = true;
    };

    lsp = {
      inlayHints.enable = true;
      servers = {
        nixd = {
          enable = true;
        };
        lua_ls = {
          enable = true;
        };
        clangd = {
          enable = true;
        };
      };
      # puppet = {
      #   enable = true;
      #   package = skyepkgs.puppet-editor-services;
      #   config = {
      #     cmd = [
      #       "puppet-languageserver"
      #       "--stdio"
      #     ];
      #   };
      #   packageFallback = false;
      # };
    };
  };

}
