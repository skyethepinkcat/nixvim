{
  perSystem =
    {
      pkgs,
      ...
    }:
    {
      # `nix develop` — tools for editing this config
      devShells.default = pkgs.mkShell {
        packages = with pkgs; [
          statix
          nixd
          nixfmt
          lua-language-server
          just
        ];
      };
    };
}
