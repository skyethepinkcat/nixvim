{
  imports = [
    ./bufdelete.nix
    ./bufferline.nix
    ./codecompanion.nix
    ./conform.nix
    ./gitblame.nix
    ./toggleterm.nix
    ./lsp.nix
    ./treesitter.nix
  ];
  # Plugins with minimal configuration
  plugins = {
    lualine = {
      enable = true;
    };
    neogit = {
      enable = true;
    };
    nvim-tree = {
      enable = true;
      openOnSetup = true;
      settings = {
        hijack_cursor = true;
        disable_netrw = true;
        update_focused_file = {
          enable = true;
          update_root = false;
        };
        renderer = {
          root_folder_label = false;
        };
      };
    };
    telescope = {
      enable = true;
      extensions.ui-select.enable = true;
    };
    which-key = {
      enable = true;
    };
  };
}
