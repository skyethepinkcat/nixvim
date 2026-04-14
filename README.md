# Nixvim Config

My personal nixvim config, inspired by nvix but with more options specific to my needs.

## Contents

- [Usage](#usage)
- [Flake Outputs](#flake-outputs)
- [Profiles](#profiles)
- [Plugins](#plugins)
- [Keybinding System](#keybinding-system)
- [Development](#development)

---

## Usage

```
nix run .          # run default config
nix run .#nixvim   # same, but binary is called `nixvim` instead of `nvim`
```

### Standalone

```sh
nix run github:skyethepinkcat/nixvim-config
```

### Home Manager

Add to your flake inputs and import `homeModules.default`:

```nix
inputs.nixvim-config.url = "github:skyethepinkcat/nixvim-config";

# in your home-manager module:
imports = [ inputs.nixvim-config.homeModules.default ];
```

### NixOS / nix-darwin

Use the `nixvimModules.default` module directly and wire it into `programs.nixvim`:

```nix
inputs.nixvim-config.url = "github:skyethepinkcat/nixvim-config";

# in your nixos/darwin module:
{ inputs, ... }: {
  imports = [ inputs.nixvim.nixosModules.nixvim ];
  programs.nixvim = {
    enable = true;
    imports = [ inputs.nixvim-config.nixvimModules.default ];
  };
}
```

---

## Flake Outputs

| Output | Description |
|--------|-------------|
| `packages.default` / `packages.neovim` | Standard neovim build |
| `packages.nixvim` | Same build, binary renamed to `nixvim` |
| `packages.nixvim-print-init` | Print the generated `init.lua` |
| `packages.nvim-config-export` | Portable config for non-Nix systems (see below) |
| `nixvimModules.default` | Reusable NixOS/home-manager module |
| `nixvimModules.full` | Module with AI profile enabled |
| `nixvimModules.export` | Module with nix-managed paths stripped |

### Portable Export

Produces a `~/.config/nvim`-compatible directory without any `/nix/store` paths:

```
nix build .#nvim-config-export
cp -r result/ ~/.config/nvim
```

> Tree-sitter parsers are not bundled — run `:TSInstall` on the target machine.
> LSP servers and formatters must be installed separately (Mason is included).

---

## Profiles

Profiles are opt-in layers on top of the base config.

| Profile | Flag | Description |
|---------|------|-------------|
| `default` | (always on) | Core editor, LSP, completion, UI |
| `full` | `profiles.ai = true` | Adds Claude CLI integration and Copilot |
| `export` | `profiles.export = true` | Strips nix store paths for portability |

To enable a profile when importing as a module, set the flag in your config:

```nix
# home-manager example with AI profile
imports = [ inputs.nixvim-config.homeModules.default ];
programs.nixvim.profiles.ai = true;
```

Or use the pre-composed `nixvimModules.full` output which has `profiles.ai = true` already set.

---

## Plugins

### UI
- **render-markdown** — in-buffer markdown rendering (off by default, toggle with `<LocalLeader>t`)
- **markdown-preview** — browser preview via `<LocalLeader>P`
- **lualine** — statusline
- **nvim-tree** — file explorer (`<leader>e`)
- **dashboard** — start screen
- **indent-line** — indentation guides
- **which-key** - extensive which-key keybinds

### Editing
- **treesitter** — syntax / highlighting
- **blink-cmp** — completion
- **none-ls** — formatting / linting bridge
- **LSP** — language server support
- **copilot-lua** — AI inline suggestions (requires `full` profile)

### Navigation
- **picker** (fzf/telescope) — fuzzy finding

### Workflow
- **toggleterm** — floating terminal
- **which-key** — keybinding hints
- **git** — git integration
- **config-local** — per-project `.nvim.lua` support

### AI (`full` profile)
- **Claude CLI** — floating terminal sessions (`<leader>ac`)
  - `<leader>aC` — `claude --continue`
  - `<leader>aV` — `claude --verbose`
  - `<leader>ar` — `claude --resume`
- **Copilot** — inline suggestions

---

## Keybinding System

`keyList` / `keyObj` is a thin wrapper that registers both a keymap and a which-key entry in one call, avoiding duplication.

```nix
keyList = [
  (keyObj {
    key    = "<leader>tt";
    action = "<cmd>ToggleTerm<cr>";
    icon   = "";
    desc   = "Toggle Terminal";
    # mode   ? "n"
    # hidden ? false
    # group  ? null
    # extraOpts ? {}
  })
];
```

For group labels only (no action), set action to null:

```nix
keyList = [
  (keyObj {
    key    = "<leader>t";
    action = null;
    group = "Terminal";
  })
];
```

### Leader keys

| Key | Role |
|-----|------|
| `<Space>` | `<leader>` |
| `,` | `<LocalLeader>` (buffer-local keymaps) |

---

## Development

```
nix develop        # shell with nixd, nixfmt, statix, lua-language-server
nix fmt            # format all nix files
nix run .          # test config
nix run .#nixvim-print-init  # inspect generated init.lua
```

Parts of this configuration were written with assistance from Claude (Anthropic).
