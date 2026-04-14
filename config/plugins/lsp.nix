{ lib, config, ... }:
let
  inherit (lib.nixvim) mkRaw;
  inherit (config.lib.keys) keyObj;
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

  keyList = [
    (keyObj {
      key = "<leader>l";
      action = null;
      icon = "";
      group = "lsp";
    })

    (keyObj {
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
    })
    (keyObj {
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
    })
    (keyObj {
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
    })
    (keyObj {
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
    })
    (keyObj {
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
    })
  ];

}
