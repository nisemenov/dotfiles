-- Basic settings
vim.opt.mouse = "c"
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.ignorecase = false
vim.opt.hlsearch = true
vim.opt.autoread = true
vim.opt.swapfile = false
vim.opt.termguicolors = true
vim.opt.tabstop = 4 -- Spaces instead of one tab
vim.opt.softtabstop = 4 -- Spaces instead of one tab
vim.opt.shiftwidth = 4 -- Spaces for auto indent
vim.opt.expandtab = true -- Replace tab with spaces
vim.opt.autoindent = true -- Save indent on new line
vim.opt.fileformat = "unix"
vim.opt.splitbelow = true -- horizontal split open below and right
vim.opt.splitright = true

-- Common keymaps
vim.keymap.set("n", "H", "gT", { noremap = true, silent = true })
vim.keymap.set("n", "L", "gt", { noremap = true, silent = true })
vim.keymap.set("n", "<C-j>", "10j", { noremap = true, silent = true })
vim.keymap.set("n", "<C-k>", "11k", { noremap = true, silent = true })

-- Plugin manager
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git", "clone", "--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", lazypath
	})
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
	{ "neovim/nvim-lspconfig" },
	{ "hrsh7th/nvim-cmp" },
	{ "hrsh7th/cmp-nvim-lsp" },
	{ "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },
    { "nvim-telescope/telescope.nvim", dependencies = { "nvim-lua/plenary.nvim" } },
    { "Pocco81/auto-save.nvim", config = function() require("auto-save").setup() end },
-- Colour themes
--    { "morhetz/gruvbox" },
    { "folke/tokyonight.nvim", lazy = false, priority = 1000, config = function() vim.cmd("colorscheme tokyonight") end },
}, {
    rocks = {
        enabled = false,   -- Полностью отключает luarocks
        hererocks = false, -- Отключает встроенную установку luarocks
    }
})

-- LSP
local lspconfig = require("lspconfig")
lspconfig.pyright.setup {}

-- Autocomplete
local cmp = require("cmp")
cmp.setup({
	mapping = {
        ['<C-Space>'] = cmp.mapping.complete(), -- Вызов меню автокомплита
        ['<C-e>'] = cmp.mapping.abort(), -- Закрыть меню
        ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Подтвердить выбор
        ['<C-p>'] = cmp.mapping.select_prev_item(), -- Навигация вверх
        ['<C-n>'] = cmp.mapping.select_next_item(), -- Навигация вниз
	},
	sources = {
		{ name = "nvim_lsp" },
	},
})

-- Treesitter
require("nvim-treesitter.configs").setup({
	ensure_installed = { "python", "lua", "json", "yaml" },
	highlight = { enable = true },
})

-- LSP keymaps
vim.keymap.set("n", "K", vim.lsp.buf.hover, { noremap=true, silent=true })
vim.keymap.set("n", "gd", function()
    vim.cmd("split")
    vim.lsp.buf.definition()
end, { noremap = true, silent = true })

