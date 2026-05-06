{
  lib,
  pkgs,
  config,
  ...
}:
{
  # Only works on macos, since it relies on macism
  config = lib.mkIf (pkgs.stdenv.hostPlatform.system == "aarch64-darwin") (
    let
      inherit (lib.nixvim) mkRaw;
      inherit (config.lib.keys) keyObj;
      command = lib.getExe pkgs.macism;
      japanese_ime = "com.apple.inputmethod.Kotoeri.RomajiTyping.Japanese";
      english_ime = "com.apple.keylayout.US";
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
                  vim.fn.system({"${command}", "${english_ime}"})
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
                  vim.fn.system({"${command}", "${japanese_ime}"})
                  vim.cmd("startinsert")
                end
              '';
          desc = "Enter Japanese Input Mode";
        })
      ];
    }
  );
}
