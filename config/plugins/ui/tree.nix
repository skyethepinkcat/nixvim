{ config, lib, pkgs, ... }:
let
  inherit (config.lib.keys) keyObj;
in
{

  plugins.nvim-tree = {
    enable = true;
    settings.on_attach = lib.mkRaw ''
      function(bufnr)
        local api = require("nvim-tree.api")

        local function opts(desc)
          return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
        end

        api.config.mappings.default_on_attach(bufnr)

        local function edit_or_open()
          local node = api.tree.get_node_under_cursor()
          if node.nodes ~= nil then
            api.node.open.edit()
          else
            api.node.open.edit()
            api.tree.close()
          end
        end

        local function vsplit_preview()
          local node = api.tree.get_node_under_cursor()
          if node.nodes ~= nil then
            api.node.open.edit()
          else
            api.node.open.vertical()
          end
          api.tree.focus()
        end

        vim.keymap.set("n", "l", edit_or_open,          opts("Edit Or Open"))
        vim.keymap.set("n", "L", vsplit_preview,        opts("Vsplit Preview"))
        vim.keymap.set("n", "h", api.tree.close,        opts("Close"))
        vim.keymap.set("n", "H", api.tree.collapse_all, opts("Collapse All"))
      end
    '';
  };
  extraPackagesAfter = with pkgs; [
    trash-cli
  ];
  dependencies = {
    fd.enable = true;
    ripgrep.enable = true;
    grep.enable = true;
    tree-sitter = {
      enable = true;
    };
  };
  keyList = [
    (keyObj {
      action = "<cmd>NvimTreeFindFileToggle<cr>";
      key = "<leader>e";
      icon = "󰙅";
      desc = "Explorer";
    })
  ];
}
