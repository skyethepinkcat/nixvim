build:
  nix build path:.
run:
  nix run path:.
cache:
  nix-fast-build --attic-cache skyenet -f .#packages.$(nix eval --raw --impure --expr builtins.currentSystem) --push-build-closure
