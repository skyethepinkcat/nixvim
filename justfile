build:
  nix build path:.
run:
  nix run path:.
cache:
  nix build . --print-out-paths --quiet
