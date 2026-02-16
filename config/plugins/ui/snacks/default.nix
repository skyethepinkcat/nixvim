{ ... }:
{
  imports = [
    ./dashboard.nix
    ./explorer.nix
    ./picker.nix
  ];
  plugins.snacks = {
    enable = true;
    settings = {
      scroll.enabled = true;
    };
  };
}
