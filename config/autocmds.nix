{ lib, ... }:
let
  inherit (lib.nixvim) mkRaw;
in
{
  autoGroups = {
    LspFormatting = { };
    NvimTreeQuitFix = { };
  };

  autoCmd = [
    {
      event = [
        "BufEnter"
        "QuitPre"
      ];
      group = "NvimTreeQuitFix";
      nested = false;
      callback = mkRaw ''
        function(e)
          local tree = require('nvim-tree.api').tree

          if not tree.is_visible() then
            return
          end

          local winCount = 0
          for _, winId in ipairs(vim.api.nvim_list_wins()) do
            if vim.api.nvim_win_get_config(winId).focusable then
              winCount = winCount + 1
            end
          end

          if e.event == 'QuitPre' and winCount == 2 then
            vim.api.nvim_cmd({ cmd = 'qall' }, {})
          end

          if e.event == 'BufEnter' and winCount == 1 then
            vim.defer_fn(function()
              tree.toggle({ find_file = true, focus = true })
              tree.toggle({ find_file = true, focus = false })
            end, 10)
          end
        end
      '';
    }
  ];

}
