# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Commands

```bash
nix flake check .          # Validate configuration
nix build .#nvim           # Build neovim package
nix run .                  # Run nixvim directly
nix develop                # Enter dev shell (nixd, nixfmt, lua-language-server)
```

Formatting/linting uses treefmt (configured in `flake/treefmt.nix`):
- **nixfmt** — Nix files
- **statix** — Nix linter
- **stylua** — Lua files

## Architecture

**Entry point:** `flake.nix` → `config/default.nix` → everything else.

`config/default.nix` uses `lib.importDir` to auto-import all `.nix` files in `config/plugins/` (and subdirectories `ai/`, `ui/`). Adding a new file to those directories automatically includes it.

### Key directories

| Path | Purpose |
|------|---------|
| `config/nvix/` | Core Neovim options, icons, helper functions |
| `config/plugins/` | Plugin configs (auto-imported) |
| `config/plugins/ui/snacks/` | Snacks mega-plugin (picker, explorer, dashboard) |
| `config/plugins/ai/` | Copilot + CodeCompanion (claude-sonnet-4-6) |
| `flake/` | treefmt formatter config |
| `modules/` | Empty — reserved for custom NixVim modules |

### Helper functions (`config/nvix/functions.nix`)

- `mkKeymap mode key action desc` — creates a basic keymap attrset
- `mkKeymapWithOpts mode key action opts` — keymap with extra options
- `lazyKey key action desc` — lazy.nvim-style keymap for plugin specs
- `wKeyObj key desc` — which-key group label object

These are exposed via `config/nvix/options.nix` as `cfg.mkKeymap`, `cfg.icons`, etc., and consumed across all plugin files.

### Plugin pattern

Each plugin file in `config/plugins/` follows this structure:
```nix
{ config, ... }:
let cfg = config.nvix; in
{
  plugins.some-plugin = {
    enable = true;
    settings = { ... };
  };
  keymaps = [ (cfg.mkKeymap "n" "<leader>x" "<cmd>Cmd<CR>" "Description") ];
}
```

### Snacks picker

Snacks picker replaces Telescope. All picker keymaps are in `config/plugins/ui/snacks/picker.nix`. The picker provides 40+ keymaps under `<leader>f`, `<leader>s`, `<leader>b`, and others.

### None-ls (`config/plugins/none-ls.nix`)

Handles diagnostics and formatting for: statix, rubocop, yamllint, puppet_lint, stylua, nixfmt, yamlfix, nix_flake_fmt.

### AI integration (`config/plugins/ai/default.nix`)

- Copilot-lua: toggle with `<leader>at`
- CodeCompanion: configured with `claude-sonnet-4-6` via `claude_code` adapter
