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
  claudeAvailable = mkRaw "vim.fn.executable('claude') == 1";
in
{
  config = lib.mkIf config.profiles.ai {
    extraConfigLuaPre = builtins.readFile ./ai.lua;

    plugins.copilot-lua.enable = true;

    # Group-only label — no action, must stay as wKeyList
    wKeyList = [
      (wKeyObj [
        "<leader>a"
        "󰚩"
        "ai"
      ])
      (wKeyObj [
        "<leader>aX"
        ""
        "kill sessions"
      ])
    ];

    keyList = [
      (keyObj {
        mode = "n";
        icon = "󰚩";
        key = "<leader>aa";
        action = mkRaw "_ai_last_toggle";
        desc = "Toggle Last AI";
      })
      (keyObj {
        mode = "n";
        icon = "";
        key = "<leader>ao";
        action = mkRaw "_opencode_toggle";
        cond = opencodeAvailable;
        desc = "Toggle Opencode";
      })
      (keyObj {
        mode = "n";
        key = "<leader>aO";
        icon = "";
        action = mkRaw "_opencode_resume_toggle";
        cond = opencodeAvailable;
        desc = "Opencode Resume";
      })
      (keyObj {
        mode = "n";
        key = "<leader>aXo";
        icon = "";
        action = mkRaw "_opencode_close_all";
        cond = opencodeAvailable;
        desc = "Close All Opencode";
      })
      (keyObj {
        mode = "n";
        icon = "";
        key = "<leader>ac";
        action = mkRaw "_claude_toggle";
        cond = claudeAvailable;
        desc = "Toggle Claude";
      })
      (keyObj {
        mode = "n";
        key = "<leader>aC";
        icon = "";
        action = mkRaw "_claude_resume_toggle";
        cond = claudeAvailable;
        desc = "Claude Resume";
      })
      (keyObj {
        mode = "n";
        key = "<leader>aXc";
        icon = "";
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
