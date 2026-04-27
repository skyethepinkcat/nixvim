{
  lib,
  config,
  pkgs,
  ...
}:
{
  # Import all your configuration modules here
  imports =
    (
      with builtins;
      with lib;
      map (fn: ./${fn}) (
        filter (fn: (fn != "default.nix" && hasSuffix ".nix" "${fn}")) (attrNames (readDir ./.))
      )
    )
    ++ [
      ./profiles
      ./nvix
      ./keymap.nix
      ./neovide.nix
      ./plugins
    ];

  nvix.transparent = false;
  globals = {
    mapleader = " ";
    maplocalleader = ",";

    # These are *disabling* netrw, by telling vim its already loaded.
    loaded_netrw = 1;
    loaded_netrwPlugin = 1;
  };
  opts = {
    background = "dark";
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

    scrolloff = 5;

    spelllang = "en_us" ;
    spell = true;
  };
  keyList = [
    (config.lib.keys.keyObj {
      action = "<cmd>b#<cr>";
      key = "<leader><tab>";
      icon = "";
      desc = "Last Buffer";
    })
  ];
  withPython3 = true;
  withPerl = true;
  withNodeJs = true;
  dependencies.tree-sitter = {
    enable = true;
    package = pkgs.tree-sitter;
  };
}
