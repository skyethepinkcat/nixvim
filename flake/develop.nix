{
  self,
  inputs,
  ...
}:
{
  perSystem =
    {
      system,
      config,
      pkgs,
      ...
    }:
    {
      # `nix develop` — tools for editing this config
      devShells.default = inputs.devenv.lib.mkShell {
        inherit inputs pkgs;
        cachix.pull = [ "skyethepinkcat"];
        cachix.push = "skyethepinkcat";
        modules = [
          {
            packages = with pkgs; [
              statix
              nixd
              nixfmt
              lua-language-server
              just
              devenv
              git
              cachix
            ];
          }
        ];
      };
    };
}
