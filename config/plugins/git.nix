{
  config,
  lib,
  pkgs,
  utils,
  ...
}:
let
  inherit (lib.nixvim) mkRaw;
  inherit (config.nvix) icons;
  inherit (config.nvix.mkKey) wKeyObj;

  lazygit_config = lib.toString (
    pkgs.writeText "config.yaml" (
      lib.strings.toJSON {
        gui = {
          theme = {
            activeBorderColor = [
              "#89b4fa"
              "bold"
            ];
            inactiveBorderColor = [ "#a6adc8" ];
            searchingActiveBorderColor = [ "#f9e2af" ];
            optionsTextColor = [ "#89b4fa" ];
            selectedLineBgColor = [ "#313244" ];
            inactiveViewSelectedLineBgColor = [ "#6c7086" ];
            cherryPickedCommitFgColor = [ "#89b4fa" ];
            cherryPickedCommitBgColor = [ "#45475a" ];
            markedBaseCommitFgColor = [ "#89b4fa" ];
            markedBaseCommitBgColor = [ "#f9e2af" ];
            unstagedChangesColor = [ "#f38ba8" ];
            defaultFgColor = [ "#cdd6f4" ];
          };
          authorColors = {
            "*" = "#b4befe";
          };
        };
      }
    )
  );
in
{

  extraFiles."lazygit.yaml".source = lazygit_config;

  plugins = {
    lazygit = {
      enable = true;
      settings.config_file_path = config.extraFiles."lazygit.yaml".finalSource;
      settings.use_custom_config_file_path = 1;
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
    {
      mode = "n";
      key = "]h";
      action =
        mkRaw
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
    }

    {
      mode = "n";
      key = "[h";
      action =
        mkRaw
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
    }

    {
      mode = "n";
      key = "]H";
      action = mkRaw "function() require('gitsigns').nav_hunk('last') end";
      desc = "Last Hunk";
    }

    {
      mode = "n";
      key = "[H";
      action = mkRaw "function() require('gitsigns').nav_hunk('first') end";
      desc = "First Hunk";
    }

    # Stage / Reset
    {
      mode = "n";
      key = "<leader>gs";
      action = "<cmd>lua require('gitsigns').stage_buffer()<CR>";
      desc = "Stage Buffer";
    }
    {
      mode = "v";
      key = "<leader>gs";
      action =
        mkRaw
          # lua
          ''
            function()
            require('gitsigns').stage_hunk({ vim.fn.line('.'), vim.fn.line('v') })
            end
          '';
      desc = "Stage/Unstage Selection";
    }

    {
      mode = "n";
      key = "<leader>gr";
      action = "<cmd>lua require('gitsigns').reset_buffer()<CR>";
      desc = "Reset Buffer";
    }
    {
      mode = "v";
      key = "<leader>gr";
      action =
        mkRaw
          # lua
          ''
            function()
            require('gitsigns').reset_hunk({ vim.fn.line('.'), vim.fn.line('v') })
            end
          '';
      desc = "Reset Selection";
    }

    # Undo
    {
      mode = "n";
      key = "<leader>gu";
      action = "<cmd>lua require('gitsigns').undo_stage_hunk()<CR>";
      desc = "Undo Stage Hunk";
    }

    # Preview / Diff
    {
      mode = "n";
      key = "<leader>gp";
      action = "<cmd>lua require('gitsigns').preview_hunk_inline()<CR>";
      desc = "Preview Hunk Inline";
    }
    {
      mode = "n";
      key = "<leader>gP";
      action = "<cmd>lua require('gitsigns').preview_hunk()<CR>";
      desc = "Preview Hunk (Popup)";
    }
    {
      mode = "v";
      key = "<leader>gp";
      action =
        mkRaw
          # lua
          ''
            function()
            require('gitsigns').preview_hunk_inline({ vim.fn.line('.'), vim.fn.line('v') })
            end
          '';
      desc = "Preview Selection";
    }

    {
      mode = "n";
      key = "<leader>dg";
      action = "<cmd>lua require('gitsigns').diffthis()<CR>";
      desc = "Git Diff ";
    }
    {
      mode = "n";
      key = "<leader>dG";
      action = mkRaw "function() require('gitsigns').diffthis('~') end";
      desc = "Git diff last commit (HEAD~)";
    }

    # Blame — merged with former wKeyList entry for <leader>gb
    {
      mode = "n";
      key = "<leader>gb";
      action = "<cmd>lua require('gitsigns').toggle_current_line_blame()<CR>";
      icon = "󰭐";
      desc = "Toggle Blame (Line)";
    }
    {
      mode = "n";
      key = "<leader>gk";
      action = mkRaw "function() require('gitsigns').blame_line({ full = true }) end";
      desc = "Blame Line (Full)";
    }
    {
      mode = "n";
      key = "<leader>gK";
      action = ":lua require('gitsigns').blame()<CR>";
      desc = "Blame File";
    }

    # Quickfix
    {
      mode = "n";
      key = "<leader>gq";
      action = ":lua require('gitsigns').setqflist()<CR>";
      desc = "Hunks to Quickfix";
    }
    {
      mode = "n";
      key = "<leader>gQ";
      action = mkRaw "function() require('gitsigns').setqflist('all') end";
      desc = "All Hunks to Quickfix";
    }

    # Toggles
    {
      mode = "n";
      key = "<leader>gw";
      action = "<cmd>lua require('gitsigns').toggle_word_diff()<CR>";
      desc = "Toggle Word Diff";
    }

    # Text object
    {
      mode = "o";
      key = "ih";
      action = ":<C-U>Gitsigns select_hunk<CR>";
      desc = "Select Hunk";
    }
    {
      mode = "x";
      key = "ih";
      action = ":<C-U>Gitsigns select_hunk<CR>";
      desc = "Select Hunk";
    }

    {
      mode = "n";
      key = "<leader>gg";
      action = "<cmd>LazyGit<cr>";
      desc = "Open Lazygit";
    }
    {
      mode = "t";
      key = "<C-:>";
      action = ":";
      desc = "Open Cmdline";
    }
    {
      action = "<cmd>LazyGitFilterCurrentFile<cr>";
      key = "<leader>gh";
      desc = "Git File History";
    }
    {
      action = "<cmd>LazyGitFilter<cr>";
      key = "<leader>gH";
      desc = "Git Project History";
    }
  ];

  extraConfigLua =
    lib.mkAfter
      # lua
      ''
        require('telescope').load_extension('lazygit')
      '';
}
