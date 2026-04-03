{ lib, ... }:
let
  inherit (lib.nixvim) mkRaw;
  inherit (lib) mkOption;
in
{
  # Wrap a telescope picker name in a zero-arg Lua function.
  # Usage: lib.nixvim.telescope.openPicker "find_files"
  config.lib.telescope.openPicker =
    picker:
    # lua
    mkRaw ''
      function() require('telescope.builtin').${picker}() end
    '';
  # Wrap a telescope picker name in a zero-arg Lua function.
  # Usage: lib.nixvim.telescope.openPicker "find_files"
  config.lib.telescope.openPickerWithOptions =
    picker: options:
    # lua
    mkRaw ''
      function() require('telescope.builtin').${picker}(${options}) end
    '';
  options.lib.telescope.openPicker = mkOption {
    type = lib.types.anything;
    description = "Takes a picker name and returns a raw lua function to run it.";
  };
  options.lib.telescope.openPickerWithOptions = mkOption {
    type = lib.types.anything;
    description = "Takes a picker name and options and returns a raw lua function to run it.";
  };
}
