{ inputs, self, ... }:
{
  # Home Manager module that enables nixvim with this config.
  # Import as `homeModules.default` in a home-manager flake.
  flake.homeModules.default =
    { lib, ... }:
    {
      imports = [ inputs.nixvim.homeModules.nixvim ];
      programs.nixvim = {
        enable = lib.mkDefault true;
        imports = [
          self.nixvimModules.default

          # Pass flake inputs to config modules (e.g. for skyepkgs packages).
          { _module.args = { inherit inputs; }; }
          { nixpkgs.overlays = [ inputs.skyepkgs.overlays.default ]; }
        ];
      };
    };
}
