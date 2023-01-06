#!/bin/sh

# dotfiles
ln -sf ~/dotfiles/.git-prompt.sh ~/.git-prompt.sh
ln -sf ~/dotfiles/.bashrc ~/.bashrc
ln -sf ~/dotfiles/.inputrc ~/.inputrc
ln -sf ~/dotfiles/.tmux.conf ~/.tmux.conf
ln -sf ~/dotfiles/.vimrc ~/.vimrc
ln -sf ~/dotfiles/.ideavimrc ~/.ideavimrc
ln -sf ~/dotfiles/.gitconfig ~/.gitconfig
ln -sf ~/dotfiles/.zshrc ~/.zshrc
ln -sf ~/dotfiles/.fzf.bash ~/.fzf.bash
ln -sf ~/dotfiles/.fzf.zsh ~/.fzf.zsh

# Vim plugin Settings
mkdir -p ~/.vim/rc
ln -sf ~/dotfiles/.vim/rc/dein_lazy.toml ~/.vim/rc/dein_lazy.toml
ln -sf ~/dotfiles/.vim/rc/dein.toml ~/.vim/rc/dein.toml
ln -sf ~/dotfiles/.vim/templates ~/.vim/templates

# Neovim
mkdir -p ~/.config/nvim/rc
ln -sf ~/dotfiles/.config/nvim/init.vim ~/.config/nvim/init.vim
ln -sf ~/dotfiles/.config/nvim/coc-settings.json ~/.config/nvim/coc-settings.json
ln -sf ~/dotfiles/.config/nvim/rc/dein_lazy.toml ~/.config/nvim/rc/dein_lazy.toml
ln -sf ~/dotfiles/.config/nvim/rc/dein.toml ~/.config/nvim/rc/dein.toml

# VSCode Settings
mkdir -p ~/.config/Code/User
ln -sf ~/dotfiles/.vscode/settings.json "/Users/masayuki/Library/Application Support/Code/User/settings.json"
ln -sf ~/dotfiles/.vscode/keybindings.json "/Users/masayuki/Library/Application Support/Code/User/keybindings.json"
sh ~/dotfiles/.vscode/installExtensions.sh

# Scripts
mkdir -p ~/.scripts
ln -sf ~/dotfiles/.scripts/ide.sh ~/.scripts/ide.sh

# Alacritty
mkdir -p ~/.config/alacritty
ln -sf ~/dotfiles/.config/alacritty/alacritty.yml ~/.config/alacritty/alacritty.yml
