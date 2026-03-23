local nvim_lsp = vim.lsp
nvim_lsp.config("nixd", {
  cmd = { "nixd" },
  filetypes = { "nix" },
  root_markers = { "flake.nix", ".git" },
  settings = {
    nixd = {
      nixpkgs = {
        expr = "import <nixpkgs> { }",
      },
      formatting = {
        command = { "nixfmt" },
      },
      options = {
        nixvim = {
          expr = '(builtins.getFlake (toString ./.)).homeModules.nixvim.programs.nixvim.options',
        },
      },
    },
  },
})
nvim_lsp.enable("nixd")
