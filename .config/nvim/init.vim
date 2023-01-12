" 英語化
let $LANG='en_US.UTF-8'
" Leader キーを , に変更
let mapleader = ","
"文字コードをUFT-8に設定
set fenc=utf-8
set encoding=utf-8
" バックアップファイルを作らない
set nobackup
" スワップファイルを作らない
set noswapfile
" 編集中のファイルが変更されたら自動で読み直す
set autoread
" バッファが編集中でもその他のファイルを開けるように
set hidden
" 入力中のコマンドをステータスに表示する
set showcmd
" 最終行の空行を表示する
set noendofline


" スペルチェック
set spell
" 日本語は除外する
set spelllang=en,cjk
" 辞書ファイルの場所
set spellfile=~/.config/nvim/spell/en.utf-8.add


" 見た目系
" 行番号を表示
set number
" 現在の行を強調表示
set cursorline
" 現在の行を強調表示（縦）
" set cursorcolumn
" 行末の1文字先までカーソルを移動できるように
set virtualedit=onemore
" インデントはスマートインデント
set smartindent
" ビープ音を可視化
set visualbell
" 括弧入力時の対応する括弧を表示
set showmatch
" ステータスラインを常に表示
set laststatus=2
" コマンドラインの補完
set wildmode=list:longest
" 折り返し時に表示行単位での移動できるようにする
nnoremap j gj
nnoremap k gk
" Tab系
" 不可視文字を可視化
set list listchars=tab:>-
" Tab文字を半角スペースにする
set expandtab
" 行頭以外のTab文字の表示幅（スペースいくつ分）
set tabstop=4
" 行頭でのTab文字の表示幅 (SmartIndent での幅)
set shiftwidth=4


" 検索系
" 検索文字列が小文字の場合は大文字小文字を区別なく検索する
set ignorecase
" 検索文字列に大文字が含まれている場合は区別して検索する
set smartcase
" 検索文字列入力時に順次対象文字列にヒットさせる
set incsearch
" 検索時に最後まで行ったら最初に戻る
set wrapscan
" 検索語をハイライト表示
set hlsearch
" ESC連打でハイライト解除
nmap <Esc><Esc> :nohlsearch<CR><Esc>

" キーコンフィグ系
" Esc キーは遠いので Ctrl + j に変更する
inoremap <silent> jj <Esc>

" 保存時のアクション
function! s:remove_dust()
    let cursor = getpos(".")
    " 空白のみの行の空白を削除
    %s/^\s\+$//ge
    " 行末の空白を削除
    %s/\s\+$//ge
    " 保存時に tab を 4 スペースに変換する
    %s/\t/    /ge
    call setpos(".", cursor)
    unlet cursor
endfunction
autocmd BufWritePre * call <SID>remove_dust()

" クリップボード共有
set clipboard=unnamed

" tmux からの Vim を起動した際の色表示を正常にする
set background=dark
set t_Co=256

" s での insert は何があっても動いてほしくないので無効
nnoremap s <Nop>

" dein Scripts (see: https://qiita.com/delphinus/items/00ff2c0ba972c6e41542)
let s:dein_dir = expand('~/.config/nvim/.cache/dein')
let s:dein_repo_dir = s:dein_dir . '/repos/github.com/Shougo/dein.vim'

if &runtimepath !~# '/dein.vim'
  if !isdirectory(s:dein_repo_dir)
    execute '!git clone https://github.com/Shougo/dein.vim' s:dein_repo_dir
  endif
  execute 'set runtimepath^=' . fnamemodify(s:dein_repo_dir, ':p')
endif

if dein#load_state(s:dein_dir)
  call dein#begin(s:dein_dir)

  " easymotion の 分岐が toml 上だとうまくいかないのでこちらに記載
  if exists('g:vscode')
    " vscodeの場合こちらのプラグインを利用
    call dein#add('asvetliakov/vim-easymotion')
    " sで任意の２文字から始まる場所へジャンプ
    nmap s <Plug>(easymotion-s2)
  else
    " それ以外(nvim起動等)の場合は正規vim-easymotionを利用
    call dein#add('easymotion/vim-easymotion')
    nmap s <Plug>(easymotion-overwin-f2)
  endif
  let g:EasyMotion_smartcase = 1

  let g:rc_dir    = expand('~/.config/nvim/rc')
  let s:toml      = g:rc_dir . '/dein.toml'
  let s:lazy_toml = g:rc_dir . '/dein_lazy.toml'

  call dein#load_toml(s:toml,      {'lazy': 0})
  call dein#load_toml(s:lazy_toml, {'lazy': 1})

  call dein#end()
  call dein#save_state()
endif

if dein#check_install()
  call dein#install()
endif
" End dein Scripts-------------------------

syntax enable

nnoremap O :<C-u>call append(expand('.'), '')<Cr>j

" For nvim-treesitter
lua <<EOF
require'nvim-treesitter.configs'.setup {
  highlight = {
    enable = true,
  }
}
EOF

" fzf key maps
nnoremap [Fzf] <Nop>
nnoremap <Leader>f :<C-u>Files<CR>
nnoremap <Leader>g :<C-u>GFiles<CR>
nnoremap <Leader>b :<C-u>Buffers<CR>
nnoremap <Leader>r :<C-u>Rg<CR>

" vscode-neovim で Ctrl+J をホバー表示にする
if exists('g:vscode')
  nnoremap <C-j> <Cmd>call VSCodeCall('editor.action.showHover')<CR>
endif

" 非アクティブの場合に背景色を変える
augroup ChangeBackground
  autocmd!
  autocmd WinEnter * highlight Normal guibg=default
  autocmd WinEnter * highlight NormalNC guibg='#27292d'
  autocmd FocusGained * highlight Normal guibg=default
  autocmd FocusLost * highlight Normal guibg='#27292d'
augroup END
