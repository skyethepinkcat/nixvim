{ lib, config, ... }:
let
  inherit (config.lib.keys) keyObj;
  inherit (config.lib) mkFunc;
in
{
  ftKeyList.lua = [
    (keyObj {
      desc = "Source Lua File";
      key = "<localleader>l";
      mode = "n";
      action =
        mkFunc
          # lua
          ''
            local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
            local source = table.concat(lines, "\n")
            local fn, err = load(source)
            if fn then
              fn()
            else
              vim.notify(err, vim.log.levels.ERROR)
            end
          '';
    })
  ];
}
