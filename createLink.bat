mklink %HOMEPATH%"\.vimrc" %HOMEPATH%"\dotfiles\.vimrc"
mklink %HOMEPATH%"\.ideavimrc" %HOMEPATH%"\dotfiles\.ideavimrc"
mklink /D %HOMEPATH%"\.gitconfig" %HOMEPATH%"\dotfiles\.gitconfig"
mklink %HOMEPATH%"\AppData\Roaming\Code\User\settings.json" %HOMEPATH%"\dotfiles\.vscode\settings.json"
mklink %HOMEPATH%"\AppData\Roaming\Code\User\keybindings.json" %HOMEPATH%"\dotfiles\.vscode\keybindings.json"
exit 0

