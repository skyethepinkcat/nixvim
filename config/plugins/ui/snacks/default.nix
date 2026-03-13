{ ... }:
{
  imports = [
    ./dashboard.nix
    ./explorer.nix
    ./picker.nix
  ];
  # plugins.neoscroll.enable = true;
  plugins.snacks = {
    enable = true;
    settings = {
      scroll.enabled = false;
      indent = {
        enabled = true;
      };
      picker = {
        ui_select = true;
      };
      chunk.enabled = true;
    };
  };
}
