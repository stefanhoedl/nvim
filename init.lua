--[[
  TODO
  - assign j key to jump, not up 
    (delete, ...) 
  - https://learnxinyminutes.com/docs/lua/
  - https://neovim.io/doc/user/lua-guide.html
]]--


-- Set <space> as the leader key
-- See `:help mapleader`
vim.o.guifont = "Source Code Pro Nerd Font:h14"
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- disable netrw at the very start of your init.lua (nvim-tree)
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Install package manager
--    https://github.com/folke/lazy.nvim
--    `:help lazy.nvim.txt` for more info
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system {
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable', -- latest stable release
    lazypath,
  }
end
vim.opt.rtp:prepend(lazypath)

-- NOTE: Here is where you install your plugins.
--  You can configure plugins using the `config` key.
--
--  You can also configure plugins after the setup call,
--    as they will be available in your neovim runtime.
require('lazy').setup({
  -- NOTE: First, some plugins that don't require any configuration

  -- Git related plugins
  'tpope/vim-fugitive',
  'tpope/vim-rhubarb',

  -- Detect tabstop and shiftwidth automatically
  'tpope/vim-sleuth',

  -- NOTE: This is where your plugins related to LSP can be installed.
  --  The configuration is done below. Search for lspconfig to find it below.
  {
    -- LSP Configuration & Plugins
    'neovim/nvim-lspconfig',
    dependencies = {
      -- Automatically install LSPs to stdpath for neovim
      'williamboman/mason.nvim',
      'williamboman/mason-lspconfig.nvim',

      -- Useful status updates for LSP
      -- NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
      { 'j-hui/fidget.nvim', tag = 'legacy', opts = {} },

      -- Additional lua configuration, makes nvim stuff amazing!
      'folke/neodev.nvim',
    },
  },

--https://github.com/lspcontainers/lspcontainers.nvim
  {
    'lspcontainers/lspcontainers.nvim'
  },

--lspconfig.gopls.setup {--on_attach = on_attach,
--capabilities = capabilities,
--cmd = lspcontainers.command('gopls', {
    --container_runtime = "podman",
    --}),
--root_dir = require'lspconfig/util'.root_pattern(".git", vim.fn.getcwd()),
  --}

  {
    -- Autocompletion
    'hrsh7th/nvim-cmp',
    dependencies = {
      -- Snippet Engine & its associated nvim-cmp source
      'L3MON4D3/LuaSnip',
      'saadparwaiz1/cmp_luasnip',

      -- Adds LSP completion capabilities
      'hrsh7th/cmp-nvim-lsp',

      -- Adds a number of user-friendly snippets
      'rafamadriz/friendly-snippets',
    },
  },

  -- Useful plugin to show you pending keybinds.
  { 'folke/which-key.nvim', opts = {} },
  {
    -- Adds git related signs to the gutter, as well as utilities for managing changes
    'lewis6991/gitsigns.nvim',
    opts = {
      -- See `:help gitsigns.txt`
      signs = {
        add = { text = '+' },
        change = { text = '~' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
      },
      on_attach = function(bufnr)
        vim.keymap.set('n', '<leader>hp', require('gitsigns').preview_hunk, { buffer = bufnr, desc = 'Preview git hunk' })

        -- don't override the built-in and fugitive keymaps
        local gs = package.loaded.gitsigns
        vim.keymap.set({ 'n', 'v' }, ']c', function()
          if vim.wo.diff then
            return ']c'
          end
          vim.schedule(function()
            gs.next_hunk()
          end)
          return '<Ignore>'
        end, { expr = true, buffer = bufnr, desc = 'Jump to next hunk' })
        vim.keymap.set({ 'n', 'v' }, '[c', function()
          if vim.wo.diff then
            return '[c'
          end
          vim.schedule(function()
            gs.prev_hunk()
          end)
          return '<Ignore>'
        end, { expr = true, buffer = bufnr, desc = 'Jump to previous hunk' })
      end,
    },
  },

  {
    -- Theme inspired by Atom
    'navarasu/onedark.nvim',
    priority = 1000,
    config = function()
      vim.cmd.colorscheme 'onedark'
    end,
  },

  {
    -- Set lualine as statusline
    'nvim-lualine/lualine.nvim',
    -- See `:help lualine.txt`
    opts = {
      options = {
        icons_enabled = false,
        theme = 'onedark',
        component_separators = '|',
        section_separators = '',
      },
    },
  },

  {
    -- Add indentation guides even on blank lines
    'lukas-reineke/indent-blankline.nvim',
    -- Enable `lukas-reineke/indent-blankline.nvim`
    -- See `:help indent_blankline.txt`
    main = 'ibl',
    opts = {},
  },

  -- "gc" to comment visual regions/lines
  -- { 'numToStr/Comment.nvim', opts = {
  --   toggler = {
  --       line = '<C-_>',
  --       -- block = '<C-\\>'
  --     },
  --   }
  -- },

  { 'numToStr/Comment.nvim', opts = {
            toggler = {
                line = '<C-_>',    -- This works for normal mode, now let's extend it
                -- block = '<C-\\>',  -- This should be correctly escaped
            },
            opleader = {
                line = '<C-_>',    -- Operator pending mode for line comment
                -- block = '<C-\\>',  -- Operator pending mode for block comment
            },
            mappings = {
                basic = true,      -- Enable basic mappings (gcc/gbc)
                extra = true,      -- Enable extra mappings (gcO/gco/gcA)
                extended = false,  -- Do not map g> and g< (not used often)
            },
        },
  },

  -- Fuzzy Finder (files, lsp, etc)
  {
    'nvim-telescope/telescope.nvim',
    branch = '0.1.x',
    dependencies = {
      'nvim-lua/plenary.nvim',
      -- Fuzzy Finder Algorithm which requires local dependencies to be built.
      -- Only load if `make` is available. Make sure you have the system
      -- requirements installed.
      {
        'nvim-telescope/telescope-fzf-native.nvim',
        -- NOTE: If you are having trouble with this installation,
        --       refer to the README for telescope-fzf-native for more instructions.
        build = 'make',
        cond = function()
          return vim.fn.executable 'make' == 1
        end,
      },
    },
  },

  {
    -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    dependencies = {
      'nvim-treesitter/nvim-treesitter-textobjects',
    },
    build = ':TSUpdate',
  },

  -- custom by Stefan
  {
    "kylechui/nvim-surround",
    version = "*", -- Use for stability; omit to use `main` branch for the latest features
    event = "VeryLazy",
    config = function()
      require("nvim-surround").setup({
        -- Configuration here, or leave empty to use defaults
      })
    end
  },

  {"nvim-tree/nvim-web-devicons",
    version = "*",
    lazy = false,
    config = function()
      require("nvim-web-devicons").setup {
        override = {
          zsh = {
            icon = "",
            color = "#428850",
            cterm_color = "65",
            name = "Zsh"
          }
        };
        -- globally enable different highlight colors per icon (default to true)
        -- if set to false all icons will have the default icon's color
        color_icons = true;
        -- globally enable default icons (default to false)
        -- will get overriden by `get_icons` option
        default = true;
        -- globally enable "strict" selection of icons - icon will be looked up in
        -- different tables, first by filename, and if not found by extension; this
        -- prevents cases when file doesn't have any extension but still gets some icon
        -- because its name happened to match some extension (default to false)
        strict = true;
        -- same as `override` but specifically for overrides by filename
        -- takes effect when `strict` is true
        override_by_filename = {
          [".gitignore"] = {
            icon = "",
            color = "#f1502f",
            name = "Gitignore"
          }
        };
        -- same as `override` but specifically for overrides by extension
        -- takes effect when `strict` is true
        override_by_extension = {
          ["log"] = {
            icon = "",
            color = "#81e043",
            name = "Log"
          }
        };
      }
    end,
  },

  {
    "nvim-tree/nvim-tree.lua",
    version = "*",
    lazy = false,
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    config = function()
      require("nvim-tree").setup {}
      vim.keymap.set({'n'}, '<C-e>', ':NvimTreeToggle<Enter>')
      vim.keymap.set({'n'}, '<Leader>e', ':NvimTreeFocus<Enter>')

      vim.keymap.set({'n'}, '<leader>ee', '<cmd>NvimTreeToggle<CR>')
      vim.keymap.set({'n'}, '<leader>ef', '<cmd>NvimTreeFindFileToggle<CR>')
      vim.keymap.set({'n'}, '<leader>ec', '<cmd>NvimTreeCollapse<CR>')
      vim.keymap.set({'n'}, '<leader>er', '<cmd>NvimTreeRefresh<CR>')
    end,
  },

  {'ggandor/leap.nvim',
    config = function()
      require('leap').add_default_mappings()
    end
  },

  {
    "folke/trouble.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      -- your configuration comes here
      -- or leave it empty to use the default settings
      -- refer to the configuration section below
    },
  },

  {
    'folke/lsp-colors.nvim'
  },
  -- {
  --   "aserowy/tmux.nvim",
  --   config = function()
  --     require("tmux").setup() {}
  --       navigation = {
  --         enable_default_keybindings = true,
  --       }
  --
  --   end
  -- },

  {
    "numToStr/Navigator.nvim",
    config = function()
      local ok, tmux = pcall(function()
          return require('Navigator.mux.tmux'):new()
      end)
      require('Navigator').setup {
        mux = ok and tmux or 'auto',
        auto_save = 'current',
        disable_on_zoom = false
      }

      --vim.keymap.set({'n', 't'}, '<leader>mm', '<cmd>Tmux:new()<CR>')
      vim.keymap.set({'n', 't'}, '<leader>k', '<cmd>NavigatorLeft<CR>')
      vim.keymap.set({'n', 't'}, '<leader>l', '<cmd>NavigatorRight<CR>')
      vim.keymap.set({'n', 't'}, '<leader>h', '<cmd>NavigatorUp<CR>')
      vim.keymap.set({'n', 't'}, '<leader>t', '<cmd>NavigatorDown<CR>')
      vim.keymap.set({'n', 't'}, '<leader>p', '<cmd>NavigatorPrevious<CR>')
      -- vim.keymap.set({'n', 't'}, '<A-h>', require('Navigator').left)
    end,
  },

  -- chatCPT: null-ls, autoformat on write, write on focusChange
  {
      'jose-elias-alvarez/null-ls.nvim', -- For null-ls
      requires = { 'nvim-lua/plenary.nvim' },
      config = function()
          require("null-ls").setup({
              sources = {
                  require("null-ls").builtins.formatting.black.with({ extra_args = { "--fast", "--line-length", "79"} }),
                  require("null-ls").builtins.formatting.isort,
              },
              on_attach = function(client, bufnr)
                  if client.supports_method("textDocument/formatting") then
                      vim.api.nvim_create_autocmd("BufWritePre", {
                          group = vim.api.nvim_create_augroup("FormatOnSave", { clear = true }),
                          buffer = bufnr,
                          callback = function()
                              vim.lsp.buf.format({ timeout_ms = 2000 })
                          end,
                      })
                  end
              end,
          })
      end,
  },
  -- chatCPT: lspcontainer
  -- {
  --       'lspcontainers/lspcontainers.nvim', -- For LSP in Docker
  --       config = function()
  --           require('lspconfig').pylsp.setup({
  --               cmd = require('lspcontainers').command('pylsp'),
  --               on_attach = on_attach,
  --               settings = {
  --                   pylsp = {
  --                       plugins = {
  --                           pyls_black = { enabled = true },
  --                           pyls_isort = { enabled = true }
  --                       }
  --                   }
  --               },
  --               root_dir = require('lspconfig/util').root_pattern(".git", vim.fn.getcwd()),
  --           })
  --       end,
  --   },




  -- {
  --"christoomey/vim-tmux-navigator", 
  --"alexghergh/nvim-tmux-navigation"
  -- },

-- {
--   'fannheyward/coc-pyright',
--   config = function()
--     require('coc-pyright').setup() {}
--   end,
-- },
  -- NOTE: Next Step on Your Neovim Journey: Add/Configure additional "plugins" for kickstart
  --       These are some example plugins that I've included in the kickstart repository.
  --       Uncomment any of the lines below to enable them.
  -- require 'kickstart.plugins.autoformat',
  -- require 'kickstart.plugins.debug',

  -- NOTE: The import below can automatically add your own plugins, configuration, etc from `lua/custom/plugins/*.lua`
  --    You can use this folder to prevent any conflicts with this init.lua if you're interested in keeping
  --    up-to-date with whatever is in the kickstart repo.
  --    Uncomment the following line and add your plugins to `lua/custom/plugins/*.lua` to get going.
  --
  --    For additional information see: https://github.com/folke/lazy.nvim#-structuring-your-plugins
  -- { import = 'custom.plugins' },
}, {})


-- [Stefan WriteOnFocusChange]
vim.api.nvim_create_autocmd("FocusLost", {
    pattern = '*',
    command = 'wa'
})

-- vim.keymap.set('n', '<^_>', '<leader>gcc', { desc = 'Toggle comment for the current line' })
-- vim.keymap.set('x', '<^_>', '<leader>gc', { desc = 'Toggle comment for the selected lines' })
-- vim.keymap.set('o', '<^_>', '<leader>gc', { desc = 'Toggle comment for motion' })

-- [[ Setting options ]]
-- See `:help vim.o`
-- NOTE: You can change these options as you wish!

-- Set highlight on search
vim.o.hlsearch = false

-- Make line numbers default
vim.wo.number = true

-- Enable mouse mode
vim.o.mouse = 'a'

-- Sync clipboard between OS and Neovim.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
vim.o.clipboard = 'unnamedplus'

-- Enable break indent
vim.o.breakindent = true

-- Save undo history
vim.o.undofile = true

-- Case-insensitive searching UNLESS \C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

-- Keep signcolumn on by default
vim.wo.signcolumn = 'yes'

-- Decrease update time
vim.o.updatetime = 250
vim.o.timeoutlen = 300

-- Set completeopt to have a better completion experience
vim.o.completeopt = 'menuone,noselect'

-- NOTE: You should make sure your terminal supports this
vim.o.termguicolors = true

vim.opt.relativenumber = true

-- [[ Basic Keymaps ]]
vim.go.background = "dark"

-- [[ Workman Remap Stefan ]]

vim.keymap.set({'n', 'v'}, 'y', 'z', { noremap = true })
vim.keymap.set({'n', 'v'}, 'z', 'y', { noremap = true })
vim.keymap.set({'n', 'v'}, 'yy', 'zz', { noremap = true })
vim.keymap.set({'n', 'v'}, 'zz', 'yy', { noremap = true })
vim.keymap.set({'n', 'v'}, 'j', 't', { noremap = true, desc = '[J]ump to'})
vim.keymap.set({'n', 'v'}, 't', 'j', { noremap = true })
vim.keymap.set({'n', 'v'}, 'h', 'k', { noremap = true })
vim.keymap.set({'n', 'v'}, 'k', 'h', { noremap = true })

vim.keymap.set({'n', 'v'}, 'Y', 'Z', { noremap = true })
vim.keymap.set({'n', 'v'}, 'Z', 'Y', { noremap = true })
vim.keymap.set({'n', 'v'}, 'J', 'T', { noremap = true })
vim.keymap.set({'n', 'v'}, 'T', 'J', { noremap = true })
vim.keymap.set({'n', 'v'}, 'H', 'K', { noremap = true })
vim.keymap.set({'n', 'v'}, 'K', 'H', { noremap = true })

-- map tab switches:
--vim.keymap.set({'n'}, "<C-w>h", 
--vim.keymap.set({'n'}, "<leader>w", 
vim.keymap.set({'n'}, '<leader>1', '1gt')
vim.keymap.set({'n'}, '<leader>2', '2gt')
vim.keymap.set({'n'}, '<leader>3', '3gt')
vim.keymap.set({'n'}, '<leader>4', '4gt')
vim.keymap.set({'n'}, '<leader>5', '5gt')
vim.keymap.set({'n'}, '<leader>6', '6gt')
vim.keymap.set({'n'}, '<leader>7', '7gt')
vim.keymap.set({'n'}, '<leader>8', '8gt')
vim.keymap.set({'n'}, '<leader>9', '9gt')
vim.keymap.set({'n'}, '<leader>0', ':tablast<CR>')
--remap <leader>0 :tablast<cr>

-- [[ window nav remap ]]
-- https://neovim.io/doc/user/quickref.html#Q_wi
vim.keymap.set({'n'}, '<Leader>h', '<C-w>k')
vim.keymap.set({'n'}, '<Leader>t', '<C-w>j')
vim.keymap.set({'n'}, '<Leader>k', '<C-w>h')
vim.keymap.set({'n'}, '<Leader>l', '<C-w>l')
vim.keymap.set({'n'}, '<Leader>b', '<C-w>b')
vim.keymap.set({'n'}, '<Leader>j', '<C-w>t', {desc = '[J]ump to'})

vim.keymap.set({'n'}, '<C-w>h', '<C-w>k')
vim.keymap.set({'n'}, '<C-w>t', '<C-w>j')
vim.keymap.set({'n'}, '<C-w>k', '<C-w>h')
vim.keymap.set({'n'}, '<C-w>l', '<C-w>l')
vim.keymap.set({'n'}, '<C-w>b', '<C-w>b')
vim.keymap.set({'n'}, '<C-w>j', '<C-w>t')

-- [[Stefan WIP]]
--vim.keymap.set({'n'}, 't', 'j') --'[J]ump to'
--vim.keymap.set({'n'}, 'j', 't') --'[J]ump to'

--vim.keymap.set({'n'}, '<C-w>k', '<C-w>h')
--vim.keymap.set({'n'}, '<C-w>j', '<C-w>t')
--vim.keymap.set({'n'}, '<C-w>h', '<C-w>k')
--vim.keymap.set({'n'}, '<C-w>l', '<C-w>l')
--vim.keymap.set({'n'}, '<C-w>b', '<C-w>b')
--vim.keymap.set({'n'}, '<C-w>t', '<C-w>j')


-- Keymaps for better default experience
-- See `:help vim.keymap.set()`
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- attempt to make comment.nvim work with CTRL+/
-- vim.keymap.set({ 'n', 'v' }, '<C-/>', '<leader>gcc', { silent = true })
-- vim.keymap.set({ 'n', 'v' }, '<leader>/', '<leader>gcc', { silent = true })

-- Remap for dealing with word wrap
vim.keymap.set('n', 'h', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 't', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- Trouble keymaps
vim.keymap.set("n", "<leader>tt", function()
    require("trouble").toggle() end, { desc = '[T]rouble toggle' })
vim.keymap.set("n", "<leader>tw", function()
    require("trouble").toggle("workspace_diagnostics") end, { desc = '[T]rouble [W]orkspace' })
vim.keymap.set("n", "<leader>td", function()
    require("trouble").toggle("document_diagnostics") end, { desc = '[T]rouble [D]ocument' })
vim.keymap.set("n", "<leader>tq", function()
    require("trouble").toggle("quickfix") end, { desc = '[T]rouble [Q]uickfix' })
vim.keymap.set("n", "<leader>tl", function()
    require("trouble").toggle("loclist") end, { desc = '[T]rouble [L]oclist' })
vim.keymap.set("n", "<leader>tr", function()
    require("trouble").toggle("lsp_references") end, { desc = '[T]rouble references' })


-- Command to toggle inline diagnostics
-- vim.diagnostic.disable()
-- vim.diagnostic.config({virtual_text = false})
vim.api.nvim_create_user_command(
  'ToggleDiag',
  function()
    -- local current_value = vim.diagnostic.config().virtual_text
    local current_value = vim.diagnostic.is_disabled()
    if current_value then
      vim.diagnostic.config({virtual_text = true})
      vim.diagnostic.enable()
    else
      vim.diagnostic.config({virtual_text = false})
      vim.diagnostic.disable()
    end
  end,
  {}
)
vim.keymap.set('n', '<leader>tv', ':ToggleDiag<Enter>', { desc = '[T]oggle [V]irtualText' })
--vim.keymap.set('n', '<leader>tv', function() vim.api.ToggleDiag end, { desc = '[T]oggle [V]irtualText' })


-- [[ Highlight on yank ]]
-- See `:help vim.highlight.on_yank()`
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = '*',
})

-- [[ Configure Telescope ]]
-- See `:help telescope` and `:help telescope.setup()`
require('telescope').setup {
  defaults = {
    mappings = {
      i = {
        ['<C-u>'] = false,
        ['<C-d>'] = false,
      },
    },
  },
}

-- Enable telescope fzf native, if installed
pcall(require('telescope').load_extension, 'fzf')

-- See `:help telescope.builtin`
vim.keymap.set('n', '<leader>?', require('telescope.builtin').oldfiles, { desc = '[?] Find recently opened files' })
vim.keymap.set('n', '<leader><space>', require('telescope.builtin').buffers, { desc = '[ ] Find existing buffers' })
vim.keymap.set('n', '<leader>/', function()
  -- You can pass additional configuration to telescope to change theme, layout, etc.
  require('telescope.builtin').current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
    winblend = 10,
    previewer = false,
  })
end, { desc = '[/] Fuzzily search in current buffer' })

vim.keymap.set('n', '<leader>gf', require('telescope.builtin').git_files, { desc = 'Search [G]it [F]iles' })
vim.keymap.set('n', '<leader>sf', require('telescope.builtin').find_files, { desc = '[S]earch [F]iles' })
vim.keymap.set('n', '<leader>sh', require('telescope.builtin').help_tags, { desc = '[S]earch [H]elp' })
vim.keymap.set('n', '<leader>sw', require('telescope.builtin').grep_string, { desc = '[S]earch current [W]ord' })
vim.keymap.set('n', '<leader>sg', require('telescope.builtin').live_grep, { desc = '[S]earch by [G]rep' })
vim.keymap.set('n', '<leader>sd', require('telescope.builtin').diagnostics, { desc = '[S]earch [D]iagnostics' })
vim.keymap.set('n', '<leader>sr', require('telescope.builtin').resume, { desc = '[S]earch [R]esume' })

-- [[ Configure Treesitter ]]
-- See `:help nvim-treesitter`
-- Defer Treesitter setup after first render to improve startup time of 'nvim {filename}'
vim.defer_fn(function()
  require('nvim-treesitter.configs').setup {
    -- Add languages to be installed here that you want installed for treesitter
    ensure_installed = { 'c', 'cpp', 'go', 'lua', 'python', 'rust', 'tsx', 'javascript', 'typescript', 'vimdoc', 'vim' },

    -- Autoinstall languages that are not installed. Defaults to false (but you can change for yourself!)
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
        lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
        keymaps = {
          -- You can use the capture groups defined in textobjects.scm
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
        set_jumps = true, -- whether to set jumps in the jumplist
        goto_next_start = {
          [']m'] = '@function.outer',
          [']]'] = '@class.outer',
        },
        goto_next_end = {
          [']M'] = '@function.outer',
          [']['] = '@class.outer',
        },
        goto_previous_start = {
          ['[m'] = '@function.outer',
          ['[['] = '@class.outer',
        },
        goto_previous_end = {
          ['[M'] = '@function.outer',
          ['[]'] = '@class.outer',
        },
      },
      swap = {
        enable = false,
        swap_next = {
          ['<leader>a'] = '@parameter.inner',
        },
        swap_previous = {
          ['<leader>A'] = '@parameter.inner',
        },
      },
    },
  }
end, 0)

-- Diagnostic keymaps
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous diagnostic message' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next diagnostic message' })
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Open floating diagnostic message' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostics list' })

-- [[ Configure LSP ]]
--  This function gets run when an LSP connects to a particular buffer.
local on_attach = function(_, bufnr)
  -- NOTE: Remember that lua is a real programming language, and as such it is possible
  -- to define small helper and utility functions so you don't have to repeat yourself
  -- many times.
  --
  -- In this case, we create a function that lets us more easily define mappings specific
  -- for LSP related items. It sets the mode, buffer and description for us each time.
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

  -- See `:help K` for why this keymap
  nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
  nmap('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation')

  -- Lesser used LSP functionality
  nmap('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
  nmap('<leader>wa', vim.lsp.buf.add_workspace_folder, '[W]orkspace [A]dd Folder')
  nmap('<leader>wr', vim.lsp.buf.remove_workspace_folder, '[W]orkspace [R]emove Folder')
  nmap('<leader>wl', function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, '[W]orkspace [L]ist Folders')

  -- Create a command `:Format` local to the LSP buffer
  vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
    vim.lsp.buf.format()
  end, { desc = 'Format current buffer with LSP' })
end

-- document existing key chains
require('which-key').register {
  ['<leader>c'] = { name = '[C]ode', _ = 'which_key_ignore' },
  ['<leader>d'] = { name = '[D]ocument', _ = 'which_key_ignore' },
  ['<leader>g'] = { name = '[G]it', _ = 'which_key_ignore' },
  ['<leader>j'] = { name = 'More git', _ = 'which_key_ignore' },
  --['<leader>h'] = { name = 'More git', _ = 'which_key_ignore' },
  ['<leader>r'] = { name = '[R]ename', _ = 'which_key_ignore' },
  ['<leader>s'] = { name = '[S]earch', _ = 'which_key_ignore' },
  ['<leader>w'] = { name = '[W]orkspace', _ = 'which_key_ignore' },
}


-- chatGPT contrib: formatOnWrite, fix formatting,  --
-- local null_ls = require("null-ls")
-- local lspconfig = require('lspconfig')
--
-- -- Auto-format using null-ls
-- null_ls.setup({
--     sources = {
--         null_ls.builtins.formatting.black.with({ extra_args = { "--fast" } }),
--         null_ls.builtins.formatting.isort,
--     },
--     on_attach = function(client, bufnr)
--         if client.supports_method("textDocument/formatting") then
--             vim.api.nvim_create_autocmd("BufWritePre", {
--                 group = vim.api.nvim_create_augroup("FormatOnSave", { clear = true }),
--                 buffer = bufnr,
--                 callback = function()
--                     vim.lsp.buf.format({ timeout_ms = 2000 })
--                 end,
--             })
--         end
--     end,
-- })
--
-- -- Setup LSP with lspcontainers
-- lspconfig.pylsp.setup({
--     cmd = require('lspcontainers').command('pylsp'),
--     on_attach = on_attach,
--     settings = {
--         pylsp = {
--             plugins = {
--                 pyls_black = { enabled = true },
--                 pyls_isort = { enabled = true }
--             }
--         }
--     },
--     root_dir = require('lspconfig/util').root_pattern(".git", vim.fn.getcwd()),
-- })
--
-- -- Save all buffers on focus lost
-- vim.api.nvim_create_autocmd("FocusLost", {
--     pattern = '*',
--     command = 'wa'
-- })
--


-- mason-lspconfig requires that these setup functions are called in this order
-- before setting up the servers.
require('mason').setup()
require('mason-lspconfig').setup()

-- Enable the following language servers
--  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
--
--  Add any additional override configuration in the following tables. They will be passed to
--  the `settings` field of the server config. You must look up that documentation yourself.
--
--  If you want to override the default filetypes that your language server will attach to you can
--  define the property 'filetypes' to the map in question.
local servers = {
  -- clangd = {},
  -- gopls = {},
  -- pyright = {},
	-- pyre = {},
--
--   pylsp = {
--     cmd = {"pylsp"},
--     -- cmd = {require'lspcontainers'.command('pylsp')},
--     settings = {
--         pylsp = {
--             configurationSources = {"flake8"},
--             plugins = {
--                 flake8 = {
--                     enabled = true,
--                     maxLineLength = 120,
--                 },
--             },
--         },
--     },
--     root_dir = require'lspconfig'.util.root_pattern(".git", "setup.py",  "setup.cfg", "pyproject.toml", "requirements.txt"),
--     on_attach = on_attach,
--     -- filetypes = {"python"},
--     -- Add your Docker container's IP and the LSP server port here:
--     cmd_cwd = "172.17.0.2:2087",
-- },

  pylsp = {},

  -- pyproject-flake = {},
  -- rust_analyzer = {},
  -- tsserver = {},
  -- html = { filetypes = { 'html', 'twig', 'hbs'} },

  lua_ls = {
    Lua = {
      workspace = { checkThirdParty = false },
      telemetry = { enable = false },
    },
  },
}

-- Setup neovim lua configuration
require('neodev').setup()

-- nvim-cmp supports additional completion capabilities, so broadcast that to servers
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

-- Ensure the servers above are installed
local mason_lspconfig = require 'mason-lspconfig'

mason_lspconfig.setup {
  ensure_installed = vim.tbl_keys(servers),
}

mason_lspconfig.setup_handlers {
  function(server_name)
    require('lspconfig')[server_name].setup {
      capabilities = capabilities,
      on_attach = on_attach,
      settings = servers[server_name],
      filetypes = (servers[server_name] or {}).filetypes,
    }
  end,
}



-- [[ Configure nvim-cmp ]]
-- see :LuaSnipList
-- See `:help cmp`
local cmp = require 'cmp'
local luasnip = require 'luasnip'
require('luasnip.loaders.from_vscode').lazy_load({
  exclude = {},
})
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

--------------------------------------------------------------------------------
-- Define custom LuaSnip snippets for Python
--------------------------------------------------------------------------------
local s  = luasnip.snippet
local t  = luasnip.text_node
local i  = luasnip.insert_node
local rep   = require("luasnip.extras").rep  

luasnip.add_snippets("python", {
  -- Aliases: imp <shortcut>
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

  -- mkclass: changing "SUPER" at <Tab> spot will update the second instance.
  -- s("mkclass", {
  --   t("class "), i(1, "NAME"), t("("), i(2, "SUPER"), t({"):", "    def __init__(self):", "        if "}),
  --   rep(2), t({": super().__init__()"}),
  -- }),
  --
  -- V2
  ---- mkclass with optional super:
  -- s("mkclass", {
  --   t("class "),
  --   i(1, "MyClass"),  -- Class name
  --   -- Dynamic node for the SUPER placeholder (user can type or leave empty)
  --   d(2, function()
  --     return ls.snippet(nil, { i(1, "") })
  --   end),
  --   -- Conditionally add parentheses if user typed a superclass
  --   f(function(args)
  --     local super = args[1][1] or ""
  --     if super == "" then
  --       return ""
  --     else
  --       return "(" .. super .. ")"
  --     end
  --   end, {2, 1}),
  --   t({":", "    def __init__(self):"}),
  --   -- Conditionally call super().__init__() only if SUPER not empty
  --   f(function(args)
  --     local super = args[1][1] or ""
  --     if super == "" then
  --       return "        pass"
  --     else
  --       return "        super().__init__()"
  --     end
  --   end, {2, 1}),
  --   t({"", ""}),
  --   i(0),
  -- }),
})

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2
