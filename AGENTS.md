# Additional Rules

1. Ask user before token-hungry operations.
1. Read the docs when possible.
1. Before implementing something complex, ask the user if that is what they
   want.
1. Don't touch anything in config/nvix, since that was directly imported from
   elsewhere, if you need to, ask the user first.
1. Use conventional commits
1. When comming a change you made, include yourself as co-author.
1. Use git flow when relevant
1. Run `nix fmt` before committing to ensure everything stays formatted correctly.
1. Before looking through complex nix-store derivations, consider if the information could be better obtained by asking the user or consulting web documentation.
