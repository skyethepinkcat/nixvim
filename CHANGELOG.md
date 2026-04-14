# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/).

## [1.4] - 2026-04-14

### Added
- Replace codecompanion with Claude CLI integration and migrate completion to blink-cmp
- Add nixpkgs-edge input for access to bleeding-edge packages
- Indent lines via indent-blankline
- Enable lazygit plugin with keymaps restored
- Migrate keymaps to `keyList`/`wKeyList` helpers via `lib.keys`
- `NvimTreeQuitFix` autocmd for correct `:bd` and `:q` behavior in nvim-tree
- nvim-tree `on_attach` keymaps and additional configuration
- Claude Code Review and Claude PR Assistant GitHub Actions workflows

### Changed
- Reorganize `flake.nix` and `flake/` directory for clarity
- Enable lib on home module

### Fixed
- Use `pkgs.stdenv.hostPlatform.system` for nixpkgs-edge compatibility
- Remove broken tree-sitter configuration
- Incorrectly inherited keymap key and action

## [1.3] - prior release
