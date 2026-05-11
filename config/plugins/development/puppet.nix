{ lib, utils, ... }:
{
  extraFiles."lua/puppet.lua".source = ./puppet.lua;

  ftKeyList = {
    puppet = [
      {
        key = "<LocalLeader>o";
        action =
          utils.mkFunc
            # lua
            ''
            require('puppet').goto_definition()
            '';
        desc = "open definition under cursor";
      }
    ];
  };
  # Logic here is WAYYYYYYYY more complicated, so instead we'll just use
  # autocmds
  autoCmd = [
    {
      event = "FileType";
      pattern = [ "yaml" "yml" ];
      callback =
        lib.nixvim.mkRaw
          # lua
          ''
            function(ev)
              -- Walk up from buffer dir looking for hiera.yaml.
              -- Stop at .git so we don't escape the project.
              local dir = vim.fn.expand("<afile>:p:h")
              if dir == "" then dir = vim.fn.getcwd() end
              local found = false
              while dir ~= "/" and dir ~= "" do
                if vim.fn.filereadable(dir .. "/hiera.yaml") == 1 then
                  found = true
                  break
                end
                if vim.fn.isdirectory(dir .. "/.git") == 1 then
                  break
                end
                local parent = vim.fn.fnamemodify(dir, ":h")
                if parent == dir then break end
                dir = parent
              end
              if not found then return end
              vim.keymap.set("n", "<LocalLeader>o", function()
                require("puppet").goto_definition()
              end, { buffer = ev.buf, silent = true, desc = "Puppet: open definition under cursor" })
            end
          '';
    }
  ];
}
