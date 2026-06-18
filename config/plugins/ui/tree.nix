{
  config,
  lib,
  pkgs,
  ...
}:
{
  # lovingly stolen from
  # https://github.com/MarioCarrion/videos/blob/269956e913b76e6bb4ed790e4b5d25255cb1db4f/2023/01/nvim/lua/plugins/nvim-tree.lua
  plugins.nvim-tree = {
    enable = true;
    settings = {
      actions.open_file.window_picker = {
        enable = false;
      };
      sync_root_with_cwd = true;
      view = {
        relativenumber = true;
        float = {
          enable = true;
          open_win_config = lib.nixvim.mkRaw ''
            function()
              local WIDTH_RATIO = 0.5
              local HEIGHT_RATIO = 0.8
              local win_w = vim.api.nvim_win_get_width(0)
              local win_h = vim.api.nvim_win_get_height(0)
              local window_w = win_w * WIDTH_RATIO
              local window_h = win_h * HEIGHT_RATIO
              local window_w_int = math.floor(window_w)
              local window_h_int = math.floor(window_h)
              local center_x = (win_w - window_w) / 2
              local center_y = (win_h - window_h) / 2
              return {
                border = "rounded",
                relative = "win",
                row = center_y,
                col = center_x,
                width = window_w_int,
                height = window_h_int,
              }
            end
          '';
        };
        width = lib.nixvim.mkRaw ''
          function()
            local WIDTH_RATIO = 0.5
            return math.floor(vim.opt.columns:get() * WIDTH_RATIO)
          end
        '';
      };
      on_attach = lib.nixvim.mkRaw ''
        function(bufnr)
          local api = require("nvim-tree.api")

          local function opts(desc)
            return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
          end

          api.config.mappings.default_on_attach(bufnr)

          local function openfolder()
            local node = api.tree.get_node_under_cursor()
            if node.nodes ~= nil then
              api.node.open.edit()
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

          vim.keymap.set("n", "l", openfolder, opts("Open/Close Folder"))
          vim.keymap.set("n", "L", vsplit_preview, opts("Vsplit Preview"))
          vim.keymap.set("n", "h", api.node.navigate.parent, opts("Close"))
          vim.keymap.set("n", "H", api.tree.collapse_all, opts("Collapse All"))
          -- Trash is preferred as the default, but it causes issues with floating windows currently.
          vim.keymap.set("n", "d", api.fs.trash, opts("Delete"))
          vim.keymap.set("n", "D", api.fs.remove, opts("Trash"))
        end
      '';
    };
  };
  extraPackagesAfter = lib.optionals (! pkgs.stdenv.hostPlatform.isDarwin) (
    with pkgs;
    [
      trash-cli
    ]
  );
  dependencies = {
    fd.enable = true;
    ripgrep.enable = true;
    grep.enable = true;
  };
  keyList = [
    {
      action = "<cmd>NvimTreeFindFile<cr>";
      key = "<leader>e";
      icon = "󰙅";
      desc = "Explorer";
    }
  ];
}
