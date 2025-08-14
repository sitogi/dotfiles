-- 基本設定
vim.g.mapleader = " "
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
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      require("tokyonight").setup({
        style = "night",  -- "storm", "moon", "night", "day" から選択
        transparent = false,
        terminal_colors = true,
        styles = {
          comments = { italic = true },
          keywords = { italic = true },
        },
      })
      vim.cmd("colorscheme tokyonight")
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

  -- ファイルツリー (Neo-tree)
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",  -- アイコン表示用
      "MunifTanjim/nui.nvim",
    },
    config = function()
      require("neo-tree").setup({
        close_if_last_window = true,  -- Neo-tree が最後のウィンドウの場合は閉じる
        popup_border_style = "rounded",
        enable_git_status = true,
        enable_diagnostics = true,
        default_component_configs = {
          container = {
            enable_character_fade = true
          },
          indent = {
            indent_size = 2,
            padding = 1,
            with_markers = true,
            indent_marker = "│",
            last_indent_marker = "└",
            highlight = "NeoTreeIndentMarker",
          },
          icon = {
            folder_closed = "",
            folder_open = "",
            folder_empty = "",
            default = "*",
            highlight = "NeoTreeFileIcon"
          },
          modified = {
            symbol = "[+]",
            highlight = "NeoTreeModified",
          },
          name = {
            trailing_slash = false,
            use_git_status_colors = true,
            highlight = "NeoTreeFileName",
          },
          git_status = {
            symbols = {
              -- Change type
              added     = "",
              modified  = "",
              deleted   = "✖",
              renamed   = "",
              -- Status type
              untracked = "",
              ignored   = "",
              unstaged  = "",
              staged    = "",
              conflict  = "",
            }
          },
        },
        window = {
          position = "left",
          width = 40,  -- 30 から 40 に変更
          mapping_options = {
            noremap = true,
            nowait = true,
          },
          mappings = {
            ["<space>"] = {
              "toggle_node",
              nowait = false,
            },
            ["<2-LeftMouse>"] = "open",
            ["<cr>"] = "open",
            ["<esc>"] = "cancel",
            ["P"] = { "toggle_preview", config = { use_float = true } },
            ["l"] = "focus_preview",
            ["S"] = "open_split",
            ["s"] = "open_vsplit",
            ["t"] = "open_tabnew",
            ["w"] = "open_with_window_picker",
            ["C"] = "close_node",
            ["z"] = "close_all_nodes",
            ["a"] = {
              "add",
              config = {
                show_path = "none"  -- "none", "relative", "absolute"
              }
            },
            ["A"] = "add_directory",
            ["d"] = "delete",
            ["r"] = "rename",
            ["y"] = "copy_to_clipboard",
            ["x"] = "cut_to_clipboard",
            ["p"] = "paste_from_clipboard",
            ["c"] = "copy",
            ["m"] = "move",
            ["q"] = "close_window",
            ["R"] = "refresh",
            ["?"] = "show_help",
            ["<"] = "prev_source",
            [">"] = "next_source",
          }
        },
        filesystem = {
          filtered_items = {
            visible = false,
            hide_dotfiles = false,
            hide_gitignored = false,
            hide_hidden = false,  -- Windows 用
          },
          follow_current_file = {
            enabled = true,
            leave_dirs_open = false,
          },
          group_empty_dirs = false,
          hijack_netrw_behavior = "open_default",
          use_libuv_file_watcher = true,
        },
        buffers = {
          follow_current_file = {
            enabled = true,
            leave_dirs_open = false,
          },
          group_empty_dirs = true,
          show_unloaded = true,
        },
        git_status = {
          window = {
            position = "float",
            mappings = {
              ["A"]  = "git_add_all",
              ["gu"] = "git_unstage_file",
              ["ga"] = "git_add_file",
              ["gr"] = "git_revert_file",
              ["gc"] = "git_commit",
              ["gp"] = "git_push",
              ["gg"] = "git_commit_and_push",
            }
          }
        }
      })

      -- キーマッピング
      vim.keymap.set('n', '<C-e>', ':Neotree toggle<CR>', { noremap = true, silent = true })
      vim.keymap.set('n', '<leader>nf', ':Neotree filesystem reveal left<CR>', { noremap = true, silent = true, desc = "Neo-tree Filesystem" })
      vim.keymap.set('n', '<leader>nb', ':Neotree buffers reveal float<CR>', { noremap = true, silent = true, desc = "Neo-tree Buffers" })
      vim.keymap.set('n', '<leader>ng', ':Neotree git_status<CR>', { noremap = true, silent = true, desc = "Neo-tree Git status" })
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
      -- バッファ切り替えのキーマッピング
      -- silent を追加してコマンドラインに表示されないようにする
      vim.keymap.set('n', '<C-n>', ':bnext<CR>', { noremap = true, silent = true, desc = "Next buffer" })
      vim.keymap.set('n', '<C-p>', ':bprev<CR>', { noremap = true, silent = true, desc = "Previous buffer" })
    end,
  },

  -- マルチカーソル
  {
    "mg979/vim-visual-multi",
    init = function()
      -- プラグイン読み込み前に VM_maps を設定
      -- デフォルトの Ctrl+n はバッファ切り替え (bnext) と競合するため Ctrl+k に変更
      local t = {}
      t["Find Under"] = "<C-k>"
      t["Find Subword Under"] = "<C-k>"
      vim.g.VM_maps = t
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

  -- ウィンドウリサイズ
  {
    "simeji/winresizer",
    init = function()
      -- プラグイン読み込み前に設定する必要がある
      vim.g.winresizer_start_key = '<leader>w'
      vim.g.winresizer_vert_resize = 5
      vim.g.winresizer_horiz_resize = 5
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
          vim.keymap.set('n', '<leader>F', function()
            vim.lsp.buf.format({ async = true })
          end, opts)
          vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
          vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
          vim.keymap.set('n', '<leader>E', vim.diagnostic.open_float, opts)
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
          -- デフォルトの C-n/C-p を明示的に無効化 (バッファ切り替えに使うため)
          ['<C-n>'] = cmp.mapping(function() end, { 'i', 's' }),
          ['<C-p>'] = cmp.mapping(function() end, { 'i', 's' }),
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

  -- Telescope (高機能ファジーファインダー)
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      -- パフォーマンス向上のための fzf ネイティブ拡張
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",
      },
    },
    config = function()
      local telescope = require("telescope")
      local actions = require("telescope.actions")
      local builtin = require("telescope.builtin")

      telescope.setup({
        defaults = {
          mappings = {
            i = {
              ["<C-j>"] = actions.move_selection_next,
              ["<C-k>"] = actions.move_selection_previous,
              ["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
              ["<esc>"] = actions.close,
            },
            n = {
              ["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
            },
          },
          layout_config = {
            horizontal = {
              preview_width = 0.6,
            },
          },
          file_ignore_patterns = {
            "node_modules",
            ".git/",
            "dist/",
            "build/",
          },
        },
        pickers = {
          find_files = {
            hidden = true,
          },
          live_grep = {
            additional_args = function()
              return { "--hidden" }
            end,
          },
        },
      })

      -- fzf ネイティブ拡張を読み込み
      telescope.load_extension("fzf")

      -- キーマッピング
      -- ファイル検索系
      vim.keymap.set('n', '<leader>f', builtin.git_files, { desc = "Files (git)" })
      vim.keymap.set('n', '<leader>g', builtin.live_grep, { desc = "Grep (live grep)" })
      vim.keymap.set('n', '<leader>e', builtin.oldfiles, { desc = "rEcent files" })
      vim.keymap.set('n', '<leader>b', builtin.buffers, { desc = "Buffers" })
      vim.keymap.set('n', '<leader>h', builtin.help_tags, { desc = "Help tags" })

      -- LSP 関連 (td, tr, ts, tw, te として配置)
      vim.keymap.set('n', '<leader>td', builtin.lsp_definitions, { desc = "To Definition" })
      vim.keymap.set('n', '<leader>tr', builtin.lsp_references, { desc = "To References" })
      vim.keymap.set('n', '<leader>ts', builtin.lsp_document_symbols, { desc = "To Symbols (document)" })
      vim.keymap.set('n', '<leader>tw', builtin.lsp_workspace_symbols, { desc = "To Workspace symbols" })
      vim.keymap.set('n', '<leader>te', builtin.diagnostics, { desc = "To Errors (diagnostics)" })

      -- その他の便利機能
      vim.keymap.set('n', '<leader>m', builtin.marks, { desc = "Marks" })
      vim.keymap.set('n', '<leader>k', builtin.keymaps, { desc = "Keymaps" })
      vim.keymap.set('n', '<leader>:', builtin.commands, { desc = "Commands" })
    end,
  },

  -- Claude Code AI アシスタント統合
  {
    "coder/claudecode.nvim",
    dependencies = { "folke/snacks.nvim" },
    config = true,
    keys = {
      { "<leader>cc", "<cmd>ClaudeCode<cr>", desc = "Claude Code" },
      { "<leader>cs", "<cmd>ClaudeCodeSend<cr>", mode = "v", desc = "Claude Send" }
    }
  },

  -- Treesitter (高度なシンタックスハイライト)
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter.configs").setup({
        -- 自動インストールする言語
        ensure_installed = {
          "typescript",
          "javascript",
          "tsx",
          "json",
          "html",
          "css",
          "markdown",
          "markdown_inline",
          "lua",
          "vim",
          "vimdoc",
          "yaml",
          "toml",
        },

        -- 自動インストールを有効化
        auto_install = true,

        -- シンタックスハイライト
        highlight = {
          enable = true,
          additional_vim_regex_highlighting = { "markdown" },  -- Markdown は両方使う
        },

        -- インデント
        indent = {
          enable = true,
        },

        -- 選択範囲の拡張 (v を押すたびに拡大)
        incremental_selection = {
          enable = true,
          keymaps = {
            init_selection = "gnn",
            node_incremental = "grn",
            scope_incremental = "grc",
            node_decremental = "grm",
          },
        },
      })

      -- 折りたたみを Treesitter ベースに設定
      vim.o.foldmethod = "expr"
      vim.o.foldexpr = "nvim_treesitter#foldexpr()"
      vim.o.foldenable = false  -- 起動時は折りたたまない
    end,
  },
})