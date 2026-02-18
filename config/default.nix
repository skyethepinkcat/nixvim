{
  inputs,
  lib,
  ...
}:
{
  # Import all your configuration modules here
  imports = [
    ./nvix
    ./keymap.nix
    ./neovide.nix
    ./plugins
  ];

  colorschemes.catppuccin = {
    enable = true;
    settings = {
      integrations = {
        blink_cmp.enabled = true;
        blink_indent.enabled = true;
        ghost.enabled = true;
        noice.enabled = true;
        snacks.enabled = true;
        native_lsp = {
          enabled = true;
          underlines = {
            errors = [ "undercurl" ];
            hints = [ "undercurl" ];
            warnings = [ "undercurl" ];
            information = [ "undercurl" ];
          };
        };
      };
      flavor = "mocha";
      italic = true;
      bold = true;
      dimInactive = false;
      transparent_background = lib.mkForce false;
    };
  };

  nvix.transparent = false;
  globals = {
    mapleader = " ";
    maplocalleader = ",";
    loaded_netrw = 1;
    loaded_netrwPlugin = 1;
  };
  opts = {
    # Ignore case in search patterns
    ignorecase = true;

    # Infer casing on word completion
    infercase = true;

    # Show line numbers
    number = true;

    # Display line numbers relative to current line
    relativenumber = true;

    # Number of spaces to use for indentation
    shiftwidth = 2;

    # Override ignorecase if search pattern contains uppercase characters
    smartcase = true;

    # Number of spaces to represent a <Tab>
    tabstop = 2;

    # Set window title to the filename
    title = true;

    # Save undo history to undo file (in $XDG_STATE_HOME/nvim/undo)
    undofile = true;
  };
}
