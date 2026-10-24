local M = {}
local pending_edit
local configured = false

local function is_editor(win)
  return vim.api.nvim_win_is_valid(win)
    and vim.api.nvim_win_get_config(win).relative == ""
    and vim.bo[vim.api.nvim_win_get_buf(win)].buftype == ""
end

local function find_editor()
  -- 起動元がエクスプローラの場合は, 同じタブページの編集ウィンドウを選ぶ
  local previous = vim.fn.win_getid(vim.fn.winnr("#"))
  if previous ~= 0 and is_editor(previous) then
    return previous
  end
  for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
    if is_editor(win) then
      return win
    end
  end
end

local function open_file(edit)
  if not vim.api.nvim_tabpage_is_valid(edit.tab) then
    return
  end
  vim.api.nvim_set_current_tabpage(edit.tab)
  if edit.win and is_editor(edit.win) then
    vim.api.nvim_set_current_win(edit.win)
  else
    local win = find_editor()
    if win then
      vim.api.nvim_set_current_win(win)
    else
      -- 編集領域がない場合も, エクスプローラの右側に開く
      vim.cmd("botright vsplit")
    end
  end

  -- 開いているバッファを再利用し, 切り替え元の未保存の編集も保持する
  local buf = vim.fn.bufadd(edit.path)
  vim.bo[buf].buflisted = true
  vim.api.nvim_cmd({ cmd = "buffer", args = { tostring(buf) }, mods = { hide = true } }, {})
  if edit.line > 0 then
    vim.api.nvim_win_set_cursor(0, { math.min(edit.line, vim.api.nvim_buf_line_count(buf)), 0 })
    vim.cmd("normal! zvzz")
  end
end

function M.request(path, line)
  local buf = vim.api.nvim_get_current_buf()
  local job = vim.b[buf].terminal_job_id
  assert(job, "LazyGit の端末が見つかりません")
  local edit = { path = path, line = line, tab = vim.api.nvim_get_current_tabpage(), win = find_editor() }
  if vim.bo[buf].filetype == "lazygit" and vim.g.lazygit_opened == 1 then
    M.setup()
    pending_edit = edit
  else
    -- :terminal から直接起動した LazyGit でも, 終了後に同じ画面へ戻す
    edit.win = edit.win or vim.api.nvim_get_current_win()
    vim.api.nvim_create_autocmd("TermClose", {
      buffer = buf,
      once = true,
      callback = function()
        vim.schedule(function()
          -- 終了した端末のウィンドウは編集領域として再利用できる
          if edit.win and vim.api.nvim_win_is_valid(edit.win) then
            vim.api.nvim_set_current_win(edit.win)
            vim.api.nvim_win_set_buf(edit.win, vim.fn.bufadd(edit.path))
          end
          open_file(edit)
        end)
      end,
    })
  end
  vim.schedule(function()
    vim.api.nvim_chan_send(job, "q")
  end)
end

function M.setup()
  if configured then
    return
  end
  configured = true
  local on_exit = vim.g.lazygit_on_exit_callback
  vim.g.lazygit_on_exit_callback = function()
    local edit = pending_edit
    pending_edit = nil
    if on_exit then
      on_exit()
    end
    if edit then
      -- プラグインが元のウィンドウへ戻す処理を終えてから開く
      vim.schedule(function()
        open_file(edit)
      end)
    end
  end
end

return M
