{

  lib,
  ...
}:
{
  config = {
    lib.mkFunc = function: lib.nixvim.mkRaw ''
      function()
        ${function}
      end
    '';
  };
  options.lib.mkFunc = lib.mkOption {
    type = lib.types.anything;
    description = "Function that wraps lua code in function() end for convience.";
  };
}
