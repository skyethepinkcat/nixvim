# Additional Rules

1. Ask user before token-hungry operations.
2. Read the docs when possible.
3. Before implementing something complex, ask the user if that is what they
   want.
4. Don't touch anything in config/nvix, since that was directly imported from
   elsewhere, if you need to, ask the user first.
5. Use conventional commits
6. When committing a change you made, include yourself as co-author.
7. Use git flow when relevant
8. Run `nix fmt` before committing to ensure everything stays formatted correctly.
9. Before looking through complex nix-store derivations, consider if the information could be better obtained by asking the user or consulting web documentation.
