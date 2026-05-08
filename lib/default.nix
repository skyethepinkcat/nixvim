let
  utils = import ./utils.nix;
in
{
  telescope = import ./telescope.nix;
  inherit (utils) mkFunc;
}
