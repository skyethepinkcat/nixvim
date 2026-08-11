{ utils, ... }:
let
  ftKey = key: "<LocalLeader>${key}";
  inherit (utils) mkFunc;
  action =
    a:
    mkFunc ''
      local ht = require('haskell-tools')
      ht.${a}

    '';
in
{
  plugins.haskell-tools = {
    enable = true;
  };
  ftKeyList.haskell = [
    {
      key = ftKey "s";
      action = action "hoogle.hoogle_signature()";
      desc = "Hoogle search";
      icon = "";
    }
    {
      key = ftKey "e";
      action = action "lsp.buf_eval_all()";
      desc = "Evaluate Buffer";
      icon = "";
    }
    {
      key = ftKey "r";
      action = null;
      desc = "Repl";
      icon = "λ";
    }
    {
      key = ftKey "rr";
      action = action "repl.toggle()";
      desc = "Toggle Repl for Project";
      icon = "";
    }
    {
      key = ftKey "rf";
      action = action "repl.toggle(vim.api.nvim_buf_get_name(0))";
      desc = "Toggle Repl for Buffer";
      icon = "";
    }
    {
      key = ftKey "rq";
      action = action "repl.quit()";
      desc = "Quit repl";
      icon = "󰐥";
    }

  ];
}
