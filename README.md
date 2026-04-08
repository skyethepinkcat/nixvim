# Nixvim template

This template gives you a good starting point for configuring Nixvim standalone.

## Configuring

To start configuring, just add or modify the nix files in `./config`.
If you add a new configuration file, remember to add it to the
[`config/default.nix`](./config/default.nix) file

## Testing your new configuration

To test your configuration simply run the following command

```
nix run .
```

## Keymaps Made Easy

Instead of creating keymaps as both keymap entries and which-key functions,
I've written some a helper setup that combines them. ``keyList`` is a top level
option that contains a list of ``keyObj``s, which are defined like:

```nix
{
    key,
    action,
    icon ? null,
    desc ? null,
    mode ? "n",
    hidden ? false,
    group ? null,
extraOpts ? {},
}:
```

Usage example would be turning:

```nix
keymaps = [
    {
        action = "<cmd>ToggleTerm<cr>";
        mode = "n";
        key = "<leader>tt";
        options = {
            desc = "Toggle Terminal";
        }
    }
];

wKeyList = [
    (config.lib.nvix.wKeyObj
        "<leader>tt"
        ""
        "Toggle Terminal"
    )
];
```

Into:


```nix
keyList = [
    config.lib.keys.keyObj {
        key = "<leader>tt";
        action = "<cmd>ToggleTerm<cr>";
        icon = "";
        desc = "Toggle Terminal";
    }
];
```
