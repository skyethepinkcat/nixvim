# This is common neovim settings with basic plugin sets
{ config, lib, ... }:
let
  inherit (config.nvix) icons;
  inherit (lib.nixvim) mkRaw;
in
{
  imports =
    with builtins;
    with lib;
    map (fn: ./${fn}) (
      filter (fn: (fn != "default.nix" && !hasSuffix ".md" "${fn}")) (attrNames (readDir ./.))
    );

  extraConfigLua =
    with icons.diagnostics;
    # lua
    ''
      vim.api.nvim_set_hl(0, "DiagnosticUnderlineError", { undercurl = true })
      vim.api.nvim_set_hl(0, "DiagnosticUnderlineWarn",  { undercurl = true })
      vim.api.nvim_set_hl(0, "DiagnosticUnderlineInfo",  { undercurl = true })
      vim.api.nvim_set_hl(0, "DiagnosticUnderlineHint",  { undercurl = true })
      local function my_paste(reg)
        return function(lines)
          local content = vim.fn.getreg('"')
          return vim.split(content, '\n')
        end
      end
      if (os.getenv('SSH_TTY') ~= nil)
        then
          vim.g.clipboard = {
            name = 'OSC 52',
            copy = {
              ['+'] = require('vim.ui.clipboard.osc52').copy('+'),
              ['*'] = require('vim.ui.clipboard.osc52').copy('*'),
            },
            paste = {
              ["+"] = my_paste("+"),
              ["*"] = my_paste("*"),
            },
          }
        end



      vim.opt.whichwrap:append("<>[]hl")
      -- vim.opt.listchars:append("space:·")

      -- below part set's the Diagnostic icons/colors
      local signs = {
        Hint = "${BoldHint}",
        Info = "${BoldInformation}",
        Warn = "${BoldWarning}",
        Error = "${BoldError}",
      }

      for type, icon in pairs(signs) do
        local hl = "DiagnosticSign" .. type
        vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
      end
    '';

  autoCmd = [
    {
      desc = "Highlight on yank";
      event = [ "TextYankPost" ];
      callback =
        # lua
        mkRaw ''
          function()
            vim.highlight.on_yank()
          end
        '';
    }
    {
      desc = "Check file changes";
      event = [
        "FocusGained"
        "BufEnter"
        "CursorHold"
      ];
      pattern = [ "*" ];
      callback =
        # lua
        mkRaw ''
          function()
            if vim.fn.mode() ~= "c" then
              vim.cmd("checktime")
            end
          end
        '';
    }
  ];

  extraLuaPackages = lp: with lp; [ luarocks ];
}
