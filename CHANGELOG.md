# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/).

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
