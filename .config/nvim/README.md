# Neovim の設定

Neovim 0.12 以降を使用する. プラグインのバージョンは `lazy-lock.json` で管理する.

## 必要なコマンド

- `git`, `rg`, `fd`, `lazygit`
- Node.js >=22.22.2 と npm (TypeScript 言語サーバー v6 用)
- `tree-sitter` >=0.26.1, C コンパイラ, `curl`, `tar`

macOS の `tree-sitter` CLI は `brew install tree-sitter-cli` で導入する.
初回起動時にタグ補完用のパーサーをインストールする. 完了後に対象ファイルを開き直す.

## よく使うキー

`<leader>` はスペース.

| キー | 動作 |
| --- | --- |
| `s` + 2 文字 + ラベル | EasyMotion で移動 |
| `gc`, `gcc` | 標準機能でコメントを切り替え |
| `<C-e>` | ファイルツリーを開閉 |
| `<leader>nf` | 現在のファイルをツリーに表示 |
| `<leader>nb`, `<leader>b` | バッファ一覧 |
| `<leader>ng` | Git の変更一覧 |
| `<leader>f` | Git 管理ファイルを検索 |
| `<leader>g` | ファイル内容を検索 |
| `<leader>e` | 最近開いたファイル |
| `<leader>lg`, `:LazyGit` | LazyGit を開く |
| `<leader>dd`, `:CodeDiff` | 変更ファイル一覧と左右の差分 |
| `<leader>de` | CodeDiff のファイル一覧にフォーカスを戻す |
| `gd`, `<leader>td` | 定義へ移動 |
| `gr`, `<leader>tr` | 参照を検索 |
| `<leader>ts`, `<leader>tw` | ファイル内・ワークスペースのシンボル |
| `<leader>te` | 診断一覧 |
| `[d`, `]d` | 前・次の診断へ移動して詳細を表示 |
| `<leader>F` | TypeScript / JavaScript を LSP で整形 |

検索画面では `<C-j>` / `<C-k>` で移動, `<Tab>` で選択, `<C-q>` で quickfix に送信する.

## 検索とファイル操作

検索は Telescope, ファイルツリーは Neo-tree, Git UI の起動は lazygit.nvim を使用する. 上記のキーに加えて `:Telescope`, `:Neotree`, `:LazyGit` でも開ける.

ツリー内の `S` / `s` / `t` は水平分割・垂直分割・新しいタブで開く. `P` はプレビュー, `l` はプレビューへフォーカス, `C` はディレクトリを閉じる, `z` はすべて閉じる, `R` は更新, `?` はヘルプ.

ディレクトリ作成は `A`, ファイル作成は `a` を使う. ファイル移動は `m`, または `x` と `p` を使う. コピーは `y` と `p`, または `c` を使う.

Git の変更一覧は `ga` でステージ, `gu` で解除, `gr` で変更を戻す. コミットや push は `<leader>lg` の LazyGit からも操作できる.

CodeDiff はファイル一覧にフォーカスして開く. 一覧で `j` / `k` または上下キーを押すと, 一覧にフォーカスを残したまま差分を更新する. ファイル上で `Enter` を押すと右側のエディタへ移る. `]f` / `[f` でも次・前のファイルへ切り替えられる.

タグ補完は HTML, JSX / TSX, XML, PHP, Blade に対応し, 対になるタグの名前変更も行う.

## 整形と更新

タブと行末空白を保存時に一括置換する処理は削除した. インデントなどはファイルごとの EditorConfig に従い, 必要なときに `<leader>F` で整形する.

- `:Lazy update`: プラグインを更新する. Tree-sitter 更新時は `:TSUpdate` も実行される.
- `:Lazy restore`: プラグインを `lazy-lock.json` のバージョンに揃える.
- `:Mason`: 言語サーバーを管理する. `:Lazy update` では言語サーバー本体は更新されない.
- `:MasonInstall typescript-language-server@6.0.0`: 今回検証した言語サーバーを導入する.
- `:TSUpdate`: インストール済みパーサーとクエリを更新する.

2026-09-19 に Neovim v0.12.5, Mason v2.3.1, nvim-lspconfig v2.11.0, typescript-language-server v6.0.0 で動作を確認した.
