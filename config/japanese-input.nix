{
  lib,
  pkgs,
  config,
  ...
}:
let
  isDarwin = pkgs.stdenv.hostPlatform.system == "aarch64-darwin";
  cfg = config.japanese-input;
in
{
  # Only works on macos, since it relies on macism
  config = lib.mkIf cfg.enable (
    let
      inherit (lib.nixvim) mkRaw;
      inherit (config.lib.keys) keyObj;
    in
    {
      autoGroups = {
        Japanese = { };
      };
      autoCmd = [
        {
          event = [ "InsertLeave" ];
          group = "Japanese";
          callback =
            mkRaw
              # lua
              ''
                function()
                  vim.fn.system({"${cfg.command}", "${cfg.englishInputMethod}"})
                end
              '';
        }
      ];
      keyList = [
        (keyObj {
          key = "<leader>ij";
          mode = "n";
          icon = "日本";
          action =
            mkRaw
              # lua
              ''
                function()
                  vim.fn.system({"${cfg.command}", "${cfg.japaneseInputMethod}"})
                  vim.cmd("startinsert")
                end
              '';
          desc = "Enter Japanese Input Mode";
        })
      ];
    }
  );

  options = {
    japanese-input = {
      enable = lib.mkOption {
        default = pkgs.stdenv.hostPlatform.system == "aarch64-darwin";
      };
      japaneseInputMethod = lib.mkOption {
        default = lib.optionalString isDarwin "com.apple.inputmethod.Kotoeri.RomajiTyping.Japanese";
      };

      englishInputMethod = lib.mkOption {
        default = lib.optionalString isDarwin "com.apple.keylayout.US";
      };

      command = lib.mkOption {
        default = lib.optionalString isDarwin (lib.getExe pkgs.macism);
      };

    };

  };
}
