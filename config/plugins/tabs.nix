{ config, lib, ... }:
let
  inherit (config.lib.keys) keyObj;
  inherit (config.nvix.mkKey) wKeyObj;
  inherit (lib.nixvim) mkRaw;
in
{
  plugins.scope.enable = true;

  extraConfigLua = builtins.readFile ./tabs.lua;

  wKeyList = [
    {
      __unkeyed_1 = "<leader>t";
      icon = "󰓩";
      group = "tabs";
      expand = mkRaw ''
        function()
          local tabs = vim.api.nvim_list_tabpages()
          local result = {}
          for i = 1, math.min(#tabs, 9) do
            result[#result + 1] = {
              tostring(i),
              function() vim.api.nvim_set_current_tabpage(tabs[i]) end,
              desc = "goto tab " .. i,
              icon = "󰓩",
            }
          end
          return result
        end
      '';
    }
  ];

  keyList = [
    (keyObj {
      action = "<cmd>tabnext<cr>";
      key = "<leader>t<tab>";
      icon = "󰓩";
      desc = "next tab";
    })
    (keyObj {
      action = "<cmd>tabprevious<cr>";
      key = "<leader>t<S-tab>";
      icon = "󰓩";
      desc = "prev tab";
    })
    (keyObj {
      action = mkRaw ''
        function()
          local pickers = require('telescope.pickers')
          local finders = require('telescope.finders')
          local conf = require('telescope.config').values
          local actions = require('telescope.actions')
          local action_state = require('telescope.actions.state')
          pickers.new({}, {
            prompt_title = "Switch Tab",
            finder = finders.new_table {
              results = _tab_entries(false),
              entry_maker = function(e) return e end,
            },
            previewer = _tab_previewer(),
            sorter = conf.generic_sorter({}),
            attach_mappings = function(prompt_bufnr)
              actions.select_default:replace(function()
                actions.close(prompt_bufnr)
                local sel = action_state.get_selected_entry()
                if sel then vim.api.nvim_set_current_tabpage(sel.tab) end
              end)
              return true
            end,
          }):find()
        end
      '';
      key = "<leader>tt";
      icon = "󰓩";
      desc = "tab picker";
    })
    (keyObj {
      action = mkRaw ''
        function()
          local pickers = require('telescope.pickers')
          local finders = require('telescope.finders')
          local conf = require('telescope.config').values
          local actions = require('telescope.actions')
          local action_state = require('telescope.actions.state')
          pickers.new({}, {
            prompt_title = "Move Buffer to Tab",
            finder = finders.new_table {
              results = _tab_entries(true),
              entry_maker = function(e) return e end,
            },
            previewer = _tab_previewer(),
            sorter = conf.generic_sorter({}),
            attach_mappings = function(prompt_bufnr)
              actions.select_default:replace(function()
                actions.close(prompt_bufnr)
                local sel = action_state.get_selected_entry()
                if sel then vim.cmd("ScopeMoveBuf " .. sel.tabnr) end
              end)
              return true
            end,
          }):find()
        end
      '';
      key = "<leader>tm";
      icon = "󰆒";
      desc = "move buf to tab";
    })
  ];
}
