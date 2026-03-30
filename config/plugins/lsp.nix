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
          enable = config.profiles.full;
        };
        lua_ls = {
          enable = config.profiles.full;
        };
        clangd = {
          enable = config.profiles.full;
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
