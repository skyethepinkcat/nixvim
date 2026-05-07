{ config, ... }:
let
  inherit (config.nvix.mkKey) wKeyObj;
  inherit (config.lib.keys) keyObj;
in
{
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
    (keyObj {
      action = "<ESC>^i";
      key = "<C-b>";
      mode = "i";
      desc = "move beginning of line";
    })
    (keyObj {
      action = "<End>";
      key = "<C-e>";
      mode = "i";
      desc = "move end of line";
    })
    (keyObj {
      action = "<Left>";
      key = "<C-h>";
      mode = "i";
      desc = "move left";
    })
    (keyObj {
      action = "<Right>";
      key = "<C-l>";
      mode = "i";
      desc = "move right";
    })
    (keyObj {
      action = "<Down>";
      key = "<C-j>";
      mode = "i";
      desc = "move down";
    })
    (keyObj {
      action = "<Up>";
      key = "<C-k>";
      mode = "i";
      desc = "move up";
    })

    # Window navigation
    (keyObj {
      action = "<C-w>h";
      key = "<C-h>";
      desc = "switch window left";
    })
    (keyObj {
      action = "<C-w>l";
      key = "<C-l>";
      desc = "switch window right";
    })
    (keyObj {
      action = "<C-w>j";
      key = "<C-j>";
      desc = "switch window down";
    })
    (keyObj {
      action = "<C-w>k";
      key = "<C-k>";
      desc = "switch window up";
    })

    # General mappings
    (keyObj {
      action = "<cmd>noh<CR>";
      key = "<Esc>";
      desc = "general clear highlights";
    })
    (keyObj {
      action = "<cmd>w<CR>";
      key = "<C-s>";
      desc = "general save file";
    })
    (keyObj {
      action = "<cmd>%y+<CR>";
      key = "<C-c>";
      desc = "general copy whole file";
    })
    (keyObj {
      action = "<cmd>set nu!<CR>";
      key = "<leader>n";
      desc = "toggle line number";
    })
    (keyObj {
      action = "<cmd>set rnu!<CR>";
      key = "<leader>Tn";
      desc = "toggle relative number";
    })

    # Format keymaps
    (keyObj {
      action = "<cmd>lua vim.lsp.buf.format()<CR>";
      key = "<leader>fm";
      mode = [
        "n"
        "x"
      ];
      desc = "general format file";
    })

    # LSP mappings
    (keyObj {
      action = "<cmd>lua vim.diagnostic.setloclist()<CR>";
      key = "<leader>ld";
      desc = "LSP diagnostic loclist";
    })

    # Buffer mappings
    (keyObj {
      action = "<cmd>enew<CR>";
      key = "<leader>bs";
      desc = "scratch buffer";
    })
    (keyObj {
      action = "<cmd>tabnext<CR>";
      key = "<tab>";
      desc = "tab goto next";
    })
    (keyObj {
      action = "<cmd>tabnew<CR>";
      key = "<leader>tn";
      desc = "tab new";
    })
    (keyObj {
      action = "<cmd>tabprevious<CR>";
      key = "<S-tab>";
      desc = "tab goto prev";
    })
    (keyObj {
      action = "<cmd>bdelete<CR>";
      key = "<leader>bx";
      desc = "buffer close";
    })
    (keyObj {
      action = "<cmd>tabclose<CR>";
      key = "<leader>x";
      desc = "tab close";
    })

    # Comment
    (keyObj {
      action = "gcc";
      key = "<leader>/";
      desc = "toggle comment";
      noremap = false;
    })
    (keyObj {
      action = "gc";
      key = "<leader>/";
      mode = "v";
      desc = "toggle comment";
      noremap = false;
    })

    # Semicolon to command mode
    (keyObj {
      action = ":";
      key = ";";
      desc = "CMD enter command mode";
    })

    # Misc keymaps
    (keyObj {
      action = "q";
      key = "<M-q>";
    })
    (keyObj {
      action = "";
      key = "q";
    })

    # Spelling
    (keyObj {
      action = "z=";
      key = "<leader>cs";
      icon = "󰓆";
      desc = "Spelling Suggestions";
    })
  ];
}
