{ lib, ... }:
{
  # Import all your configuration modules here
  imports =
    with builtins;
    with lib;
    map (fn: ./${fn}) (
      filter (fn: (fn != "default.nix" && hasSuffix ".nix" "${fn}") || pathExists ./${fn}/default.nix) (
        attrNames (readDir ./.)
      )
    );

  # Experimental lualoader, which should improve load times?
  luaLoader.enable = true;

  nvix.transparent = false;
  globals = {
    mapleader = " ";
    maplocalleader = ",";

    # These are *disabling* netrw, by telling vim its already loaded.
    loaded_netrw = 1;
    loaded_netrwPlugin = 1;
  };

  opts = rec {
    clipboard = "unnamedplus"; # sync yank/paste with system clipboard
    cursorline = true; # highlight current line
    cursorlineopt = "number"; # only highlight the line number, not the full line

    pumblend = 0; # popup menu opacity (0 = opaque)
    pumheight = 10; # max items shown in popup menu

    expandtab = true; # <Tab> inserts spaces
    smartindent = true; # auto-indent based on syntax
    shiftwidth = 2; # spaces per indent level (>> / <<)
    tabstop = shiftwidth; # visual width of a \t character
    softtabstop = shiftwidth; # spaces inserted/deleted on <Tab>/<BS>

    background = "dark"; # hint colorschemes to use dark variants
    ignorecase = true; # case-insensitive search
    smartcase = true; # override ignorecase when pattern has uppercase
    infercase = true; # smarter case matching on word completion

    number = true; # show absolute line numbers
    relativenumber = true; # show relative numbers (absolute on cursor line)

    title = true; # set window title to filename
    undofile = true; # persist undo history across sessions ($XDG_STATE_HOME/nvim/undo)

    scrolloff = 5; # keep 5 lines visible above/below cursor
    mouse = "a"; # enable mouse in all modes
    cmdheight = 0; # hide cmdline when not in use
    signcolumn = "yes"; # always show sign column (prevents layout shift)

    splitbelow = true; # horizontal splits open below
    splitright = true; # vertical splits open right
    splitkeep = "screen"; # keep visible text stable when splitting

    termguicolors = true; # enable 24-bit RGB colors
    conceallevel = 1; # hide concealed text (e.g. markdown syntax characters)
    wrap = true; # enable "soft" line wrapping

    virtualedit = "block"; # allow cursor past end of line in visual block mode
    winminwidth = 5; # minimum window width
    fileencoding = "utf-8"; # file encoding
    smoothscroll = true; # smooth scrolling with <C-d>/<C-u>
    autoread = true; # reload file when changed outside vim
    autowrite = true; # auto-save before commands like :make
    swapfile = false; # no swap files
    fillchars = {
      eob = " "; # hide ~ on empty lines after buffer end
    };

    updatetime = 500; # ms idle before CursorHold fires (affects diagnostics, gitsigns)

    foldmethod = "expr"; # Use expression to generate folds
    foldexpr = "v:lua.vim.treesitter.foldexpr()"; # Use tree-sitter as fold expression.
    foldlevel = 99;
    foldenable = false;

    textwidth = 80; # Prefer 80 character lines
    linebreak = true;

    showmode = false; # Don't show modes in noice statusbar
  };

  keyList = [
    {
      action = "<cmd>b#<cr>";
      key = "<leader><tab>";
      icon = "";
      desc = "Last Buffer";
    }
  ];
  withPython3 = true;
  withPerl = true;
  withNodeJs = true;
  dependencies.tree-sitter = {
    enable = true;
  };

  extraConfigLuaPre = lib.mkOrder 0 ''
    -- If you have fucking NVIM_SYSTEM_RPLUGIN_MANIFEST defined outside nvim you
    -- deserve whats about to happen to you.
    if os.getenv("NVIM_SYSTEM_RPLUGIN_MANIFEST") then
      -- This won't actually show up in terminal for some reason, but I can't
      -- find a solution.
      vim.api.nvim_echo({{"Cowardly refusing to recursively start nvim.\n"}},
        true, {err = true})
      vim.cmd("cquit 1")  -- exit immediately with error code 1
    end
  '';
}
