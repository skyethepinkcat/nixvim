{ pkgs, lib, ... }:
let
  pickerMap = key: picker: desc: {
    action = "<cmd>lua require('telescope.builtin').${picker}()<cr>";
    inherit key;
    mode = "n";
    options = {
      inherit desc;
    };
  };
in
{
  extraPlugins = with pkgs.vimPlugins; [
    telescope-symbols-nvim
  ];
  plugins.telescope = {
    enable = true;
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
          "^data/"
          "%.ipynb"
          "^result/"
          "^.direnv"
        ];
      };
      pickers = {
        find_files = {
          selection_caret = " ";
        };
        symbols = {
          theme = "cursor";
        };
      };
    };
  };


  keymaps = [
    (pickerMap "<leader>ff" "find_files" "Find Files")
    (pickerMap "<leader>sg" "live_grep" "Ripgrep")
    (pickerMap "<leader>is" "symbols" "Search Icons")
    (pickerMap "<leader>bb" "buffers" "Search Buffers")
    (pickerMap "<leader>ld" "diagnostics" "LSP Diagnostics")
    (pickerMap "<leader>sh" "help_tags" "Search Help")
  ];

}
