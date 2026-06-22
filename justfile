build:
  nix build path:.
run:
  nix run path:.
cache:
  nix flake show --json  2> /dev/null \
    | jq  ".packages.$(nix eval nixpkgs#stdenv.hostPlatform.system)|keys[]"\
    | xargs -I {} nix build .#{} --print-out-paths --no-link \
    | cachix push skyethepinkcat
