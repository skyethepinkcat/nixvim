lib: {
  telescope = import ./telescope.nix lib;
  inherit (import ./utils.nix lib) mkFunc;
}
