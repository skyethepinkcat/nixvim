{inputs, ...}: {
  # Import all your configuration modules here
  imports =
    (with inputs.nvix.nvixPlugins; [
      common
      lualine
      lsp
      ai
      blink-cmp
      treesitter
      ux
      lang
      snacks
    ])
    ++ [
      ./autocmds.nix
      ./keymap.nix
      ./neovide.nix
      ./plugin/plugins.nix
    ];
  colorschemes.catppuccin.enable = true;
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
