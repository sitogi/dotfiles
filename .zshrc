# anyenv
export PATH="$HOME/.anyenv/bin:$PATH"
eval "$(anyenv init -)"

# zplug
source ~/.zplug/init.zsh
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

# aliases
alias vim='nvim'
alias vimdiff='nvim -d '
alias ide='~/.scripts/ide.sh'
alias diff='delta'
alias ls='exa'
alias vf='vim $(fzf)'
alias d='docker'
alias dc='docker container'
alias di='docker image'
alias dcom='docker compose'

export LESS="-iNMRS"

# fzf
# export FZF_DEFAULT_COMMAND='find . -type d -name node_modules -prune -o -name .git -prune -o -name build -prune -o -type f -print'
export FZF_DEFAULT_COMMAND='fd -H -E .git'
export FZF_DEFAULT_OPTS='--height 60% --reverse --border --preview "bat --color=always --style=header,grid --line-range :100 {}"'

# これを入れておかないと zvm で fzf のキーバインディングを上書きしてしまう
zvm_after_init_commands+=('[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh')

