-- 基本設定
vim.g.mapleader = ","
vim.o.encoding = "utf-8"
vim.o.fileencoding = "utf-8"
vim.o.backup = false
vim.o.swapfile = false
vim.o.autoread = true
vim.o.hidden = true
vim.o.showcmd = true
vim.o.endofline = false

-- スペルチェック
vim.o.spell = true
vim.o.spelllang = "en,cjk"
vim.o.spellfile = vim.fn.expand("~/.config/nvim/spell/en.utf-8.add")

-- 見た目
vim.o.number = true
vim.o.cursorline = true
vim.o.virtualedit = "onemore"
vim.o.smartindent = true
vim.o.visualbell = true
vim.o.showmatch = true
vim.o.laststatus = 2
vim.o.wildmode = "list:longest"

-- タブ設定
vim.o.list = true
vim.o.listchars = "tab:>-"
vim.o.expandtab = true
vim.o.tabstop = 2
vim.o.shiftwidth = 2

-- 検索設定
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.incsearch = true
vim.o.wrapscan = true
vim.o.hlsearch = true

-- クリップボード共有
vim.o.clipboard = "unnamed"

-- 色設定
vim.o.background = "dark"
vim.o.termguicolors = true

-- キーマッピング
vim.keymap.set('n', 'j', 'gj', { noremap = true })
vim.keymap.set('n', 'k', 'gk', { noremap = true })
vim.keymap.set('n', '<Esc><Esc>', ':nohlsearch<CR><Esc>', { noremap = true })
vim.keymap.set('i', 'jj', '<Esc>', { noremap = true, silent = true })
vim.keymap.set('n', 's', '<Nop>', { noremap = true })
vim.keymap.set('n', 'O', ':<C-u>call append(expand("."), "")<Cr>j', { noremap = true })

-- 保存時の自動整形
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*",
  callback = function()
    local cursor = vim.fn.getpos(".")
    -- 空白のみの行の空白を削除
    vim.cmd([[%s/^\s\+$//ge]])
    -- 行末の空白を削除
    vim.cmd([[%s/\s\+$//ge]])
    -- タブを 4 スペースに変換
    vim.cmd([[%s/\t/    /ge]])
    vim.fn.setpos(".", cursor)
  end,
})

-- 非アクティブ時の背景色変更
vim.api.nvim_create_autocmd({ "WinEnter", "FocusGained" }, {
  pattern = "*",
  callback = function()
    vim.cmd("highlight Normal guibg=default")
  end,
})

vim.api.nvim_create_autocmd({ "WinLeave", "FocusLost" }, {
  pattern = "*",
  callback = function()
    vim.cmd("highlight Normal guibg=#27292d")
    vim.cmd("highlight NormalNC guibg=#27292d")
  end,
})

-- lazy.nvim のセットアップ
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- プラグインの設定
require("lazy").setup({
  -- カラースキーム
  {
    "fneu/breezy",
    priority = 1000,
    config = function()
      vim.cmd("colorscheme breezy")
    end,
  },

  -- 基本的な操作拡張
  { "tpope/vim-surround" },
  { "tpope/vim-repeat" },
  { "tpope/vim-commentary" },

  -- 移動系
  {
    "easymotion/vim-easymotion",
    config = function()
      vim.g.EasyMotion_smartcase = 1
      vim.keymap.set('n', 's', '<Plug>(easymotion-s2)', {})
    end,
  },

  -- ファイルツリー
  {
    "preservim/nerdtree",
    config = function()
      vim.keymap.set('n', '<C-e>', ':NERDTreeToggle<CR>', { noremap = true, silent = true })
      -- ディレクトリを開いたときに自動的にツリーを開く
      vim.cmd([[
        autocmd StdinReadPre * let s:std_in=1
        autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists("s:std_in") | exe 'NERDTree' argv()[0] | wincmd p | ene | exe 'cd '.argv()[0] | endif
        autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
      ]])
    end,
  },

  -- ハイライト
  {
    "machakann/vim-highlightedyank",
    config = function()
      vim.g.highlightedyank_highlight_duration = 150
    end,
  },

  -- バッファ管理
  {
    "ap/vim-buftabline",
    config = function()
      vim.keymap.set('n', '<C-N>', ':bnext<CR>', { noremap = true })
      vim.keymap.set('n', '<C-P>', ':bprev<CR>', { noremap = true })
    end,
  },

  -- マルチカーソル
  {
    "mg979/vim-visual-multi",
    config = function()
      vim.g.VM_maps = {
        ['Find Under'] = '<C-k>',
        ['Find Subword Under'] = '<C-k>',
      }
    end,
  },

  -- オペレータ拡張
  { "kana/vim-operator-user" },
  {
    "kana/vim-operator-replace",
    dependencies = { "kana/vim-operator-user" },
    config = function()
      vim.keymap.set('n', 'R', '<Plug>(operator-replace)', {})
    end,
  },

  -- ファジーファインダー
  {
    "junegunn/fzf",
    build = "./install --bin",
  },
  {
    "junegunn/fzf.vim",
    dependencies = { "junegunn/fzf" },
    config = function()
      vim.keymap.set('n', '<Leader>f', ':<C-u>Files<CR>', { noremap = true })
      vim.keymap.set('n', '<Leader>g', ':<C-u>GFiles<CR>', { noremap = true })
      vim.keymap.set('n', '<Leader>b', ':<C-u>Buffers<CR>', { noremap = true })
      vim.keymap.set('n', '<Leader>r', ':<C-u>RG<CR>', { noremap = true })
      vim.keymap.set('n', '<Leader>fg', ':GFiles<CR>', { noremap = true, silent = true })
      vim.keymap.set('n', '<Leader>fr', ':RG<CR>', { noremap = true, silent = true })

      -- RipGrep 統合
      vim.cmd([[
        function! RipgrepFzf(query, fullscreen)
          let command_fmt = 'rg --column --line-number --no-heading --color=always --smart-case -- %s || true'
          let initial_command = printf(command_fmt, shellescape(a:query))
          let reload_command = printf(command_fmt, '{q}')
          let spec = {'options': ['--phony', '--query', a:query, '--bind', 'change:reload:'.reload_command]}
          call fzf#vim#grep(initial_command, 1, fzf#vim#with_preview(spec), a:fullscreen)
        endfunction
        command! -nargs=* -bang RG call RipgrepFzf(<q-args>, <bang>0)
      ]])
    end,
  },

  -- タグ自動閉じ
  {
    "alvan/vim-closetag",
    config = function()
      vim.g.closetag_filenames = '*.html,*.xhtml,*.phtml,*.blade.php,*.tsx,*.jsx'
    end,
  },

  -- テンプレート
  {
    "mattn/sonictemplate-vim",
    config = function()
      vim.g.sonictemplate_vim_template_dir = { '~/.vim/templates' }
    end,
  },

  -- ヘルプ日本語化
  { "vim-jp/vimdoc-ja" },

  -- GitHub Copilot
  { "github/copilot.vim" },

  -- LSP 関連
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
    },
    config = function()
      -- Mason のセットアップ
      require("mason").setup({
        ui = {
          icons = {
            package_installed = "✓",
            package_pending = "➜",
            package_uninstalled = "✗"
          }
        }
      })

      require("mason-lspconfig").setup({
        ensure_installed = { "ts_ls" },
        automatic_installation = true,
      })

      -- LSP の設定
      local lspconfig = require("lspconfig")
      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      -- TypeScript/JavaScript の設定
      lspconfig.ts_ls.setup({
        capabilities = capabilities,
        on_attach = function(client, bufnr)
          -- キーマッピング
          local opts = { buffer = bufnr, noremap = true, silent = true }
          vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
          vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
          vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
          vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
          vim.keymap.set('n', '<leader>R', vim.lsp.buf.rename, opts)
          vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, opts)
          vim.keymap.set('n', '<leader>f', function()
            vim.lsp.buf.format({ async = true })
          end, opts)
          vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
          vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
          vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, opts)
        end,
      })

      -- 診断表示の設定
      vim.diagnostic.config({
        virtual_text = true,
        signs = true,
        underline = true,
        update_in_insert = false,
        severity_sort = true,
      })

      -- 診断記号の設定
      local signs = { Error = "✗", Warn = "⚠", Hint = "💡", Info = "ℹ" }
      for type, icon in pairs(signs) do
        local hl = "DiagnosticSign" .. type
        vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
      end
    end,
  },

  -- 自動補完
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
    },
    config = function()
      local cmp = require("cmp")
      local luasnip = require("luasnip")

      cmp.setup({
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ['<Tab>'] = cmp.mapping.select_next_item(),
          ['<S-Tab>'] = cmp.mapping.select_prev_item(),
          ['<C-b>'] = cmp.mapping.scroll_docs(-4),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),
          ['<C-Space>'] = cmp.mapping.complete(),
          ['<C-e>'] = cmp.mapping.abort(),
          ['<CR>'] = cmp.mapping.confirm({ select = true }),
        }),
        sources = cmp.config.sources({
          { name = 'nvim_lsp' },
          { name = 'luasnip' },
        }, {
          { name = 'buffer' },
          { name = 'path' },
        }),
        formatting = {
          format = function(entry, vim_item)
            -- 補完項目のソース表示
            vim_item.menu = ({
              nvim_lsp = "[LSP]",
              luasnip = "[Snippet]",
              buffer = "[Buffer]",
              path = "[Path]",
            })[entry.source.name]
            return vim_item
          end,
        },
      })
    end,
  },
})