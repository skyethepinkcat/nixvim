{ pkgs, config, lib, ... }:
let
  inherit (config.nvix.mkKey) mkKeymap;
in
{
  plugins = {
    # Must have plugins to have a decent flow of work
    comment = {
      enable = true;
      settings = {
        toggler.line = "<leader>/";
        opleader.line = "<leader>/";
      };
    };
    tmux-navigator.enable = true;
    smart-splits.enable = true;
    web-devicons.enable = true;
    nvim-surround.enable = true;
    nvim-autopairs = {
      enable = true;
      luaConfig.post =
        # lua
        ''
          local npairs = require'nvim-autopairs'
          local Rule = require("nvim-autopairs.rule")
          local ts_conds = require('nvim-autopairs.ts-conds')
          local log = require('nvim-autopairs._log')
          local utils = require('nvim-autopairs.utils')

          -- Note that when the cursor is at the end of a comment line,
          -- treesitter thinks we are in attrset_expression
          -- because the cursor is "after" the comment, even though it is on the same line.
          local is_not_ts_node_comment_one_back = function()
              return function(info)
                  log.debug('not_in_ts_node_comment_one_back')

                  local p = vim.api.nvim_win_get_cursor(0)
                  -- Subtract one to account for 1-based row indexing in nvim_win_get_cursor
                  -- Also subtract one from the position of the column to see if we are at the end of a comment.
                  local pos_adjusted = {p[1] - 1, p[2] - 1}

                  vim.treesitter.get_parser():parse()
                  local target = vim.treesitter.get_node({ pos = pos_adjusted, ignore_injections = false })
                  log.debug(target:type())
                  if target ~= nil and utils.is_in_table({'comment'}, target:type()) then
                      return false
                  end

                  local rest_of_line = info.line:sub(info.col)
                  return rest_of_line:match('^%s*$') ~= nil
              end
          end

          npairs.add_rule(
            Rule("= ", ";", "nix")
              :with_pair(is_not_ts_node_comment_one_back())
              :set_end_pair_length(1)
          )
        '';
    };
    trim.enable = true;
    lz-n.enable = true;
    flash = {
      enable = true;
      settings = {
        modes.char.enabled = false;
      };
    };
    visual-multi.enable = true;
    which-key = {
      enable = true;
      settings.spec = config.wKeyList;
      settings.preset = "helix";
    };
  };
  opts = {
    timeout = true;
    timeoutlen = 250;
  };
  keymaps = [
    (mkKeymap "n" "<leader>vt" "<cmd>:lua require('flash').treesitter()<cr>" "Select Treesitter Node")
    (mkKeymap "n" "<leader>ut" ":TrimToggle<cr>" "Toggle Trim")
  ];
}
