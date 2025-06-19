-- Set <space> as the leader key
-- See `:help mapleader`
--  NOTE: Must happen before plugins are loaded (otherwise wrong leader will be used)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Custom User Settings
vim.o.guifont = "Source Code Pro Nerd Font:h14"
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Set to true if you have a Nerd Font installed and selected in the terminal
vim.g.have_nerd_font = true -- Custom: Enabled Nerd Font

-- [[ Setting options ]]
-- See `:help vim.o`
vim.o.number = true
vim.o.relativenumber = true -- Custom: Enabled relative numbers
vim.o.mouse = 'a'
vim.o.showmode = false
vim.o.clipboard = 'unnamedplus'
vim.o.breakindent = true
vim.o.undofile = true
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.signcolumn = 'yes'
vim.o.updatetime = 250
vim.o.timeoutlen = 300
vim.o.splitright = true
vim.o.splitbelow = true
vim.o.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }
vim.o.inccommand = 'split'
vim.o.cursorline = true
vim.o.scrolloff = 10
vim.o.confirm = true
vim.o.termguicolors = true
vim.go.background = "dark"

-- [[ Basic Keymaps ]]

-- Clear highlights on search
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Diagnostic keymaps
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Open floating diagnostic message' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostics list' })
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous diagnostic message' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next diagnostic message' })


-- Exit terminal mode
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- [[ Workman Remap Stefan ]]
vim.keymap.set({ 'n', 'v' }, 'y', 'z', { noremap = true }) -- used by leap instead
vim.keymap.set({ 'n', 'v' }, 'z', 'y', { noremap = true })
vim.keymap.set({ 'n', 'v' }, 'yy', 'zz', { noremap = true })
vim.keymap.set({ 'n', 'v' }, 'zz', 'yy', { noremap = true })
vim.keymap.set({ 'n', 'v' }, 't', 'j', { noremap = true })
vim.keymap.set({ 'n', 'v' }, 'h', 'k', { noremap = true })
vim.keymap.set({ 'n', 'v' }, 'k', 'h', { noremap = true })

vim.keymap.set({ 'n', 'v' }, 'Y', 'Z', { noremap = true }) -- used by leap instead
vim.keymap.set({ 'n', 'v' }, 'Z', 'Y', { noremap = true })
vim.keymap.set({ 'n', 'v' }, 'T', 'J', { noremap = true })
vim.keymap.set({ 'n', 'v' }, 'H', 'K', { noremap = true })
vim.keymap.set({ 'n', 'v' }, 'K', 'H', { noremap = true })

-- Custom word wrap remap
vim.keymap.set('n', 'h', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 't', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })


-- Custom window navigation remaps
vim.keymap.set({ 'n' }, '<Leader>h', '<C-w>k', { desc = "move window up" })
vim.keymap.set({ 'n' }, '<Leader>t', '<C-w>j', { desc = "move window down" })
vim.keymap.set({ 'n' }, '<Leader>k', '<C-w>h', { desc = "move window left" })
vim.keymap.set({ 'n' }, '<Leader>l', '<C-w>l', { desc = "move window right" })
vim.keymap.set({ 'n' }, '<Leader>b', '<C-w>b', { desc = "move to bottom window" })
vim.keymap.set({ 'n' }, '<Leader>j', '<C-w>t', { desc = '[J]ump to top window' })

-- Remap original window navigation to workman layout
vim.keymap.set({ 'n' }, '<C-w>h', '<C-w>k')
vim.keymap.set({ 'n' }, '<C-w>t', '<C-w>j')
vim.keymap.set({ 'n' }, '<C-w>k', '<C-w>h')
-- <C-w>l is the same
vim.keymap.set({ 'n' }, '<C-w>j', '<C-w>t')

-- Custom tab navigation
vim.keymap.set('n', '<C-t>', ':tabedit<CR>', { desc = "New [T]ab", silent = true })
vim.keymap.set('n', '<C-q>', ':tabclose<CR>', { desc = "[Q]uit tab", silent = true })
vim.keymap.set('n', '<leader>1', '1gt', { desc = "Go to tab 1" })
vim.keymap.set('n', '<leader>2', '2gt', { desc = "Go to tab 2" })
vim.keymap.set('n', '<leader>3', '3gt', { desc = "Go to tab 3" })
vim.keymap.set('n', '<leader>4', '4gt', { desc = "Go to tab 4" })
vim.keymap.set('n', '<leader>5', '5gt', { desc = "Go to tab 5" })
vim.keymap.set('n', '<leader>6', '6gt', { desc = "Go to tab 6" })
vim.keymap.set('n', '<leader>7', '7gt', { desc = "Go to tab 7" })
vim.keymap.set('n', '<leader>8', '8gt', { desc = "Go to tab 8" })
vim.keymap.set('n', '<leader>9', '9gt', { desc = "Go to tab 9" })
vim.keymap.set('n', '<leader>0', ':tablast<CR>', { desc = "Go to last tab" })


-- [[ Basic Autocommands ]]
-- Highlight on yank
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.hl.on_yank()
  end,
})

-- [Stefan] Write on focus lost
vim.api.nvim_create_autocmd("FocusLost", {
  pattern = '*',
  command = 'wa'
})

-- [Stefan] Toggle Diagnostics Command
vim.api.nvim_create_user_command(
  'ToggleDiag',
  function()
    local current_value = vim.diagnostic.is_disabled()
    if current_value then
      vim.diagnostic.config({ virtual_text = true })
      vim.diagnostic.enable()
      print("Diagnostics Enabled")
    else
      vim.diagnostic.config({ virtual_text = false })
      vim.diagnostic.disable()
      print("Diagnostics Disabled")
    end
  end,
  { desc = "Toggle inline diagnostics display" }
)
vim.keymap.set('n', '<leader>tv', ':ToggleDiag<CR>', { desc = '[T]oggle [V]irtualText' })


-- [[ Install `lazy.nvim` plugin manager ]]
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  local out = vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
  if vim.v.shell_error ~= 0 then
    error('Error cloning lazy.nvim:\n' .. out)
  end
end
vim.opt.rtp:prepend(lazypath)

-- [[ Configure and install plugins ]]
require('lazy').setup({
  -- Git related plugins
  'tpope/vim-fugitive',
  'tpope/vim-rhubarb',
  'tpope/vim-sleuth',

  -- Colorscheme
  {
    'navarasu/onedark.nvim',
    priority = 1000,
    config = function()
      vim.cmd.colorscheme 'onedark'
    end,
  },

  { -- Adds git related signs to the gutter
    'lewis6991/gitsigns.nvim',
    opts = {
      signs = {
        add = { text = '+' },
        change = { text = '~' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
      },
      on_attach = function(bufnr)
        local gs = package.loaded.gitsigns
        vim.keymap.set({ 'n', 'v' }, ']c', function()
          if vim.wo.diff then return ']c' end
          vim.schedule(function() gs.next_hunk() end)
          return '<Ignore>'
        end, { expr = true, buffer = bufnr, desc = 'Jump to next hunk' })

        vim.keymap.set({ 'n', 'v' }, '[c', function()
          if vim.wo.diff then return '[c' end
          vim.schedule(function() gs.prev_hunk() end)
          return '<Ignore>'
        end, { expr = true, buffer = bufnr, desc = 'Jump to previous hunk' })
      end,
    },
  },

  { -- Useful plugin to show you pending keybinds.
    'folke/which-key.nvim',
    event = 'VimEnter',
    config = function()
        require('which-key').setup()
        require('which-key').register {
            ['<leader>c'] = { name = '[C]ode', _ = 'which_key_ignore' },
            ['<leader>d'] = { name = '[D]ocument', _ = 'which_key_ignore' },
            ['<leader>f'] = { name = '[F]ind', _ = 'which_key_ignore' },
            ['<leader>g'] = { name = '[G]it', _ = 'which_key_ignore' },
            ['<leader>r'] = { name = '[R]ename', _ = 'which_key_ignore' },
            ['<leader>s'] = { name = '[S]urround', _ = 'which_key_ignore' },
            ['<leader>t'] = { name = '[T]oggle/[T]rouble', _ = 'which_key_ignore' },
            ['<leader>w'] = { name = '[W]orkspace', _ = 'which_key_ignore' },
            ['<leader>e'] = { name = '[E]xplorer/[E]dit', _ = 'which_key_ignore'},
        }
    end
  },

  { -- Fuzzy Finder
    'nvim-telescope/telescope.nvim',
    event = 'VimEnter',
    branch = '0.1.x',
    dependencies = {
      'nvim-lua/plenary.nvim',
      {
        'nvim-telescope/telescope-fzf-native.nvim',
        build = 'make',
        cond = function()
          return vim.fn.executable 'make' == 1
        end,
      },
      { 'nvim-tree/nvim-web-devicons' },
    },
    config = function()
      require('telescope').setup {
        defaults = {
          mappings = {
            i = { ['<C-u>'] = false, ['<C-d>'] = false },
          },
        },
        pickers = {
            find_files = { theme = 'ivy' },
            git_files = { theme = 'ivy' },
        },
        extensions = { fzf = {} },
      }

      pcall(require('telescope').load_extension, 'fzf')

      local builtin = require 'telescope.builtin'
      vim.keymap.set('n', '<leader>?', builtin.oldfiles, { desc = '[?] Find recently opened files' })
      vim.keymap.set('n', '<leader><space>', builtin.buffers, { desc = '[ ] Find existing buffers' })
      vim.keymap.set('n', '<leader>/', function()
        builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
          winblend = 10,
          previewer = false,
        })
      end, { desc = '[/] Fuzzily search in current buffer' })

      vim.keymap.set('n', '<leader>gf', builtin.git_files, { desc = 'Search [G]it [F]iles' })
      vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = '[F]ind [F]iles' })
      vim.keymap.set('n', '<leader>fn', builtin.find_files, { desc = '[F]ind [N]eovim config files' })
      vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = '[F]ind [H]elp' })
      vim.keymap.set('n', '<leader>fw', builtin.grep_string, { desc = '[F]ind current [W]ord' })
      vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = '[F]ind by [G]rep' })
      vim.keymap.set('n', '<leader>fd', builtin.diagnostics, { desc = '[F]ind [D]iagnostics' })
      vim.keymap.set('n', '<leader>fr', builtin.resume, { desc = '[F]ind [R]esume' })
      vim.keymap.set('n', '<leader>en', function()
          builtin.find_files { cwd = vim.fn.stdpath("config") }
      end, { desc = '[E]dit [N]eovim config' })
    end,
  },

  { -- LSP Configuration & Plugins
    'neovim/nvim-lspconfig',
    dependencies = {
      'williamboman/mason.nvim',
      'williamboman/mason-lspconfig.nvim',
      { 'j-hui/fidget.nvim', tag = 'legacy', opts = {} },
      'folke/neodev.nvim',
      'folke/lsp-colors.nvim', -- Custom add
      -- 'lspcontainers/lspcontainers.nvim', -- Custom add
    },
    config = function()
      local on_attach = function(_, bufnr)
        local nmap = function(keys, func, desc)
          if desc then
            desc = 'LSP: ' .. desc
          end
          vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
        end

        nmap('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
        nmap('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')
        nmap('gd', vim.lsp.buf.definition, '[G]oto [D]efinition')
        nmap('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
        nmap('gI', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')
        nmap('<leader>D', vim.lsp.buf.type_definition, 'Type [D]efinition')
        nmap('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
        nmap('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')
        nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
        nmap('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation')
        nmap('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
        nmap('<leader>wa', vim.lsp.buf.add_workspace_folder, '[W]orkspace [A]dd Folder')
        nmap('<leader>wr', vim.lsp.buf.remove_workspace_folder, '[W]orkspace [R]emove Folder')
        nmap('<leader>wl', function()
          print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
        end, '[W]orkspace [L]ist Folders')

        vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
          vim.lsp.buf.format()
        end, { desc = 'Format current buffer with LSP' })
      end

      require('mason').setup()
      require('neodev').setup()

      local capabilities = require('cmp_nvim_lsp').default_capabilities()

      local servers = {
        lua_ls = {
          settings = {
            Lua = {
              workspace = { checkThirdParty = false },
              telemetry = { enable = false },
            },
          },
        },
        pylsp = {},
      }

      require('mason-lspconfig').setup {
        ensure_installed = vim.tbl_keys(servers),
        handlers = {
          function(server_name)
            require('lspconfig')[server_name].setup {
              capabilities = capabilities,
              on_attach = on_attach,
              settings = servers[server_name],
            }
          end,
        }
      }

    end,
  },

  { -- Autocompletion
    'hrsh7th/nvim-cmp',
    dependencies = {
      'L3MON4D3/LuaSnip',
      'saadparwaiz1/cmp_luasnip',
      'hrsh7th/cmp-nvim-lsp',
      'rafamadriz/friendly-snippets',
    },
    config = function ()
        local cmp = require 'cmp'
        local luasnip = require 'luasnip'
        require('luasnip.loaders.from_vscode').lazy_load()
        luasnip.config.setup {}

        cmp.setup {
            snippet = {
                expand = function(args)
                    luasnip.lsp_expand(args.body)
                end,
            },
            mapping = cmp.mapping.preset.insert {
                ['<C-n>'] = cmp.mapping.select_next_item(),
                ['<C-p>'] = cmp.mapping.select_prev_item(),
                ['<C-d>'] = cmp.mapping.scroll_docs(-4),
                ['<C-f>'] = cmp.mapping.scroll_docs(4),
                ['<C-Space>'] = cmp.mapping.complete {},
                ['<CR>'] = cmp.mapping.confirm {
                    behavior = cmp.ConfirmBehavior.Replace,
                    select = true,
                },
                ['<Tab>'] = cmp.mapping(function(fallback)
                    if cmp.visible() then
                        cmp.select_next_item()
                    elseif luasnip.expand_or_locally_jumpable() then
                        luasnip.expand_or_jump()
                    else
                        fallback()
                    end
                end, { 'i', 's' }),
                ['<S-Tab>'] = cmp.mapping(function(fallback)
                    if cmp.visible() then
                        cmp.select_prev_item()
                    elseif luasnip.locally_jumpable(-1) then
                        luasnip.jump(-1)
                    else
                        fallback()
                    end
                end, { 'i', 's' }),
            },
            sources = {
                { name = 'nvim_lsp' },
                { name = 'luasnip' },
            },
        }

        -- Custom Python Snippets
        local s  = luasnip.snippet
        local t  = luasnip.text_node
        local i  = luasnip.insert_node
        local rep   = require("luasnip.extras").rep

        luasnip.add_snippets("python", {
          s("impnp",  { t({"import numpy as np", ""}) }),
          s("imppd",  { t({"import pandas as pd", ""}) }),
          s("impplt", { t({"import matplotlib.pyplot as plt", ""}) }),
          s("impwb",  { t({"import wandb", ""}) }),
          s("impgeom", { t({"import torch_geometric", ""}) }),
          s("impto", {
            t({"import torch", "import torch.nn.functional as F",
              "import torch.nn as nn", "import pytorch_lightning as pl", ""})
          }),
          s("impcfg", {
            t({"from omegaconf import OmegaConf", "import dvc", ""})
          }),
          s("mkmain", {
            t("def "), i(1, "FUNC"), t("():"),
            t({"", "    pass", "", "if __name__ == \"__main__\":"}),
            t({"", "    "}), rep(1), t("()"),
          }),
          s("mkclass", {
            t("class "), i(1, "NAME"), t("("), i(2, "SUPER"), t({"):",
              "    def __init__(self):", "         super().__init__()", ""}),
          }),
        })
    end,
  },

  { -- Statusline
    'nvim-lualine/lualine.nvim',
    opts = {
      options = {
        icons_enabled = vim.g.have_nerd_font,
        theme = 'onedark',
        component_separators = '|',
        section_separators = '',
      },
    },
  },

  { -- Indent guides
    'lukas-reineke/indent-blankline.nvim',
    main = 'ibl',
    opts = {},
  },

  { -- Commenting
    'numToStr/Comment.nvim',
    opts = {
      toggler = {
        line = '<C-_>',
      },
      opleader = {
        line = '<C-_>',
      },
      mappings = {
        basic = true,
        extra = true,
        extended = false,
      },
    },
  },

  { -- Treesitter
    'nvim-treesitter/nvim-treesitter',
    dependencies = { 'nvim-treesitter/nvim-treesitter-textobjects' },
    build = ':TSUpdate',
    config = function()
        require('nvim-treesitter.configs').setup {
            ensure_installed = { 'c', 'cpp', 'go', 'lua', 'python', 'rust', 'tsx', 'javascript', 'typescript', 'vimdoc', 'vim' },
            auto_install = false,
            highlight = { enable = true },
            indent = { enable = true },
            incremental_selection = {
                enable = true,
                keymaps = {
                    init_selection = '<c-space>',
                    node_incremental = '<c-space>',
                    scope_incremental = '<c-s>',
                    node_decremental = '<M-space>',
                },
            },
            textobjects = {
                select = {
                    enable = true,
                    lookahead = true,
                    keymaps = {
                        ['aa'] = '@parameter.outer',
                        ['ia'] = '@parameter.inner',
                        ['af'] = '@function.outer',
                        ['if'] = '@function.inner',
                        ['ac'] = '@class.outer',
                        ['ic'] = '@class.inner',
                    },
                },
                move = {
                    enable = true,
                    set_jumps = true,
                    goto_next_start = { [']m'] = '@function.outer', [']]'] = '@class.outer' },
                    goto_next_end = { [']M'] = '@function.outer', [']['] = '@class.outer' },
                    goto_previous_start = { ['[m'] = '@function.outer', ['[['] = '@class.outer' },
                    goto_previous_end = { ['[M'] = '@function.outer', ['[]'] = '@class.outer' },
                },
            },
        }
    end,
  },

  -- Custom Plugins from old init.lua
  {
    "kylechui/nvim-surround",
    version = "*",
    event = "VeryLazy",
    config = function()
      require("nvim-surround").setup({
        keymaps = {
          normal = "s",
          normal_cur = "ss",
          normal_line = "S",
          normal_cur_line = "SS",
        }
      })
    end
  },

  {
    "nvim-tree/nvim-tree.lua",
    version = "*",
    lazy = false,
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      local function on_attach(bufnr)
        local api = require('nvim-tree.api')
        api.config.mappings.default_on_attach(bufnr)
        vim.keymap.del('n', '<C-e>', { buffer = bufnr })
      end
      require("nvim-tree").setup { on_attach = on_attach }
      vim.keymap.set('n', '<C-e>', function()
        if vim.bo.filetype == 'NvimTree' then
          vim.cmd('wincmd p')
          vim.cmd('NvimTreeClose')
        else
          vim.cmd('NvimTreeToggle')
        end
      end, { silent = true, desc = "Toggle NvimTree" })
      vim.keymap.set('n', '<leader>ee', '<cmd>NvimTreeToggle<CR>', { desc = "tre[e] toggl[e]", silent = true })
      vim.keymap.set('n', '<leader>ex', '<cmd>NvimTreeClose<CR>', { desc = "tre[e] e[x]it", silent = true })
      vim.keymap.set('n', '<leader>ef', '<cmd>NvimTreeFindFileToggle<CR>', { desc = "tre[e] [f]ind file", silent = true })
      vim.keymap.set('n', '<leader>ec', '<cmd>NvimTreeCollapse<CR>', { desc = "tre[e] [c]ollapse", silent = true })
      vim.keymap.set('n', '<leader>er', '<cmd>NvimTreeRefresh<CR>', { desc = "tre[e] refr", silent = true })
    end,
  },

  {
    'ggandor/leap.nvim',
    config = function()
      require('leap').setup({})
      vim.keymap.set({'n', 'x', 'o'}, 'j',  '<Plug>(leap-forward)', { remap = true ,  desc = '[J]ump forward' } )
      vim.keymap.set({'n', 'x', 'o'}, 'J',  '<Plug>(leap-backward)', { remap = true ,  desc = '[J]ump backward' } )
      vim.keymap.set({'n', 'x', 'o'}, 'gj', '<Plug>(leap-from-window)', { remap = true ,  desc = 'window [J]ump?' } )
    end
  },

  {
    "folke/trouble.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {},
    config = function(_, opts)
        require("trouble").setup(opts)
        vim.keymap.set("n", "<leader>tt", function() require("trouble").toggle() end, { desc = '[T]rouble toggle' })
        vim.keymap.set("n", "<leader>tw", function() require("trouble").toggle("workspace_diagnostics") end, { desc = '[T]rouble [W]orkspace' })
        vim.keymap.set("n", "<leader>td", function() require("trouble").toggle("document_diagnostics") end, { desc = '[T]rouble [D]ocument' })
        vim.keymap.set("n", "<leader>tq", function() require("trouble").toggle("quickfix") end, { desc = '[T]rouble [Q]uickfix' })
        vim.keymap.set("n", "<leader>tl", function() require("trouble").toggle("loclist") end, { desc = '[T]rouble [L]oclist' })
        vim.keymap.set("n", "<leader>tr", function() require("trouble").toggle("lsp_references") end, { desc = '[T]rouble [R]eferences' })
    end
  },

  {
    "numToStr/Navigator.nvim",
    config = function()
      require('Navigator').setup()
      vim.keymap.set({'n', 't'}, '<leader>k', '<cmd>NavigatorLeft<CR>', { desc = "Navigator Left", silent = true })
      vim.keymap.set({'n', 't'}, '<leader>l', '<cmd>NavigatorRight<CR>', { desc = "Navigator Right", silent = true })
      vim.keymap.set({'n', 't'}, '<leader>h', '<cmd>NavigatorUp<CR>', { desc = "Navigator Up", silent = true })
      -- Note: <leader>t is remapped for window navigation, so this is different
      vim.keymap.set({'n', 't'}, '<leader>tn', '<cmd>NavigatorDown<CR>', { desc = "Navigator Down", silent = true })
      vim.keymap.set({'n', 't'}, '<leader>p', '<cmd>NavigatorPrevious<CR>', { desc = "Navigator Previous", silent = true })
    end,
  },
  
  -- null-ls for formatting, can be replaced by conform.nvim but keeping for reference
  -- {
  --     'jose-elias-alvarez/null-ls.nvim',
  --     dependencies = { 'nvim-lua/plenary.nvim' },
  --     config = function()
  --         require("null-ls").setup({
  --             sources = {
  --                 require("null-ls").builtins.formatting.isort,
  --                 require("null-ls").builtins.formatting.autopep8.with({
  --                     extra_args = { "--max-line-length", "79" },
  --                 }),
  --             },
  --             on_attach = function(client, bufnr)
  --                 if client.supports_method("textDocument/formatting") then
  --                     vim.api.nvim_create_autocmd("BufWritePre", {
  --                         group = vim.api.nvim_create_augroup("FormatOnSave", { clear = true }),
  --                         buffer = bufnr,
  --                         callback = function()
  --                             vim.lsp.buf.format({ async = true, timeout_ms = 2000 })
  --                         end,
  --                     })
  --                 end
  --             end,
  --         })
  --     end,
  -- },

}, {
  ui = {
    icons = vim.g.have_nerd_font and {} or {
      cmd = '⌘', config = '🛠', event = '📅', ft = '📂', init = '⚙',
      keys = '🗝', plugin = '🔌', runtime = '💻', require = '🌙',
      source = '📄', start = '🚀', task = '📌', lazy = '💤 ',
    },
  },
})

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et

