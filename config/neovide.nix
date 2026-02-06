{
  extraConfigLua = ''
    if vim.g.neovide then
      -- Neovide-specific settings
      vim.o.guifont = "Menlo,Symbols Nerd Font:h14"
      vim.g.neovide_input_macos_option_key_is_meta = "only_left"

      -- Neovide keymaps
      local wk = require "which-key"
      wk.add {
        mode = "v",
        {
          { "<D-c>", '"+y', desc = "Copy" },
          { "<D-v>", '"+P', desc = "Paste" },
        },
      }
      wk.add {
        mode = "n",
        {
          { "<D-v>", '"+P', desc = "Paste" },
        },
      }
      wk.add {
        mode = "c",
        {
          { "<D-v>", "<C-R>+", desc = "Paste" },
        },
      }
      wk.add {
        mode = "i",
        {
          { "<D-v>", '<ESC>l"+Pli', desc = "Paste" },
        },
      }
    end
  '';
}
