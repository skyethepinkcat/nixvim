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

## Flake Outputs

### Modules

| Output                  | Description                                                                         |
| ----------------------- | ----------------------------------------------------------------------------------- |
| `nixvimModules.ai`      | AI Configuration for Claude and Opencode, as well as copilot suggestions.           |
| `nixvimModules.default` | Basic neovim configuration with additional plugins like which-key, treesitter, etc. |
| `nixvimModules.export`  | Removes nix-native configuration options.                                           |
| `nixvimModules.extra`   | Mostly silly or very computer-specific stuff.                                       |
| `nixvimModules.ui`      | UI things, including noice, lualine, tabs via scope, nvim-tree, and notify.         |
| `nixvimModules.lsp`     | My LSP settings using native lsp and none-ls.                                       |
| `nixvimModules.scratch` | Used for testing, basic module with only the framework included.                    |

### Configurations

| Output                         | Description                                          |
| ------------------------------ | ---------------------------------------------------- |
| `nixvimConfigurations.default` | Basic configuration with everything but AI enabled.  |
| `nixvimConfigurations.full`    | Default configuration with AI enabled.               |
| `nixvimConfigurations.simple`  | Simplified module with UI and extras stripped.       |
| `nixvimConfigurations.scratch` | Configuration with only framework code. For testing. |

### Packages

A package exists for each configuration under its name.

#### Wrapped Binaries

For convience, wrapped binaries are also provided for each configuration under
`nixvim-<name>` and `<name>-nixvim` (the first will name the binary `nixvim-<configuration>`,
the second will name the binary `nixvim`)

### Portable Export

Each configuration can also be exported for non-nix systems by producting a `~/.config/nvim`-compatible directory without any `/nix/store` paths:

```
nix build .#simple-export
cp -r result/ ~/.config/nvim
```

> Tree-sitter parsers are not bundled, you will need to run `:TSInstall` on the target machine.
> LSP servers and formatters must be installed separately (Mason is included).

#### Tar Archive

A build option for a tar archive is also included for convience.

```
nix build .#simple-export-archive
tar -xf result/nvim.tar.gz -C ~/.config/nvim
```

### Print Init

Each configuration also exposes a print-init package for easy access:

```
nix run .#simple-print-init
```

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
- **copilot-lua** — AI inline suggestions

### Navigation

- **picker** (fzf/telescope) — fuzzy finding

### Workflow

- **toggleterm** — floating terminal
- **which-key** — keybinding hints
- **git** — git integration
- **config-local** — per-project `.nvim.lua` support

### AI

- **Claude CLI** — floating terminal sessions (`<leader>ac`)
  - `<leader>aC` - `claude --continue`
  - `<leader>ar` - `claude --resume`
- **Opencode** - floating terminal sessions ( `<leader>ao` )
  - `<leader>aO` - `opencode --continue`

---

## Keybinding System

`keyList` is a thin wrapper that registers both a keymap and a which-key entry in one call, avoiding duplication.

```nix
keyList = [
  {
    key    = "<leader>tt";
    action = "<cmd>ToggleTerm<cr>";
    icon   = "";
    desc   = "Toggle Terminal";
  }
];
```

For group labels only (no action), set action to null:

```nix
keyList = [
  {
    key    = "<leader>t";
    action = null;
    group = "Terminal";
  }
];
```

## FileType-local Keybinds

### Leader keys

| Key       | Role                                   |
| --------- | -------------------------------------- |
| `<Space>` | `<leader>`                             |
| `,`       | `<LocalLeader>` (buffer-local keymaps) |

---

## Development

```
nix develop        # shell with nixd, nixfmt, statix, lua-language-server
nix fmt            # format all nix files
nix run .          # test config
nix run .#nixvim-print-init  # inspect generated init.lua
```

Parts of this configuration were written with assistance from Claude (Anthropic).
