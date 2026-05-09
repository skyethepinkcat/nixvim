{
  lib,
  config,
  ...
}:
let
  inherit (lib.nixvim) mkRaw;
in
{
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
      jsonls = {
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

  keyList = [
    {
      key = "<leader>l";
      action = null;
      icon = "";
      group = "lsp";
    }

    {
      action =
        mkRaw
          # lua
          ''
            function ()
              vim.lsp.buf.code_action()
            end
          '';
      key = "<leader>la";
      desc = "Code Action";
    }
    {
      action =
        mkRaw
          # lua
          ''
            function ()
              vim.lsp.buf.rename()
            end
          '';
      key = "<leader>ln";
      desc = "LSP Rename";
    }
    {
      action =
        mkRaw
          # lua
          ''
            function ()
              vim.lsp.buf.implementation()
            end
          '';
      key = "<leader>li";
      desc = "LSP Implementation";
    }
    {
      action =
        mkRaw
          # lua
          ''
            function ()
              vim.lsp.buf.type_definition()
            end
          '';
      key = "<leader>lt";
      desc = "LSP Type Definition";
    }
    {
      action =
        mkRaw
          # lua
          ''
            function ()
              vim.lsp.buf.references()
            end
          '';
      key = "<leader>lr";
      desc = "LSP References";
    }
  ];
}
