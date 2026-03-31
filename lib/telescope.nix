{ mkRaw, ... }:
{
  # Wrap a telescope picker name in a zero-arg Lua function.
  # Usage: lib.nixvim.telescope.openPicker "find_files"
  openPicker =
    picker:
    mkRaw # lua
      ''
        function() require('telescope.builtin').${picker}() end
      '';
}
