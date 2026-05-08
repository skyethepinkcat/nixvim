{ lib, ... }:
let
  inherit (lib.nixvim) mkRaw;
in
{
  autoCmd = [
    {
      event = "FileType";
      pattern = [
        "lua"
        ""
      ];
      callback = mkRaw ''
        function(ev)
          local opts = function(desc)
            return { buffer = ev.buf, silent = true, desc = desc }
          end
          vim.keymap.set("n",
            "<localleader>l",
            function()
              local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
              local source = table.concat(lines, "\n")
              local fn, err = load(source)
              if fn then
                fn()
              else
                vim.notify(err, vim.log.levels.ERROR)
              end
            end,
            opts("Source current buffer as lua")
          )
        end
      '';
    }

  ];
}
