#!/bin/bash
#
# tmux-worktree - git worktreeを使ったtmuxウィンドウ作成スクリプト
#
# 概要:
#   git worktreeで作業ツリーを作成後、新しいtmuxウィンドウを作成し、
#   3つのペインに分割します：
#   - 左上: 編集用
#   - 左下: git操作用
#   - 右側（広め）: claudeコマンドを実行
#
# 使用方法:
#   tmux-worktree <ブランチ名> [ベースブランチ]
#
# 使用例:
#   tmux-worktree feature-test              # 現在のブランチから作成
#   tmux-worktree feature-auth main         # mainブランチから作成
#   tmux-worktree hotfix-bug develop        # developブランチから作成
#
# ディレクトリ名: {リポジトリ名}-{ブランチ名}
#   例: myproject-feature-test
#
# レイアウト:
#   ┌─────────┬─────────────┐
#   │    0    │             │
#   ├─────────┤      1      │
#   │    2    │   (claude)  │
#   └─────────┴─────────────┘

branch_name="$1"
base_branch="${2:-$(git branch --show-current)}"

if [ -z "$branch_name" ]; then
    echo "使用方法: tmux-worktree <ブランチ名> [ベースブランチ]"
    echo "デフォルトベースブランチ: 現在のブランチ ($(git branch --show-current))"
    exit 1
fi

# リポジトリ名を取得
repo_name=$(basename $(git rev-parse --show-toplevel))
worktree_dir="../${repo_name}-${branch_name}"

echo "Creating worktree: $worktree_dir"

# まずworktreeを作成
if git show-ref --verify --quiet refs/heads/$branch_name; then
    # 既存ブランチを使用
    git worktree add "$worktree_dir" "$branch_name"
else
    # 新しいブランチを作成
    git worktree add -b "$branch_name" "$worktree_dir" "$base_branch"
fi

# worktree作成に失敗した場合は終了
if [ $? -ne 0 ]; then
    echo "Failed to create worktree"
    exit 1
fi

echo "Worktree created successfully. Setting up tmux..."

# tmuxウィンドウを作成してレイアウト構築
# 1. まず左右分割（左40%, 右60%）
# 2. 左側を上下分割
# 3. 右側でclaudeを実行
tmux new-window -n "wt-$branch_name" -c "$worktree_dir" \; \
  split-window -h -p 60 -c "$worktree_dir" \; \
  send-keys "claude" Enter \; \
  select-pane -t 0 \; \
  split-window -v -c "$worktree_dir" \; \
  select-pane -t 0