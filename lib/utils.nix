let
  mkRaw = v: { __raw = v; };
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
