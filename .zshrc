# Add deno completions to search path
if [[ ":$FPATH:" != *":/Users/masayuki/.zsh/completions:"* ]]; then export FPATH="/Users/masayuki/.zsh/completions:$FPATH"; fi
# anyenv
export PATH="$HOME/.anyenv/bin:$PATH"
eval "$(anyenv init -)"

# zplug
export ZPLUG_HOME=/opt/homebrew/opt/zplug
source $ZPLUG_HOME/init.zsh
zplug 'zplug/zplug', hook-build:'zplug --self-manage'

# 非同期処理できるようになる
zplug "mafredri/zsh-async"

# テーマ(ここは好みで。調べた感じpureが人気)
zplug "sindresorhus/pure"

# 構文のハイライト(https://github.com/zsh-users/zsh-syntax-highlighting)
zplug "zsh-users/zsh-syntax-highlighting"

# コマンド入力途中で上下キー押したときの過去履歴がいい感じに出るようになる
zplug "zsh-users/zsh-history-substring-search"

# 過去に入力したコマンドの履歴が灰色のサジェストで出る
zplug "zsh-users/zsh-autosuggestions"

# 補完強化
zplug "zsh-users/zsh-completions"

# 256色表示にする
zplug "chrissicool/zsh-256color"

# ターミナル上で Vim のキーバインディングで操作できるようにする
zplug "jeffreytse/zsh-vi-mode"
ZVM_VI_INSERT_ESCAPE_BINDKEY=jj

# コマンドライン上の文字リテラルの絵文字を emoji 化する
zplug "mrowa44/emojify", as:command

# Install plugins if there are plugins that have not been installed
if ! zplug check --verbose; then
  printf "Install? [y/N]: "
  if read -q; then
    echo; zplug install
  fi
fi

# コマンドの履歴機能
# 履歴ファイルの保存先
HISTFILE=$HOME/.zsh_history

# メモリに保存される履歴の件数
HISTSIZE=10000

# HISTFILE で指定したファイルに保存される履歴の件数
SAVEHIST=10000

# 各タブなどで history の共有化
setopt share_history

# Then, source plugins and add commands to $PATH
zplug load

# Environment Vars

## ls

export TIME_STYLE="+%Y-%m-%d %H:%M:%S"

## less

export LESS="-iNMRS"

## fzf
## export FZF_DEFAULT_COMMAND='find . -type d -name node_modules -prune -o -name .git -prune -o -name build -prune -o -type f -print'
export FZF_DEFAULT_COMMAND='fd -H -E .git'
export FZF_DEFAULT_OPTS='--height 60% --reverse --border --preview "bat --color=always --style=header,grid --line-range :100 {}"'

# これを入れておかないと zvm で fzf のキーバインディングを上書きしてしまう
zvm_after_init_commands+=('[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh')

# Aliases
if [[ $(command -v nvim) ]]; then
  alias vim='nvim'
  alias vimdiff='nvim -d '
fi
if [[ $(command -v tmux) ]]; then
  alias ide='~/.scripts/ide.sh'
fi
if [[ $(command -v delta) ]]; then
  alias diff='delta'
fi
if [[ $(command -v eza) ]]; then
  alias ls='eza'
fi
alias vimf='vim $(fzf)'
alias d='docker'
alias di='docker image'
alias dil='docker image ls -a'
alias dc='docker container'
alias dcl='docker container ls -a'
alias dcr='docker container run'
alias dcrr='docker container run --rm'
alias dcom='docker compose'
alias gcloud='docker run -it --rm --volumes-from gcloud-config gcr.io/google.com/cloudsdktool/cloud-sdk bash'
alias confetti='open -g raycast://confetti'
alias npmf='jq -r '\''.scripts | to_entries[] | "\(.key)"'\'' package.json | fzf | xargs npm run'
alias gencm='HOME=/dev/null git diff HEAD | pbcopy && open -g raycast://ai-commands/generate-commit-message'
alias cdf='cd $(fd --type d --hidden --exclude .git --exclude node_modules . ~ | fzf)'

# PATH
## Rust
export PATH="$HOME/.cargo/bin:$PATH"
export PATH="/opt/homebrew/opt/llvm/bin:$PATH"
export PATH="$HOME/JetBrains:$PATH"
## Deno
export PATH="$HOME/.deno/bin:$PATH"
. "/Users/masayuki/.deno/env"
# Initialize zsh completions (added by deno install script)
autoload -Uz compinit
compinit
# pnpm
export PNPM_HOME="/Users/masayuki/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end
