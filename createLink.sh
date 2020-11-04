#!/bin/sh

# dotfiles
ln -sf ~/dotfiles/.git-prompt.sh ~/.git-prompt.sh
ln -sf ~/dotfiles/.bashrc ~/.bashrc
ln -sf ~/dotfiles/.inputrc ~/.inputrc
ln -sf ~/dotfiles/.tmux.conf ~/.tmux.conf
ln -sf ~/dotfiles/.vimrc ~/.vimrc
ln -sf ~/dotfiles/.ideavimrc ~/.ideavimrc
ln -sf ~/dotfiles/.gitconfig ~/.gitconfig

# Vim plugin Settings
mkdir -p ~/.vim/rc
ln -sf ~/dotfiles/.vim/rc/dein_lazy.toml ~/.vim/rc/dein_lazy.toml
ln -sf ~/dotfiles/.vim/rc/dein.toml ~/.vim/rc/dein.toml

ln -sf ~/dotfiles/.vim/templates ~/.vim/templates

# VSCode Settings
mkdir -p ~/.config/Code/User
ln -sf ~/dotfiles/.vscode/settings.json ~/.config/Code/User/settings.json
ln -sf ~/dotfiles/.vscode/keybindings.json ~/.config/Code/User/keybindings.json
bash ./.vscode/installExtensions.sh

# fish
mkdir -p ~/.config/Code/User
ln -sf ~/dotfiles/.config/config.fish ~/.config/fish/config.fish
ln -sf ~/dotfiles/.config/functions/fish_user_key_bindings.fish ~/.config/fish/functions/fish_user_key_bindings.fish

