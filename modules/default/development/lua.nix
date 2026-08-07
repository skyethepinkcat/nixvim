{
  lib,
  utils,
  config,
  ...
}:
let
  inherit (utils) mkFunc;
in
{
  plugins = {
    blink-cmp.settings.sources = lib.mkIf config.plugins.lazydev.enable {
      default = lib.mkBefore [ "lazydev" ];
      providers = {
        lazydev = {
          name = "lazydev";
          module = "lazydev.integrations.blink";
          score_offset = 100;
        };
      };
    };
    lazydev = {
      enable = true;
    };
  };
  ftKeyList.lua = [
    {
      desc = "Source Lua File";
      key = "<localleader>l";
      mode = "n";
      action = mkFunc ''
        local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
        local source = table.concat(lines, "\n")
        local fn, err = load(source)
        if fn then
          fn()
        else
          vim.notify(err, vim.log.levels.ERROR)
        end
      '';
    }
  ];
}
