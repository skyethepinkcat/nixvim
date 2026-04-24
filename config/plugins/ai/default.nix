{
  config,
  lib,
  ...
}:
let
  inherit (lib.nixvim) mkRaw;
  inherit (config.nvix.mkKey) wKeyObj;
  inherit (config.lib.keys) keyObj;
  opencodeAvailable = mkRaw "vim.fn.executable('opencode') == 1";
in
{
  config = lib.mkIf config.profiles.ai {
    extraConfigLuaPre =
      # lua
      ''
        if vim.fn.executable('opencode') == 1 then
          local Terminal = require('toggleterm.terminal').Terminal

          local function on_open(term)
            vim.keymap.set('t', '<C-d>', function() term:toggle() end, { buffer = term.bufnr, noremap = true, silent = true })
          end

          local opencode         = Terminal:new({ cmd = "opencode",            hidden = true, direction = "float", on_open = on_open })
          local opencode_resume  = Terminal:new({ cmd = "opencode --continue", hidden = true, direction = "float", on_open = on_open })

          local _opencode_last = opencode

          local _opencode_all = { opencode, opencode_resume }

          function _opencode_toggle()
            _opencode_last:toggle()
          end

          function _opencode_resume_toggle()
            _opencode_last = opencode_resume
            opencode_resume:toggle()
          end

          function _opencode_close_all()
            for _, term in ipairs(_opencode_all) do
              term:close()
            end
          end
        end
      '';

    plugins.copilot-lua.enable = true;

    # Group-only label — no action, must stay as wKeyList
    wKeyList = [
      (wKeyObj [
        "<leader>a"
        "󰚩"
        "ai"
      ])
    ];

    keyList = [
      (keyObj {
        mode = "n";
        key = "<leader>aa";
        action = mkRaw "_opencode_toggle";
        hidden = true;
        cond = opencodeAvailable;
        desc = "Toggle Opencode";
      })
      (keyObj {
        mode = "n";
        icon = "󰚩";
        key = "<leader>ac";
        action = mkRaw "_opencode_toggle";
        cond = opencodeAvailable;
        desc = "Toggle Opencode";
      })
      (keyObj {
        mode = "n";
        key = "<leader>ar";
        action = mkRaw "_opencode_resume_toggle";
        cond = opencodeAvailable;
        desc = "Opencode Resume";
      })
      (keyObj {
        mode = "n";
        key = "<leader>aX";
        action = mkRaw "_opencode_close_all";
        cond = opencodeAvailable;
        desc = "Close All Opencode";
      })
    ];
  };

  options = {
    ai.suggestions = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable AI suggestions in completion menu.";
    };
  };
}
