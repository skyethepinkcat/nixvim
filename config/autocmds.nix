{ lib, ... }:
let
  inherit (lib.nixvim) mkRaw;
in
{
  autoGroups = {
    LspFormatting = { };
  };

}
