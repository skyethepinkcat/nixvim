{ lib, ... }:
let
  inherit (lib.nixvim) mkRaw;
in
{
  autoGroups = {
    LspFormatting = { };
    NvimTreeQuitFix = { };
    IndentScopeDisable = { };
  };

  autoCmd = [
    {
      event = [ "FileType" ];
      group = "IndentScopeDisable";
      pattern = [ "dashboard" ];
      callback = mkRaw ''
        function()
          vim.b.miniindentscope_disable = true
        end
      '';
    }

  ];
}
