{...}: {
  keymaps = [
    # Insert mode navigation
    {
      action = "<ESC>^i";
      key = "<C-b>";
      mode = "i";
      options = {
        desc = "move beginning of line";
      };
    }
    {
      action = "<End>";
      key = "<C-e>";
      mode = "i";
      options = {
        desc = "move end of line";
      };
    }
    {
      action = "<Left>";
      key = "<C-h>";
      mode = "i";
      options = {
        desc = "move left";
      };
    }
    {
      action = "<Right>";
      key = "<C-l>";
      mode = "i";
      options = {
        desc = "move right";
      };
    }
    {
      action = "<Down>";
      key = "<C-j>";
      mode = "i";
      options = {
        desc = "move down";
      };
    }
    {
      action = "<Up>";
      key = "<C-k>";
      mode = "i";
      options = {
        desc = "move up";
      };
    }

    # Window navigation
    {
      action = "<C-w>h";
      key = "<C-h>";
      mode = "n";
      options = {
        desc = "switch window left";
      };
    }
    {
      action = "<C-w>l";
      key = "<C-l>";
      mode = "n";
      options = {
        desc = "switch window right";
      };
    }
    {
      action = "<C-w>j";
      key = "<C-j>";
      mode = "n";
      options = {
        desc = "switch window down";
      };
    }
    {
      action = "<C-w>k";
      key = "<C-k>";
      mode = "n";
      options = {
        desc = "switch window up";
      };
    }

    # General mappings
    {
      action = "<cmd>noh<CR>";
      key = "<Esc>";
      mode = "n";
      options = {
        desc = "general clear highlights";
      };
    }
    {
      action = "<cmd>w<CR>";
      key = "<C-s>";
      mode = "n";
      options = {
        desc = "general save file";
      };
    }
    {
      action = "<cmd>%y+<CR>";
      key = "<C-c>";
      mode = "n";
      options = {
        desc = "general copy whole file";
      };
    }
    {
      action = "<cmd>set nu!<CR>";
      key = "<leader>n";
      mode = "n";
      options = {
        desc = "toggle line number";
      };
    }
    {
      action = "<cmd>set rnu!<CR>";
      key = "<leader>rn";
      mode = "n";
      options = {
        desc = "toggle relative number";
      };
    }
    # Format keymaps
    {
      action = "<cmd>lua require('conform').format({ lsp_fallback = true })<CR>";
      key = "<leader>fm";
      mode = ["n" "x"];
      options = {
        desc = "general format file";
      };
    }
    {
      action = "<cmd>FormatEnable<cr>";
      key = "<leader>Fe";
      mode = "n";
      options = {
        desc = "Enable autoformat-on-save";
      };
    }
    {
      action = "<cmd>FormatDisable<cr>";
      key = "<leader>Fd";
      mode = "n";
      options = {
        desc = "Disable autoformat-on-save";
      };
    }

    # LSP mappings
    {
      action = "<cmd>lua vim.diagnostic.setloclist()<CR>";
      key = "<leader>ds";
      mode = "n";
      options = {
        desc = "LSP diagnostic loclist";
      };
    }

    # Buffer mappings
    {
      action = "<cmd>enew<CR>";
      key = "<leader>b";
      mode = "n";
      options = {
        desc = "buffer new";
      };
    }
    {
      action = "<cmd>bnext<CR>";
      key = "<tab>";
      mode = "n";
      options = {
        desc = "buffer goto next";
      };
    }
    {
      action = "<cmd>bprevious<CR>";
      key = "<S-tab>";
      mode = "n";
      options = {
        desc = "buffer goto prev";
      };
    }
    {
      action = "<cmd>Bdelete<CR>";
      key = "<leader>x";
      mode = "n";
      options = {
        desc = "buffer close";
      };
    }

    # Comment
    {
      action = "gcc";
      key = "<leader>/";
      mode = "n";
      options = {
        desc = "toggle comment";
        remap = true;
      };
    }
    {
      action = "gc";
      key = "<leader>/";
      mode = "v";
      options = {
        desc = "toggle comment";
        remap = true;
      };
    }

    # NvimTree keymaps
    {
      action = "<cmd>NvimTreeToggle<cr>";
      key = "<C-n>";
      mode = "n";
      options = {
        desc = "nvimtree toggle window";
      };
    }
    {
      action = "<cmd>NvimTreeFocus<CR>";
      key = "<leader>e";
      mode = "n";
      options = {
        desc = "nvimtree focus window";
      };
    }

    # Telescope keymaps
    {
      action = "<cmd>Telescope live_grep<CR>";
      key = "<leader>fw";
      mode = "n";
      options = {
        desc = "telescope live grep";
      };
    }
    {
      action = "<cmd>Telescope buffers<CR>";
      key = "<leader>fb";
      mode = "n";
      options = {
        desc = "telescope find buffers";
      };
    }
    {
      action = "<cmd>Telescope help_tags<CR>";
      key = "<leader>fh";
      mode = "n";
      options = {
        desc = "telescope help page";
      };
    }
    {
      action = "<cmd>Telescope marks<CR>";
      key = "<leader>ma";
      mode = "n";
      options = {
        desc = "telescope find marks";
      };
    }
    {
      action = "<cmd>Telescope oldfiles<CR>";
      key = "<leader>fo";
      mode = "n";
      options = {
        desc = "telescope find oldfiles";
      };
    }
    {
      action = "<cmd>Telescope current_buffer_fuzzy_find<CR>";
      key = "<leader>fz";
      mode = "n";
      options = {
        desc = "telescope find in current buffer";
      };
    }
    {
      action = "<cmd>Telescope git_commits<CR>";
      key = "<leader>cm";
      mode = "n";
      options = {
        desc = "telescope git commits";
      };
    }
    {
      action = "<cmd>Telescope git_status<CR>";
      key = "<leader>gt";
      mode = "n";
      options = {
        desc = "telescope git status";
      };
    }
    {
      action = "<cmd>Telescope find_files<cr>";
      key = "<leader>ff";
      mode = "n";
      options = {
        desc = "telescope find files";
      };
    }
    {
      action = "<cmd>Telescope find_files follow=true no_ignore=true hidden=true<CR>";
      key = "<leader>fa";
      mode = "n";
      options = {
        desc = "telescope find all files";
      };
    }

    # WhichKey
    {
      action = "<cmd>WhichKey<CR>";
      key = "<leader>wK";
      mode = "n";
      options = {
        desc = "whichkey all keymaps";
      };
    }
    {
      action = "<cmd>lua vim.cmd('WhichKey ' .. vim.fn.input('WhichKey: '))<CR>";
      key = "<leader>wk";
      mode = "n";
      options = {
        desc = "whichkey query lookup";
      };
    }

    # Git keymaps
    {
      action = "<cmd>lua require('neogit').open({ kind = 'auto' })<cr>";
      key = "<leader>gg";
      mode = "n";
      options = {
        desc = "Open Neogit UI";
      };
    }
    {
      action = "<cmd>GitBlameToggle<cr>";
      key = "<leader>gb";
      mode = "n";
      options = {
        desc = "Toggle Git Blame";
      };
    }

    # Copilot keymaps
    {
      action = "<cmd>CodeCompanionChat<cr>";
      key = "<leader>cc";
      mode = "n";
      options = {
        desc = "CodeCompanion Chat";
      };
    }
    {
      action = "<cmd>Copilot panel<cr>";
      key = "<leader>cp";
      mode = "n";
      options = {
        desc = "Github Copilot Suggestions Panel";
      };
    }
    {
      action = "<cmd>Copilot toggle<cr>";
      key = "<leader>cT";
      mode = "n";
      options = {
        desc = "Toggle Copilot";
      };
    }

    # Semicolon to command mode
    {
      action = ":";
      key = ";";
      mode = "n";
      options = {
        desc = "CMD enter command mode";
      };
    }

    # Misc keymaps
    {
      action = "q";
      key = "<M-q>";
      mode = "n";
    }
    {
      action = "";
      key = "q";
      mode = "n";
    }
  ];
}

