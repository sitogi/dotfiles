-- ファイル名をコマンド文字列に埋め込まず, 起動元の Neovim に渡す
local channel = vim.fn.sockconnect("pipe", assert(vim.env.NVIM, "起動元の Neovim が見つかりません"), { rpc = true })
assert(channel > 0, "起動元の Neovim に接続できません")
vim.rpcrequest(channel, "nvim_exec_lua", 'return require("lazygit_editor").request(...)', {
  vim.fn.fnamemodify(assert(arg[1], "編集するファイルが指定されていません"), ":p"),
  tonumber(arg[2]) or 0,
})
vim.fn.chanclose(channel)
