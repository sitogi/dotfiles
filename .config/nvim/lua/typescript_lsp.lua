local M = {}

-- tsc のルート判定と起動コマンドが共有する実行ファイルの情報を保持する
local defaults = {
  tsc = vim.lsp.config.tsc,
  ts_ls = vim.lsp.config.ts_ls,
}

local function select_server(root_dir)
  local package_path = vim.fs.joinpath(root_dir, "node_modules", "typescript", "package.json")
  local ok, package = pcall(function()
    return vim.json.decode(table.concat(vim.fn.readfile(package_path), "\n"))
  end)

  if ok and type(package) == "table" and type(package.version) == "string" then
    local version = vim.version.parse(package.version)
    if version and version.major >= 7 then
      return "tsc"
    end
  end

  -- TypeScript 未導入の場合も従来の ts_ls に任せる
  return "ts_ls"
end

function M.setup(options)
  for name, default in pairs(defaults) do
    local config = vim.tbl_deep_extend("force", default, options)
    config.root_dir = function(bufnr, on_dir)
      -- 共通のルートで判定し, Deno の除外とモノレポ対応を維持する
      defaults.ts_ls.root_dir(bufnr, function(root_dir)
        if select_server(root_dir) == name then
          default.root_dir(bufnr, on_dir)
        end
      end)
    end
    vim.lsp.config(name, config)
  end

  vim.lsp.enable({ "tsc", "ts_ls" })
end

return M
