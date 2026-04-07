{ config, lib, ... }:
let
  inherit (lib.nixvim) mkRaw;
  inherit (config.nvix) icons;
  inherit (config.nvix.mkKey) wKeyObj;
  inherit (config.lib.keys) keyObj;
in
{
  plugins = {
    lazygit = {
      enable = true;
    };
    git-conflict = {
      enable = true;
      settings.default_mappings = true;
    };
    gitsigns = {
      enable = true;
      settings = {
        current_line_blame = true;
        preview_config = {
          border = "rounded";
        };
        signs = with icons.ui; {
          add.text = "${LineLeft}";
          change.text = "${LineLeft}";
          delete.text = "${LineLeft}";
          topdelete.text = "${Triangle}";
          changedelete.text = "${BoldLineLeft}";
        };
      };
    };
  };

  # Group-only labels — no action, must stay as wKeyList
  wKeyList = [
    (wKeyObj [
      "<leader>g"
      "󰊢"
      "git"
    ])
    (wKeyObj [
      "<leader>f"
      ""
      "files"
    ])
    (wKeyObj [
      "<leader>s"
      ""
      "search"
    ])
    (wKeyObj [
      "<leader>T"
      ""
      "toggles"
    ])
    (wKeyObj [
      "<leader>T"
      ""
      "toggles"
    ])
    (wKeyObj [
      "<leader>gh"
      "󰫅"
      "hunks"
    ])
  ];

  keyList = [

    # Navigation
    (keyObj {
      mode = "n";
      key = "]h";
      action = mkRaw
        # lua
        ''
          function ()
            if vim.wo.diff then
              vim.cmd.normal ({ ' ]c', bang = true})
          else
              require('gitsigns').nav_hunk('next')
            end
          end
        '';
      desc = "Next Hunk";
    })

    (keyObj {
      mode = "n";
      key = "[h";
      action = mkRaw
        # lua
        ''
          function()
            if vim.wo.diff then
              vim.cmd.normal({'[c', bang = true})
            else
              require('gitsigns').nav_hunk('prev')
            end
          end
        '';
      desc = "Prev Hunk";
    })

    (keyObj {
      mode = "n";
      key = "]H";
      action = mkRaw "function() require('gitsigns').nav_hunk('last') end";
      desc = "Last Hunk";
    })

    (keyObj {
      mode = "n";
      key = "[H";
      action = mkRaw "function() require('gitsigns').nav_hunk('first') end";
      desc = "First Hunk";
    })

    # Stage / Reset
    (keyObj {
      mode = "n";
      key = "<leader>gs";
      action = "<cmd>lua require('gitsigns').stage_buffer()<CR>";
      desc = "Stage Buffer";
    })
    (keyObj {
      mode = "v";
      key = "<leader>gs";
      action = mkRaw
        # lua
        ''
          function()
          require('gitsigns').stage_hunk({ vim.fn.line('.'), vim.fn.line('v') })
          end
        '';
      desc = "Stage/Unstage Selection";
    })

    (keyObj {
      mode = "n";
      key = "<leader>gr";
      action = "<cmd>lua require('gitsigns').reset_buffer()<CR>";
      desc = "Reset Buffer";
    })
    (keyObj {
      mode = "v";
      key = "<leader>gr";
      action = mkRaw
        # lua
        ''
          function()
          require('gitsigns').reset_hunk({ vim.fn.line('.'), vim.fn.line('v') })
          end
        '';
      desc = "Reset Selection";
    })

    # Undo
    (keyObj {
      mode = "n";
      key = "<leader>gu";
      action = "<cmd>lua require('gitsigns').undo_stage_hunk()<CR>";
      desc = "Undo Stage Hunk";
    })

    # Preview / Diff
    (keyObj {
      mode = "n";
      key = "<leader>gp";
      action = "<cmd>lua require('gitsigns').preview_hunk_inline()<CR>";
      desc = "Preview Hunk Inline";
    })
    (keyObj {
      mode = "n";
      key = "<leader>gP";
      action = "<cmd>lua require('gitsigns').preview_hunk()<CR>";
      desc = "Preview Hunk (Popup)";
    })
    (keyObj {
      mode = "v";
      key = "<leader>gp";
      action = mkRaw
        # lua
        ''
          function()
          require('gitsigns').preview_hunk_inline({ vim.fn.line('.'), vim.fn.line('v') })
          end
        '';
      desc = "Preview Selection";
    })

    (keyObj {
      mode = "n";
      key = "<leader>dg";
      action = "<cmd>lua require('gitsigns').diffthis()<CR>";
      desc = "Git Diff ";
    })
    (keyObj {
      mode = "n";
      key = "<leader>dG";
      action = mkRaw "function() require('gitsigns').diffthis('~') end";
      desc = "Git diff last commit (HEAD~)";
    })

    # Blame — merged with former wKeyList entry for <leader>gb
    (keyObj {
      mode = "n";
      key = "<leader>gb";
      action = "<cmd>lua require('gitsigns').toggle_current_line_blame()<CR>";
      icon = "󰭐";
      desc = "Toggle Blame (Line)";
    })
    (keyObj {
      mode = "n";
      key = "<leader>gk";
      action = mkRaw "function() require('gitsigns').blame_line({ full = true }) end";
      desc = "Blame Line (Full)";
    })
    (keyObj {
      mode = "n";
      key = "<leader>gK";
      action = ":lua require('gitsigns').blame()<CR>";
      desc = "Blame File";
    })

    # Quickfix
    (keyObj {
      mode = "n";
      key = "<leader>gq";
      action = ":lua require('gitsigns').setqflist()<CR>";
      desc = "Hunks to Quickfix";
    })
    (keyObj {
      mode = "n";
      key = "<leader>gQ";
      action = mkRaw "function() require('gitsigns').setqflist('all') end";
      desc = "All Hunks to Quickfix";
    })

    # Toggles
    (keyObj {
      mode = "n";
      key = "<leader>gw";
      action = "<cmd>lua require('gitsigns').toggle_word_diff()<CR>";
      desc = "Toggle Word Diff";
    })

    # Text object
    (keyObj {
      mode = "o";
      key = "ih";
      action = ":<C-U>Gitsigns select_hunk<CR>";
      desc = "Select Hunk";
    })
    (keyObj {
      mode = "x";
      key = "ih";
      action = ":<C-U>Gitsigns select_hunk<CR>";
      desc = "Select Hunk";
    })

    (keyObj {
      mode = "n";
      key = "<leader>gg";
      action = "<cmd>LazyGit<cr>";
      desc = "Open Lazygit";
    })
    (keyObj {
      mode = "t";
      key = "<C-:>";
      action = ":";
      desc = "Open Cmdline";
    })
    (keyObj {
      action = "<cmd>LazyGitFilterCurrentFile<cr>";
      key = "<leader>gh";
      desc = "Git File History";
    })
    (keyObj {
      action = "<cmd>LazyGitFilter<cr>";
      key = "<leader>gH";
      desc = "Git Project History";
    })
  ];

  extraConfigLua = lib.mkAfter
    # lua
    ''
      require('telescope').load_extension('lazygit')
    '';

}
