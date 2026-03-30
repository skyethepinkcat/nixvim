vim.lsp.config("nixd", {
	cmd = { "nixd" },
	filetypes = { "nix" },
	root_markers = { "flake.nix", ".git" },
	settings = {
		nixd = {
			nixpkgs = {
				expr = "import (builtins.getFlake (toString ./.)).inputs.nixpkgs {}",
			},
			options = {
				nixvim = {
					expr = "(builtins.getFlake (toString ./.)).nixvimConfigurations.aarch64-darwin.default.options",
				},
				flakeparts = {
					expr = "(builtins.getFlake ./.).debug.options",
				},
				flakeparts2 = {
					expr = "(builtins.getFlake ./.).debug.currentSystem.options",
				},
			},
		},
	},
})

vim.lsp.config("lua_ls", {
	settings = {
		Lua = {
			diagnostics = {
				globals = { "vim" },
			},
		},
	},
})

vim.lsp.enable("nixd")
vim.lsp.enable("lua_ls")
