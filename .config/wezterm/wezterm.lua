-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- This table will hold the configuration.
local config = {}

-- In newer versions of wezterm, use the config_builder which will
-- help provide clearer error messages
if wezterm.config_builder then
  config = wezterm.config_builder()
end

-- 追加したもの
config.font = wezterm.font("Moralerspace Neon", {weight="Regular", stretch="Normal", style="Normal"})
config.font_size = 16.5
config.color_scheme = 'Orangish (terminal.sexy)'
config.window_background_opacity = 0.75
config.hide_tab_bar_if_only_one_tab = true

-- カスタムリンクルール
config.hyperlink_rules = wezterm.default_hyperlink_rules()
local status, customLinkRules = pcall(require, "custom_link_rules")
if status then
  table.insert(config.hyperlink_rules, customLinkRules)
end

-- and finally, return the configuration to wezterm
return config