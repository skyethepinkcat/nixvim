{ pkgs, lib, ... }:
let
  debugKey = f: "<leader>D${f}";
in
{
  plugins = {
    dap = {
      enable = true;
    };
    dap-ui = {
      enable = true;
    };
  };
  keyList = [
    {
      key = debugKey "";
      action = null;
      icon = "";
      desc = "Debug";
    }
    {
      key = debugKey "b";
      action = "<cmd>DapToggleBreakpoint<CR>";
      icon = "";
      desc = "Toggle Breakpoint";
    }
  ];

}
