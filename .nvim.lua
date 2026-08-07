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
					expr = "(builtins.getFlake (toString ./.)).currentSystem.nixvimConfigurations.default.options",
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

local ok, mod = pcall(require, "nixmodules")
if ok then
	mod.output = "nixvimConfigurations.aarch64-darwin.default"
end
vim.lsp.enable("nixd")
vim.lsp.enable("lua_ls")
