{

  lib,
  ...
}:
{
  config = {
    lib.mkFunc =
      function:
      lib.nixvim.mkRaw
        # lua
        ''
          function()
            ${function}
          end
        '';
  };
  options.lib.mkFunc = lib.mkOption {
    type = lib.types.functionTo lib.types.attrs;
    description = "Function that wraps lua code in function() end for convience.";
  };
}
