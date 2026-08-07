{ pkgs, lib, utils, ... }:
let
  inherit (utils) mkFunc;
in
{
  extraFiles."lua/nix.lua".source = ./nix.lua;
  extraConfigLua = ''
    require('nix').jq_path = "${lib.getExe pkgs.jq}";

  '';

  ftKeyList.nix = [
    {
      key = "<LocalLeader>c";
      action = mkFunc ''
        require('nix').copy_config_path()
      '';
      desc = "Copy the configuration path";
    }
    {
      key = "<LocalLeader>p";
      action = mkFunc ''
        require('nix').copy_config_path()
      '';
      desc = "Display the configuration path";
    }
    {
      key = "<LocalLeader>=";
      action = mkFunc ''
        require('nix').eval_config()
      '';
      desc = "Evaluate an option";
    }
    {
      key = "<LocalLeader>s";
      action = mkFunc ''
        require('nix').set_output(nil)
      '';
      desc = "Set a flake output path";
    }
  ];
}
