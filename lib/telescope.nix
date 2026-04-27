{ lib, ... }:
let
  inherit (lib.nixvim) mkRaw;
  inherit (lib) mkOption;
in
{
  config.lib.telescope = {
    # Wrap a telescope picker name in a zero-arg Lua function.
    # Usage: lib.nixvim.telescope.openPicker "find_files"
    openPicker =
      picker:
      # lua
      mkRaw ''
        function() require('telescope.builtin').${picker}() end
      '';
    # Wrap a telescope picker name in a zero-arg Lua function.
    # Usage: lib.nixvim.telescope.openPicker "find_files"
    openPickerWithOptions =
      picker: options:
      # lua
      mkRaw ''
        function() require('telescope.builtin').${picker}(${options}) end
      '';

    openExtensionPickerWithOptions =
      extension: picker: options:
      mkRaw
        # lua
        ''
          function() require('telescope').extensions.${extension}.${picker}(${options}) end
        '';
  };
  options.lib.telescope = {

    openPicker = mkOption {
      type = lib.types.anything;
      description = "Takes a picker name and returns a raw lua function to run it.";
    };

    openExtensionPicker = mkOption {
      type = lib.types.anything;
      description = "Takes a picker name and returns a raw lua function to run it.";
    };

    openExtensionPickerWithOptions = mkOption {
      type = lib.types.anything;
      description = "Takes a picker name and returns a raw lua function to run it.";
    };

    openPickerWithOptions = mkOption {
      type = lib.types.anything;
      description = "Takes a picker name and options and returns a raw lua function to run it.";
    };
  };
}
