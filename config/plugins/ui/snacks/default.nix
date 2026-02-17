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
      chunk.enabled = true;
    };
  };
}
