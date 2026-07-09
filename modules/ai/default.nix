{
  config,
  lib,
  ...
}:
let
  inherit (lib.nixvim) mkRaw;
  inherit (config.nvix.mkKey) wKeyObj;
  opencodeAvailable = mkRaw "vim.fn.executable('opencode') == 1";
  claudeAvailable = mkRaw "vim.fn.executable('claude') == 1";
in
{
  config = {
    extraConfigLuaPre =
      (builtins.readFile ./ai.lua)
      + (
        if config.ai.default == "opencode" then
          # lua
          ''
            if vim.fn.executable("opencode") == 1 then
              _ai_last = _opencode_toggle
            end
          ''
        else if config.ai.default == "claude" then
          # lua
          ''
            if vim.fn.executable("claude") == 1 then
              _ai_last = _claude_toggle
            end
          ''
        else
          # lua
          ''
            if _ai_last == nil then
              if vim.fn.executable("opencode") == 1 then
                _ai_last = _opencode_toggle
              elseif vim.fn.executable("claude") == 1 then
                _ai_last = _claude_toggle
              end
            end
          ''
      );

    plugins = {
      copilot-lua.enable = config.ai.suggestions;
      blink-cmp.sources.default = [
        "copilot"
      ];
    };

    # Group-only label — no action, must stay as wKeyList
    wKeyList = [
      (wKeyObj [
        "<leader>a"
        "󰚩"
        "ai"
      ])
      (wKeyObj [
        "<leader>aX"
        "󰯇"
        "kill sessions"
      ])
    ];

    keyList = [
      {
        mode = "n";
        icon = "󰚩";
        key = "<leader>aa";
        action = mkRaw "_ai_last_toggle";
        desc = "Toggle Last AI";
      }
      {
        mode = "n";
        icon = "";
        key = "<leader>ao";
        action = mkRaw "_opencode_toggle";
        cond = opencodeAvailable;
        desc = "Toggle Opencode";
      }
      {
        mode = "n";
        key = "<leader>aO";
        icon = "";
        action = mkRaw "_opencode_resume_toggle";
        cond = opencodeAvailable;
        desc = "Opencode Resume";
      }
      {
        mode = "n";
        key = "<leader>aXo";
        icon = "";
        action = mkRaw "_opencode_close_all";
        cond = opencodeAvailable;
        desc = "Close All Opencode";
      }
      {
        mode = "n";
        icon = "";
        key = "<leader>ac";
        action = mkRaw "_claude_toggle";
        cond = claudeAvailable;
        desc = "Toggle Claude";
      }
      {
        mode = "n";
        key = "<leader>aC";
        icon = "";
        action = mkRaw "_claude_resume_toggle";
        cond = claudeAvailable;
        desc = "Claude Resume";
      }
      {
        mode = "n";
        key = "<leader>aXc";
        icon = "";
        action = mkRaw "_claude_close_all";
        cond = claudeAvailable;
        desc = "Close All Claude";
      }
    ];
  };

  options = {
    ai.default = lib.mkOption {
      type = lib.types.enum [
        "auto"
        "opencode"
        "claude"
      ];
      default = "auto";
      description = "Default AI tool for _ai_last_toggle. 'auto' picks opencode then claude by availability.";
    };
    ai.suggestions = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable AI suggestions in completion menu.";
    };
  };
}
