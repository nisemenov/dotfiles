-- basic settings
vim.opt.mouse = "c"
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.ignorecase = false
vim.opt.hlsearch = true
vim.opt.swapfile = false
vim.opt.clipboard = "unnamedplus" -- поддержка clipboard
vim.opt.termguicolors = true
vim.opt.tabstop = 4 -- Spaces instead of one tab
vim.opt.softtabstop = 4 -- Spaces instead of one tab
vim.opt.shiftwidth = 4 -- Spaces for auto indent
vim.opt.expandtab = true -- Replace tab with spaces
vim.opt.autoindent = true -- Save indent on new line
vim.opt.autoread = true

vim.api.nvim_create_autocmd({"FocusGained", "BufEnter", "CursorHold"}, {
  pattern = "*",
  command = "checktime",
  desc = "Check for file changes on focus, buffer enter, or cursor hold",
})

-- splitting
vim.opt.splitbelow = true
vim.opt.splitright = true
-- format of doc
vim.opt.fileformat = "unix"
vim.opt.list = true
-- vim.opt.endoffile = true

-- for nvim-tree disable netrw
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Common keymaps
vim.keymap.set("n", "H", "gT", { noremap = true, silent = true })
vim.keymap.set("n", "L", "gt", { noremap = true, silent = true })
vim.keymap.set("n", "<C-j>", "7j", { noremap = true, silent = true })
vim.keymap.set("n", "<C-k>", "7k", { noremap = true, silent = true })
vim.keymap.set("n", ",<Space>", ":nohlsearch<CR>", { noremap = true, silent = true })
vim.keymap.set("n", ",r", ":checktime<CR>", { noremap = true, silent = true })
-- Telescope
vim.keymap.set("n", ",f", ":Telescope find_files<CR>", { noremap = true })
vim.keymap.set("n", ",g", ":Telescope live_grep<CR>", { noremap = true })
-- NvimTreeToggle
vim.keymap.set("n", "<C-n>", ":NvimTreeToggle<CR>", { noremap = true, silent = true })

-- Keymaps for programming languages
vim.api.nvim_create_autocmd("FileType", {
    pattern = "python",
    callback = function()
        vim.opt.colorcolumn = "88"
    end
})

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

-- функция удаление дефолтного маппинга <C-K> с сохранением остальных дефолтных значений для nvim-tree
local function my_on_attach(bufnr)
    local api = require("nvim-tree.api")

    local function opts(desc)
        return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
    end

    api.config.mappings.default_on_attach(bufnr)
    vim.keymap.del("n", "<C-k>", { buffer = bufnr })
end

-- подключение плагинов
require("lazy").setup({
    { "neovim/nvim-lspconfig" },
    { "hrsh7th/nvim-cmp" },
    { "hrsh7th/cmp-nvim-lsp" },
    { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate", lazy = false },
    { "nvim-telescope/telescope.nvim", dependencies = { "nvim-lua/plenary.nvim" } },
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    { "Pocco81/auto-save.nvim", config = function() require("auto-save").setup() end },
    {
        "nvim-tree/nvim-tree.lua",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        opts = {
            view = { 
                width = 30,
            },
            filters = { 
                custom = { ".mypy_cache", ".ruff_cache", ".git", },
            },
            -- git = {
            --     ignore = false,
            -- },
            on_attach = my_on_attach,
            update_focused_file = {
                enable = true,           -- Автоматически обновлять дерево при фокусе на файле
                update_root = true,      -- Обновлять корень дерева
            },
            filesystem_watchers = {
                enable = true,           -- Включить наблюдение за файловой системой
            },
        },
    },
    {
        'numToStr/Comment.nvim',
        opts = {
            padding = true,
            toggler = {
                line = ',cc',  -- Закомментировать строку (вместо 'gcc')
            },
            opleader = {
                line = ',c',   -- Закомментировать строки в визуальном режиме (вместо 'gc')
            },
        },
    },
    { "folke/tokyonight.nvim", lazy = false, priority = 1000, config = function() vim.cmd("colorscheme tokyonight") end },
},{
    rocks = {
        enabled = false,   -- Полностью отключает luarocks
        hererocks = false, -- Отключает встроенную установку luarocks
    }
})
require("telescope").load_extension("fzf")

-- LSP
local lspconfig = require("lspconfig")
lspconfig.pyright.setup {}

vim.diagnostic.config({
    virtual_text = {
        prefix = "●", -- Символ перед текстом ошибки
        source = "always", -- Показывать источник ошибки (например, pyright)
    },
    signs = true, -- Включить знаки слева (например, "E")
    underline = true, -- Подчеркивать проблемный код
    update_in_insert = false, -- Не обновлять диагностику во время ввода
    severity_sort = true, -- Сортировать по уровню серьезности
})

vim.keymap.set("n", "K", vim.lsp.buf.hover, { noremap=true, silent=true })
vim.keymap.set("n", "gd", function()
    vim.cmd("split")
    vim.lsp.buf.definition()
end, { noremap = true, silent = true })

-- Autocomplete
local cmp = require("cmp")
cmp.setup({
    mapping = {
        ["<C-Space>"] = cmp.mapping.complete(), -- Вызов меню автокомплита
        ["<C-e>"] = cmp.mapping.abort(), -- Закрыть меню
        ["<CR>"] = cmp.mapping.confirm({ select = true }), -- Подтвердить выбор
        ["<C-p>"] = cmp.mapping.select_prev_item(), -- Навигация вверх
        ["<C-n>"] = cmp.mapping.select_next_item(), -- Навигация вниз
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

