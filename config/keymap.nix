{ lib, config, ... }:
let
  inherit (config.nvix.mkKey) wKeyObj;
  inherit (lib) mkOption;
  tl = lib.nixvim.toLuaObject;
in
{
  config = {
    # Group labels only — no action, must stay as wKeyList
    wKeyList = [
      (wKeyObj [
        "<leader>b"
        ""
        "Buffers"
      ])
      (wKeyObj [
        "<leader><tab>"
        ""
        "Last Buffer"
      ])

    ];

    keyList = [
      # Insert mode navigation
      {
        action = "<ESC>^i";
        key = "<C-b>";
        mode = "i";
        desc = "move beginning of line";
      }
      {
        action = "<End>";
        key = "<C-e>";
        mode = "i";
        desc = "move end of line";
      }
      {
        action = "<Left>";
        key = "<C-h>";
        mode = "i";
        desc = "move left";
      }
      {
        action = "<Right>";
        key = "<C-l>";
        mode = "i";
        desc = "move right";
      }
      {
        action = "<Down>";
        key = "<C-j>";
        mode = "i";
        desc = "move down";
      }
      {
        action = "<Up>";
        key = "<C-k>";
        mode = "i";
        desc = "move up";
      }

      # Window navigation
      {
        action = "<C-w>h";
        key = "<C-h>";
        desc = "switch window left";
      }
      {
        action = "<C-w>l";
        key = "<C-l>";
        desc = "switch window right";
      }
      {
        action = "<C-w>j";
        key = "<C-j>";
        desc = "switch window down";
      }
      {
        action = "<C-w>k";
        key = "<C-k>";
        desc = "switch window up";
      }

      # General mappings
      {
        action = "<cmd>noh<CR>";
        key = "<Esc>";
        desc = "general clear highlights";
      }
      {
        action = "<cmd>w<CR>";
        key = "<C-s>";
        desc = "general save file";
      }
      {
        action = "<cmd>%y+<CR>";
        key = "<C-c>";
        desc = "general copy whole file";
      }
      {
        action = "<cmd>set nu!<CR>";
        key = "<leader>n";
        desc = "toggle line number";
      }
      {
        action = "<cmd>set rnu!<CR>";
        key = "<leader>Tn";
        desc = "toggle relative number";
      }

      # Format keymaps
      {
        action =
          lib.nixvim.mkRaw
            # lua
            ''
              function()
                vim.lsp.buf.format()
              end
            '';
        key = "<leader>fm";
        mode = [
          "n"
          "x"
        ];
        desc = "general format file";
      }

      # LSP mappings
      {
        action = "<cmd>lua vim.diagnostic.setloclist()<CR>";
        key = "<leader>ld";
        desc = "LSP diagnostic loclist";
      }

      # Buffer mappings
      {
        action = "<cmd>enew<CR>";
        key = "<leader>bs";
        desc = "scratch buffer";
      }
      {
        action = "<cmd>enew | setfiletype lua<CR>";
        key = "<leader>bl";
        desc = "lua scratch buffer";
        icon = "";
      }
      {
        action = "<cmd>tabnext<CR>";
        key = "<tab>";
        desc = "tab goto next";
      }
      {
        action = "<cmd>tabnew<CR>";
        key = "<leader>tn";
        desc = "tab new";
      }
      {
        action = "<cmd>tabprevious<CR>";
        key = "<S-tab>";
        desc = "tab goto prev";
      }
      {
        action = "<cmd>bdelete<CR>";
        key = "<leader>bx";
        desc = "buffer close";
      }
      {
        action = "<cmd>tabclose<CR>";
        key = "<leader>x";
        desc = "tab close";
      }

      # Comment
      {
        action = "gcc";
        key = "<leader>/";
        desc = "toggle comment";
        noremap = false;
      }
      {
        action = "gc";
        key = "<leader>/";
        mode = "v";
        desc = "toggle comment";
        noremap = false;
      }
      # Semicolon to command mode
      {
        action = ":";
        key = ";";
        desc = "CMD enter command mode";
      }
      # Spelling
      {
        action = "z=";
        key = "<leader>cs";
        icon = "󰓆";
        desc = "Spelling Suggestions";
      }
    ];

    keymaps = [
      {
        action = "q";
        key = "<A-q>";
        mode = "n";
        options.noremap = true;
      }
      {
        action = "<Nop>";
        key = "q";
        mode = "n";
        options.noremap = true;
      }
    ];
  };

}
