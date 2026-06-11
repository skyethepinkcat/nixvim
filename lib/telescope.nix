lib:
let
  inherit (lib.nixvim) mkRaw;
in
{
  openPicker =
    picker:
    mkRaw
      # lua
      ''
        function() require('telescope.builtin').${picker}() end
      '';

  openPickerWithOptions =
    picker: options:
    mkRaw
      # lua
      ''
        function() require('telescope.builtin').${picker}(${options}) end
      '';

  openExtensionPickerWithOptions =
    extension: picker: options:
    mkRaw
      # lua
      ''
        function() require('telescope').extensions.${extension}.${picker}(${options}) end
      '';
}
