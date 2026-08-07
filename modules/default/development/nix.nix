{
  pkgs,
  lib,
  utils,
  inputs,
  config,
  ...
}:
let
  inherit (utils) mkFunc;
  mypkgs = inputs.nvim-nixmodules.packages.${pkgs.stdenv.hostPlatform.system};
  nixmodulesPlugin = lib.nixvim.plugins.mkNeovimPlugin {
    name = "nixmodules";
    maintainers = lib.maintainers.skyethepinkcat;
    package = lib.mkPackageOption mypkgs "nixmodules" { };
    extraOptions = {
      nix = lib.mkPackageOption pkgs "nix" { };
      jq = lib.mkPackageOption pkgs "jq" { };
    };
    extraConfig = cfg: opts: {
      plugins.nixmodules = {
      package = lib.mkDefault mypkgs.nixmodules;
        settings = {
          nix_path = lib.getExe cfg.nix;
          jq_path = lib.getExe cfg.jq;
        };
      };
    };
  };
in
{
  imports = [
    nixmodulesPlugin
  ];

  plugins.nixmodules = {
    enable = true;
  };
  ftKeyList.nix = [
    {
      key = "<LocalLeader>c";
      action = mkFunc ''
        require('nixmodules').copy_config_path()
      '';
      desc = "Copy the configuration path";
    }
    {
      key = "<LocalLeader>p";
      action = mkFunc ''
        require('nixmodules').print_config_path()
      '';
      desc = "Display the configuration path";
    }
    {
      key = "<LocalLeader>=";
      action = mkFunc ''
        require('nixmodules').eval_config()
      '';
      desc = "Evaluate an option";
    }
    {
      key = "<LocalLeader>s";
      action = mkFunc ''
        require('nixmodules').set_output(nil)
      '';
      desc = "Set a flake output path";
    }
  ];
}
