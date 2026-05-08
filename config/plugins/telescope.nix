{
  pkgs,
  lib,
  config,
  ...
}:
let
  inherit (lib.utils.telescope) openPicker openPickerWithOptions openExtensionPickerWithOptions;
in
{
  extraPlugins = with pkgs.vimPlugins; [
    telescope-symbols-nvim
  ];
  plugins.telescope = {
    enable = true;
    enabledExtensions = [
      "scope"
    ];
    extensions = {
      fzf-native = {
        enable = true;
      };
      ui-select = {
        enable = true;
        settings = {
          __unkeyed-1 = lib.nixvim.mkRaw ''
            require("telescope.themes").get_dropdown {
              -- even more opts
            }
          '';
        };
      };
    };
    settings = {
      defaults = {
        layout_strategy = "flex";
        sorting_strategy = "ascending";
        layout_config = {
          prompt_position = "top";
        };
        file_ignore_patterns = [
          "^.git/"
          "^.mypy_cache/"
          "^__pycache__/"
          "^output/"
          "%.ipynb"
          "^result/"
          "^.direnv"
        ];
      };
      pickers = {
        find_files = {
          selection_caret = " ";
        };
        live_greps = {
          selection_caret = " ";
        };
        symbols = {
          theme = "cursor";
        };
      };
    };
  };

  keyList = [
    {
      action = openPicker "find_files";
      mode = "n";
      key = "<leader>ff";
      icon = "";
      desc = "Search Files";
    }
    {
      action =
        openPickerWithOptions "find_files"
          # lua
          ''{find_command = {"rg", "--files", "--hidden", "--glob", "!**/.git/*"}}'';
      key = "<leader>fF";
      icon = "󰈞";
      desc = "Search Hidden Files";
    }
    {
      action =
        openPickerWithOptions "find_files"
          # lua
          ''{find_command = {"rg", "--files", "--no-ignore", "--hidden", "--glob", "!**/.git/*"}}'';
      key = "<leader>fI";
      icon = "󰈞";
      desc = "Search Ignored Files";
    }
    {
      action = openPicker "live_grep";
      key = "<leader>sg";
      desc = "Search with Grep";
    }
    {
      action =
        openPickerWithOptions "live_grep"
          # lua
          ''{additional_args = {"--hidden"}}'';
      key = "<leader>sG";
      desc = "Search Hidden with Grep";
      icon = "󰈞";
    }
    {
      action = openPicker "symbols";
      key = "<A-s>";
      mode = "i";
      desc = "Search Icons";
      icon = "";
    }
    {
      action = openPicker "symbols";
      desc = "Search Icons";
      key = "<leader>is";
      icon = "";
    }
    {
      action =
        openPickerWithOptions "buffers"
          # lua
          ''
            require('telescope.themes').get_ivy({})
          '';
      desc = "Search Buffers";
      icon = "󱦞";
      key = "<leader>bb";
    }
    {
      action = openPicker "diagnostics";
      desc = "LSP Diagnostics";
      key = "<leader>ld";
    }
    {
      action = openPicker "help_tags";
      desc = "Search Help";
      key = "<leader>sh";
    }
    {
      action = openPicker "keymaps";
      desc = "Search Keymaps";
      key = "<leader>sk";
    }
  ];
}
