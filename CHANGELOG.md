# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/).

## [1.4] - 2026-04-27

### Added
- Replace codecompanion with Claude CLI integration and migrate completion to blink-cmp
- Add nixpkgs-edge input for access to bleeding-edge packages
- Indent lines via indent-blankline
- Enable lazygit plugin with keymaps restored
- Migrate keymaps to `keyList`/`wKeyList` helpers via `lib.keys`
- `NvimTreeQuitFix` autocmd for correct `:bd` and `:q` behavior in nvim-tree
- nvim-tree `on_attach` keymaps and additional configuration
- Claude Code Review and Claude PR Assistant GitHub Actions workflows
- render-markdown plugin with buffer-local keymaps
- Custom dashboard via skyepkgs overlay (`pkgs.vimPlugins.dashboard`)
- Snippets support via linkFarm
- OpenCode AI integration with dual-tool keybinds (opencode + claude) and session tracking
- Which-key group and icons for AI keybinds
- Frecency picker
- jsonls and prettier language servers
- Lazygit config export
- `exportFiles` option for exporting config files

### Changed
- Reorganize `flake.nix` and `flake/` directory for clarity
- Enable lib on home module
- Swap claude for opencode as primary AI tool
- Simplify plugins imports structure
- Remove clangd LSP

### Fixed
- Use `pkgs.stdenv.hostPlatform.system` for nixpkgs-edge compatibility
- Remove broken tree-sitter configuration
- Incorrectly inherited keymap key and action
- `extraConfigLua` not applying for AI config
- Remove `sh` lang tag from code blocks (prevented `#` comment highlighting)
- CI impure build
- Dashboard: disable indent scope and project widget
- Neovide dark theme

## [1.3] - prior release
