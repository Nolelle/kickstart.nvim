-- Set <space> as the leader key
-- See `:help mapleader`
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Set to true if you have a Nerd Font installed
vim.g.have_nerd_font = true

-- [[ Setting Options ]]
-- See `:help vim.opt`
vim.opt.number = true -- Print the line number in front of each line
vim.opt.mouse = 'a' -- Enable mouse support in all modes
vim.opt.showmode = false -- Don't show the mode, since it's in the status line
vim.opt.clipboard = 'unnamedplus' -- Sync with system clipboard
vim.opt.breakindent = true -- Enable break indent
vim.opt.undofile = true -- Save undo history
vim.opt.ignorecase = true -- Ignore case when searching
vim.opt.smartcase = true -- Don't ignore case if search pattern contains uppercase letters
vim.opt.signcolumn = 'yes' -- Always show the signcolumn, otherwise it would shift the text
vim.opt.updatetime = 250 -- Decrease update time
vim.opt.timeoutlen = 300 -- Decrease mapped sequence wait time
vim.opt.splitright = true -- Place new vertical splits to the right
vim.opt.splitbelow = true -- Place new horizontal splits below
vim.opt.list = true -- Show invisible characters (tabs, spaces, trailing spaces, etc.)
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' } -- Set characters for list option
vim.opt.inccommand = 'split' -- Preview substitutions live, as you type
vim.opt.cursorline = true -- Highlight the current line
vim.opt.scrolloff = 10 -- Keep 10 lines visible above/below the cursor when scrolling
vim.opt.confirm = true -- Ask for confirmation when closing buffers with unsaved changes
vim.opt.relativenumber = true -- Show relative line numbers

-- [[ Basic Keymaps ]]
-- See `:help vim.keymap.set()`
-- Clear search highlights
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>', { desc = 'Clear search highlights' })
-- Diagnostic keymaps
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })
-- Exit terminal mode
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })
-- Window navigation
vim.keymap.set('n', '<C-h>', '<C-w>h', { desc = 'Move focus to left window' })
vim.keymap.set('n', '<C-l>', '<C-w>l', { desc = 'Move focus to right window' })
vim.keymap.set('n', '<C-j>', '<C-w>j', { desc = 'Move focus to lower window' })
vim.keymap.set('n', '<C-k>', '<C-w>k', { desc = 'Move focus to upper window' })

-- NvimTree Keymaps (Restored)
vim.keymap.set('n', '<leader>e', '<cmd>NvimTreeToggle<CR>', { desc = 'Toggle file [E]xplorer (NvimTree)' })
vim.keymap.set('n', '<leader>o', '<cmd>NvimTreeFocus<CR>', { desc = '[O]pen file explorer focus (NvimTree)' })

-- [[ Basic Autocommands ]]
-- See `:help autocmd`
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking text',
  group = vim.api.nvim_create_augroup('highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- [[ Install `lazy.nvim` plugin manager ]]
-- See `:help lazy.nvim`
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', 'https://github.com/folke/lazy.nvim.git', lazypath }
end
vim.opt.rtp:prepend(lazypath)

-- [[ Configure Plugins ]]
require('lazy').setup {
  spec = { -- Define the list of plugins to install
    -- Detect tabstop and shiftwidth automatically
    { 'tpope/vim-sleuth' },

    -- Git integration signs in the sign column
    {
      'lewis6991/gitsigns.nvim',
      opts = {
        signs = {
          add = { text = '+' },
          change = { text = '~' },
          delete = { text = '_' },
          topdelete = { text = '‾' },
          changedelete = { text = '~' },
        },
      },
    },

    -- Keybinding hints popup
    {
      'folke/which-key.nvim',
      event = 'VeryLazy', -- Load very late
      opts = {
        delay = 0, -- Show popup immediately
        icons = { mappings = vim.g.have_nerd_font }, -- Use nerd font icons if available
        spec = {
          { '<leader>c', group = '[C]ode', mode = { 'n', 'x' } },
          { '<leader>d', group = '[D]ocument' },
          { '<leader>r', group = '[R]ename' },
          { '<leader>s', group = '[S]earch' },
          { '<leader>w', group = '[W]orkspace' },
          { '<leader>t', group = '[T]oggle' },
          { '<leader>h', group = 'Git [H]unk', mode = { 'n', 'v' } },
          { '<leader>e', group = '[E]xplorer (Tree)' }, -- Restored description
          { '<leader>o', group = '[O]pen Explorer (Tree)' }, -- Restored description
        },
      },
    },

    -- Fuzzy Finder (files, lsp, etc)
    {
      'nvim-telescope/telescope.nvim',
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
        'nvim-telescope/telescope-ui-select.nvim',
        { 'nvim-tree/nvim-web-devicons', enabled = vim.g.have_nerd_font },
      },
      config = function()
        require('telescope').setup {
          extensions = {
            ['ui-select'] = { require('telescope.themes').get_dropdown() },
          },
        }
        pcall(require('telescope').load_extension, 'fzf')
        pcall(require('telescope').load_extension, 'ui-select')
        local builtin = require 'telescope.builtin'
        vim.keymap.set('n', '<leader>sh', builtin.help_tags, { desc = '[S]earch [H]elp' })
        vim.keymap.set('n', '<leader>sk', builtin.keymaps, { desc = '[S]earch [K]eymaps' })
        vim.keymap.set('n', '<leader>sf', builtin.find_files, { desc = '[S]earch [F]iles' })
        vim.keymap.set('n', '<leader>ss', builtin.builtin, { desc = '[S]earch [S]elect Telescope' })
        vim.keymap.set('n', '<leader>sw', builtin.grep_string, { desc = '[S]earch current [W]ord' })
        vim.keymap.set('n', '<leader>sg', builtin.live_grep, { desc = '[S]earch by [G]rep' })
        vim.keymap.set('n', '<leader>sd', builtin.diagnostics, { desc = '[S]earch [D]iagnostics' })
        vim.keymap.set('n', '<leader>sr', builtin.resume, { desc = '[S]earch [R]esume' })
        vim.keymap.set('n', '<leader>s.', builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
        vim.keymap.set('n', '<leader><leader>', builtin.buffers, { desc = '[ ] Find existing buffers' })
        vim.keymap.set('n', '<leader>/', function()
          builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown { winblend = 10, previewer = false })
        end, { desc = '[/] Fuzzily search in current buffer' })
        vim.keymap.set('n', '<leader>s/', function()
          builtin.live_grep { grep_open_files = true, prompt_title = 'Live Grep in Open Files' }
        end, { desc = '[S]earch [/] in Open Files' })
        vim.keymap.set('n', '<leader>sn', function()
          builtin.find_files { cwd = vim.fn.stdpath 'config' }
        end, { desc = '[S]earch [N]eovim files' })
      end,
    },

    -- LSP framework for Neovim lua development
    { 'folke/lazydev.nvim', ft = 'lua', opts = { library = { { path = '${3rd}/luv/library', words = { 'vim%.uv' } } } } },

    -- LSP Configuration & Plugins
    {
      'neovim/nvim-lspconfig',
      dependencies = {
        { 'williamboman/mason.nvim', config = true },
        'williamboman/mason-lspconfig.nvim',
        'WhoIsSethDaniel/mason-tool-installer.nvim',
        { 'j-hui/fidget.nvim', opts = {} },
        'hrsh7th/cmp-nvim-lsp',
      },
      config = function()
        vim.api.nvim_create_autocmd('LspAttach', {
          group = vim.api.nvim_create_augroup('lsp-attach', { clear = true }),
          callback = function(event)
            local map = function(keys, func, desc, mode)
              mode = mode or 'n'
              vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
            end
            map('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')
            map('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
            map('gI', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')
            map('<leader>D', require('telescope.builtin').lsp_type_definitions, 'Type [D]efinition')
            map('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
            map('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')
            map('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
            map('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction', { 'n', 'x' })
            map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
            local client = vim.lsp.get_client_by_id(event.data.client_id)
            if client and client.server_capabilities.documentHighlightProvider then
              local highlight_augroup = vim.api.nvim_create_augroup('lsp-highlight', { clear = false })
              vim.api.nvim_create_autocmd(
                { 'CursorHold', 'CursorHoldI' },
                { buffer = event.buf, group = highlight_augroup, callback = vim.lsp.buf.document_highlight }
              )
              vim.api.nvim_create_autocmd(
                { 'CursorMoved', 'CursorMovedI' },
                { buffer = event.buf, group = highlight_augroup, callback = vim.lsp.buf.clear_references }
              )
              vim.api.nvim_create_autocmd('LspDetach', {
                group = vim.api.nvim_create_augroup('lsp-detach', { clear = true }),
                callback = function(event2)
                  vim.lsp.buf.clear_references()
                  vim.api.nvim_clear_autocmds { group = 'lsp-highlight', buffer = event2.buf }
                end,
              })
            end
            if client and client.server_capabilities.inlayHintProvider then
              map('<leader>th', function()
                vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
              end, '[T]oggle Inlay [H]ints')
            end
          end,
        })
        vim.diagnostic.config {
          severity_sort = true,
          float = { border = 'rounded', source = 'if_many' },
          underline = { severity = vim.diagnostic.severity.ERROR },
          signs = vim.g.have_nerd_font and {
            text = {
              [vim.diagnostic.severity.ERROR] = '󰅚 ',
              [vim.diagnostic.severity.WARN] = '󰀪 ',
              [vim.diagnostic.severity.INFO] = '󰋽 ',
              [vim.diagnostic.severity.HINT] = '󰌶 ',
            },
          } or {},
          virtual_text = { source = 'if_many', spacing = 2 },
        }
        local capabilities = vim.tbl_deep_extend('force', vim.lsp.protocol.make_client_capabilities(), require('cmp_nvim_lsp').default_capabilities())
        local servers = { lua_ls = { settings = { Lua = { completion = { callSnippet = 'Replace' }, diagnostics = { globals = { 'vim' } } } } } }
        require('mason').setup()
        local ensure_installed = vim.tbl_keys(servers or {})
        vim.list_extend(ensure_installed, { 'stylua' })
        require('mason-tool-installer').setup { ensure_installed = ensure_installed }
        require('mason-lspconfig').setup {
          handlers = {
            function(server_name)
              local server = servers[server_name] or {}
              server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
              require('lspconfig')[server_name].setup(server)
            end,
          },
        }
      end,
    },

    -- Formatting
    {
      'stevearc/conform.nvim',
      event = { 'BufWritePre' },
      cmd = { 'ConformInfo' },
      keys = {
        {
          '<leader>f',
          function()
            require('conform').format { async = true, lsp_format = 'fallback' }
          end,
          desc = '[F]ormat buffer',
        },
      },
      opts = {
        notify_on_error = false,
        format_on_save = function(bufnr)
          local disable_filetypes = { c = true, cpp = true }
          return { timeout_ms = 500, lsp_format = disable_filetypes[vim.bo[bufnr].filetype] and 'never' or 'fallback' }
        end,
        formatters_by_ft = { lua = { 'stylua' } },
      },
    },

    -- Autocompletion
    {
      'hrsh7th/nvim-cmp',
      event = 'InsertEnter',
      dependencies = {
        { 'L3MON4D3/LuaSnip', build = (vim.fn.executable 'make' == 1 and 'make install_jsregexp' or nil) },
        'saadparwaiz1/cmp_luasnip',
        'hrsh7th/cmp-nvim-lsp',
        'hrsh7th/cmp-path',
        'hrsh7th/cmp-nvim-lsp-signature-help',
      },
      config = function()
        local cmp = require 'cmp'
        local luasnip = require 'luasnip'
        luasnip.config.setup {}
        cmp.setup {
          snippet = {
            expand = function(args)
              luasnip.lsp_expand(args.body)
            end,
          },
          completion = { completeopt = 'menu,menuone,noinsert' },
          mapping = cmp.mapping.preset.insert {
            ['<C-n>'] = cmp.mapping.select_next_item(),
            ['<C-p>'] = cmp.mapping.select_prev_item(),
            ['<C-b>'] = cmp.mapping.scroll_docs(-4),
            ['<C-f>'] = cmp.mapping.scroll_docs(4),
            ['<C-y>'] = cmp.mapping.confirm { select = true },
            ['<C-Space>'] = cmp.mapping.complete(),
            ['<C-l>'] = cmp.mapping(function()
              if luasnip.expand_or_locally_jumpable() then
                luasnip.expand_or_jump()
              end
            end, { 'i', 's' }),
            ['<C-h>'] = cmp.mapping(function()
              if luasnip.locally_jumpable(-1) then
                luasnip.jump(-1)
              end
            end, { 'i', 's' }),
          },
          sources = {
            { name = 'lazydev', group_index = 0 },
            { name = 'nvim_lsp' },
            { name = 'luasnip' },
            { name = 'path' },
            { name = 'nvim_lsp_signature_help' },
          },
        }
      end,
    },

    -- Colorscheme
    {
      'ellisonleao/gruvbox.nvim',
      priority = 1000,
      opts = { dim_inactive = false, transparent_mode = false, styles = { comments = { italic = false } } },
      config = function(_, opts)
        require('gruvbox').setup(opts)
        vim.cmd.colorscheme 'gruvbox'
      end,
    },

    -- Highlight TODOs, FIXMEs, etc.
    {
      'folke/todo-comments.nvim',
      event = 'VimEnter',
      dependencies = { 'nvim-lua/plenary.nvim' },
      opts = { signs = false },
    },

    -- Collection of minimal useful plugins (mini.nvim)
    {
      'echasnovski/mini.nvim',
      config = function()
        -- Enable required modules here
        require('mini.ai').setup { n_lines = 500 } -- Enhanced textobjects (`a`, `i`)
        require('mini.surround').setup() -- Add/delete/change surroundings (brackets, quotes, etc.)
        require('mini.statusline').setup { use_icons = vim.g.have_nerd_font } -- Minimal statusline

        -- mini.files setup has been removed.

        -- To enable other modules, add their setup calls here, e.g.:
        -- require('mini.pairs').setup() -- Autopairs
        -- require('mini.comment').setup() -- Commenting tool
      end,
    },

    -- Treesitter Parser & Syntax Highlighting
    {
      'nvim-treesitter/nvim-treesitter',
      build = ':TSUpdate',
      config = function()
        require('nvim-treesitter.configs').setup {
          ensure_installed = { 'bash', 'c', 'diff', 'html', 'lua', 'luadoc', 'markdown', 'markdown_inline', 'query', 'vim', 'vimdoc' },
          auto_install = true,
          highlight = { enable = true, additional_vim_regex_highlighting = { 'ruby' } },
          indent = { enable = true, disable = { 'ruby' } },
        }
      end,
    },

    -- NvimTree (File Explorer - Primary)
    {
      'nvim-tree/nvim-tree.lua',
      version = '*', -- Use the latest stable release
      dependencies = {
        'nvim-tree/nvim-web-devicons', -- Dependency for icons
      },
      cmd = { 'NvimTreeToggle', 'NvimTreeOpen', 'NvimTreeFindFileToggle', 'NvimTreeFocus' }, -- Lazy-load triggers
      config = function()
        require('nvim-tree').setup {
          disable_netrw = true, -- Disable netrw
          hijack_netrw = true, -- Let nvim-tree handle netrw buffers
          diagnostics = {
            enable = true,
            icons = {
              hint = vim.g.have_nerd_font and '󰌶' or 'H',
              info = vim.g.have_nerd_font and '󰋽' or 'I',
              warning = vim.g.have_nerd_font and '󰀪' or 'W',
              error = vim.g.have_nerd_font and '󰅚' or 'E',
            },
          },
          view = {
            width = 35, -- Width of the tree window
          },
          renderer = {
            group_empty = true, -- Show empty folders
            icons = {
              glyphs = {
                default = vim.g.have_nerd_font and '󰈚' or 'F',
                symlink = vim.g.have_nerd_font and '󰌹' or '->',
                folder = {
                  arrow_closed = vim.g.have_nerd_font and '' or '>',
                  arrow_open = vim.g.have_nerd_font and '' or 'v',
                  default = vim.g.have_nerd_font and '' or 'D',
                  open = vim.g.have_nerd_font and '' or 'O',
                  empty = vim.g.have_nerd_font and '󰜌' or 'E',
                  empty_open = vim.g.have_nerd_font and '󰜌' or 'EO',
                  symlink = vim.g.have_nerd_font and '󰉒' or '->D',
                  symlink_open = vim.g.have_nerd_font and '󰉒' or '->O',
                },
                git = {
                  unstaged = vim.g.have_nerd_font and '󰄱' or '!',
                  staged = vim.g.have_nerd_font and '󰄱' or '+',
                  unmerged = vim.g.have_nerd_font and '' or 'U',
                  renamed = vim.g.have_nerd_font and '󰑕' or 'R',
                  untracked = vim.g.have_nerd_font and '󰐕' or '?',
                  deleted = vim.g.have_nerd_font and '󰍴' or '-',
                  ignored = vim.g.have_nerd_font and '◌' or '.',
                },
              },
            },
          },
        }
      end,
    },

    -- GitHub Copilot Integration
    {
      'zbirenbaum/copilot.lua',
      cmd = 'Copilot',
      event = 'InsertEnter',
      config = function()
        require('copilot').setup {
          suggestion = {
            enabled = true,
            auto_trigger = true,
            debounce = 75,
            -- *** Alternative 1 Keymap Applied Below ***
            keymap = {
              accept = '<C-;>', -- Accept suggestion (Control + Semicolon)
              accept_word = false, -- Keep disabled or map similarly if needed
              accept_line = false, -- Keep disabled or map similarly if needed
              next = '<C-j>', -- Next suggestion (Control + j) - like moving down
              prev = '<C-k>', -- Previous suggestion (Control + k) - like moving up
              dismiss = '<C-,>', -- Dismiss suggestion (Control + Comma) - near semicolon
            },
            -- *** End of Keymap Changes ***
          },
          panel = { enabled = false },
          filetypes = { ['*'] = true },
        }
      end,
    },
  }, -- End of spec table
} -- End of lazy.setup

-- vim: ts=2 sts=2 sw=2 et
