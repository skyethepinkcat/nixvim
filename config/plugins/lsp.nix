{ lib, ... }:
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

  keymaps = [
    {
      action =
        lib.nixvim.mkRaw
          # lua
          ''
            function ()
              vim.lsp.buf.code_action()
            end
          '';
      key = "<leader>la";
      mode = "n";
      options = {
        desc = "Code Action";
      };
    }
    {
      action =
        lib.nixvim.mkRaw
          # lua
          ''
            function ()
              vim.lsp.buf.rename()
            end
          '';
      key = "<leader>ln";
      mode = "n";
      options = {
        desc = "LSP Rename";
      };
    }
    {
      action =
        lib.nixvim.mkRaw
          # lua
          ''
            function ()
              vim.lsp.buf.implementation()
            end
          '';
      key = "<leader>li";
      mode = "n";
      options = {
        desc = "LSP Implementation";
      };
    }
    {
      action =
        lib.nixvim.mkRaw
          # lua
          ''
            function ()
              vim.lsp.buf.type_definition()
            end
          '';
      key = "<leader>lt";
      mode = "n";
      options = {
        desc = "LSP Type Definition";
      };
    }
    {
      action =
        lib.nixvim.mkRaw
          # lua
          ''
            function ()
              vim.lsp.buf.references()
            end
          '';
      key = "<leader>lr";
      mode = "n";
      options = {
        desc = "LSP References";
      };
    }
  ];

}
