# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/).

## [2.1] - 2027-07-21

### Added

- puppet: custom tree-sitter grammar and indentation support
- bash: Extend indent queries for `if` blocks (treesitter)
- Renpy support
- Link `CLAUDE.md` into the repo
- Additional `justfile` dev commands
- Run CI build on macOS and Ubuntu ARM
- `gitattributes`: prevent `flake.lock` merge conflicts
- Follow nixpkgs `stable` releases on ``release-26.05`` branch, `unstable` on main

### Changed

- Major module/export restructuring: modules now produce their own package outputs,
  exports handled solely as packages (`flake/export.nix`, `flake/packages.nix`)
- Simplify `config/` directory layout into `modules/{default,ui,ai,extra,scratch}`
- lazygit: use `nvim-remote` instead of inline Lua functions for file-edit integration
- home-module: use global packages, enforce empty config
- skyepkgs: don't rely on overlays
- markdown: use default formatexpr

### Fixed

- Release workflow: use new job outputs
- GitHub Actions permissions (restricted back to read, then scoped for Claude PR creation)
- Dependabot config: fix malformed YAML and incorrect branch targets
- Force nixvim to follow nixpkgs
- Remove `trash-cli` on Darwin

## [2.0] - 2026-06-11

### Added
- Replace codecompanion with Claude CLI integration and migrate completion to blink-cmp
- Indent lines via indent-blankline
- Enable lazygit plugin with keymaps restored
- Migrate keymaps to `keyList`/`ftKeyList` helpers via `framework/keylist.nix`
- Added a wrapper for `config.files` to specify ftplugins.
- `NvimTreeQuitFix` autocmd for correct `:bd` and `:q` behavior in nvim-tree
- nvim-tree `on_attach` keymaps and additional configuration
- Claude Code Review and Claude PR Assistant GitHub Actions workflows
- render-markdown plugin with buffer-local keymaps
- Custom dashboard via skyepkgs overlay (`pkgs.vimPlugins.dashboard`)
- OpenCode AI integration with dual-tool keybinds (opencode + claude) and session tracking
- Which-key group and icons for AI keybinds
- jsonls and prettier language servers
- Lazygit config export
- Added `lib/` to contain functions and `framework/` to contain framework code for
  clarity.
- Helper keybinds for Japanese Input on Darwin
- Tab Keybinds
- Puppet helper functions
#### Plugins Added
- abolish-vim
- nvim-chess
- quite a few more
### Changed
- Reorganize `flake.nix` and `flake/` directory for clarity
- Enable lib on home module
- Simplify plugins imports structure
- Remove clangd LSP
- More or less completely removed snacks
- nvim-tree now uses a floating window
### Fixed
- Incorrectly inherited keymap key and action
- `extraConfigLua` not applying for AI config
- Remove `sh` lang tag from code blocks (prevented `#` comment highlighting)
- Dashboard: disable indent scope and project widget
- Neovide dark theme
- `data/` is no longer ignored by Telescope
- Don't show the nvim intro on startup

And lots more!

## [1.3] - prior release
