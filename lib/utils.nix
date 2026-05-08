lib:
let
  inherit (lib.nixvim) mkRaw;
in
{
  mkFunc =
    function:
    mkRaw
      # lua
      ''
        function()
          ${function}
        end
      '';
}
