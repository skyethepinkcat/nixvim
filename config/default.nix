{
  inputs,
  lib,
  config,
  pkgs,
  ...
}:
let
  pkgs-edge = import inputs.nixpkgs-edge {
    inherit (pkgs.stdenv.hostPlatform) system;
  };
in
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

  colorschemes.catppuccin = {
    enable = true;
    settings = {
      term_colors = true;
      integrations = {
        blink_cmp.enabled = true;
        blink_indent.enabled = true;
        ghost.enabled = true;
        noice.enabled = true;
        which_key.enabled = true;
        mini = {
          enabled = true;
          indentscope_color = "";
        };
        native_lsp = {
          enabled = true;
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

    # These are *disabling* netrw, by telling vim its already loaded.
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

    scrolloff = 5;
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
    package = pkgs-edge.tree-sitter;
  };
}
