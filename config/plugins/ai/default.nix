{
  config,
  lib,
  ...
}:
let
  inherit (lib.nixvim) mkRaw;
  inherit (config.nvix.mkKey) wKeyObj;
  inherit (config.lib.keys) keyObj;
  claudeAvailable = mkRaw "vim.fn.executable('claude') == 1";
in
{
  config = lib.mkIf config.profiles.ai {
    extraConfigLua =
      # lua
      ''
        if vim.fn.executable('claude') == 1 then
          local Terminal = require('toggleterm.terminal').Terminal

          local function on_open(term)
            vim.keymap.set('t', '<C-d>', function() term:toggle() end, { buffer = term.bufnr, noremap = true, silent = true })
          end

          local claude         = Terminal:new({ cmd = "claude",            hidden = true, direction = "float", on_open = on_open })
          local claude_continue = Terminal:new({ cmd = "claude --continue", hidden = true, direction = "float", on_open = on_open })
          local claude_verbose  = Terminal:new({ cmd = "claude --verbose",  hidden = true, direction = "float", on_open = on_open })
          local claude_resume   = Terminal:new({ cmd = "claude --resume",   hidden = true, direction = "float", on_open = on_open })

          local _claude_last = claude

          local _claude_all = { claude, claude_continue, claude_verbose, claude_resume }

          function _claude_toggle()
            _claude_last:toggle()
          end

          function _claude_continue_toggle()
            _claude_last = claude_continue
            claude_continue:toggle()
          end

          function _claude_verbose_toggle()
            _claude_last = claude_verbose
            claude_verbose:toggle()
          end

          function _claude_resume_toggle()
            _claude_last = claude_resume
            claude_resume:toggle()
          end

          function _claude_close_all()
            for _, term in ipairs(_claude_all) do
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
        action = mkRaw "_claude_toggle";
        hidden = true;
        cond = claudeAvailable;
        desc = "Toggle Claude";
      })
      (keyObj {
        mode = "n";
        icon = "󰚩";
        key = "<leader>ac";
        action = mkRaw "_claude_toggle";
        cond = claudeAvailable;
        desc = "Toggle Claude";
      })
      (keyObj {
        mode = "n";
        key = "<leader>aC";
        action = mkRaw "_claude_continue_toggle";
        cond = claudeAvailable;
        desc = "Claude Continue";
      })
      (keyObj {
        mode = "n";
        key = "<leader>aV";
        action = mkRaw "_claude_verbose_toggle";
        cond = claudeAvailable;
        desc = "Claude Verbose";
      })
      (keyObj {
        mode = "n";
        key = "<leader>ar";
        action = mkRaw "_claude_resume_toggle";
        cond = claudeAvailable;
        desc = "Claude Resume";
      })
      (keyObj {
        mode = "n";
        key = "<leader>aX";
        action = mkRaw "_claude_close_all";
        cond = claudeAvailable;
        desc = "Close All Claude";
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
