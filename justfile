build:
  nix build path:.
run:
  nix run path:.
cache:
  attic push skyenet $(nix build . --no-link --print-out-paths)
