{ config, ... }:
let
  inherit (config.lib.keys) keyObj;
in
{
  plugins.toggleterm = {
    enable = true;
    settings = {
      direction = "float";
      float_opts = {
        border = "curved";
      };
      open_mapping = "[[<leader>tt]]";
      shade_terminals = true;
      size = ''
        function(term)
          if term.direction == "horizontal" then
            return 15
          elseif term.direction == "vertical" then
            return vim.o.columns * 0.4
          end
        end
      '';
    };
  };
  keyList = [
    # {
    #   action = "<C-\\><C-n>";
    #   mode = "t";
    #   key = "<esc>";
    # }
    (keyObj {
      action = "<cmd>ToggleTerm<cr>";
      mode = "t";
      key = "<C-d>";
    })
  ];
}
