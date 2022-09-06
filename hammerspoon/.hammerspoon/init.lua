helpers = require("helpers")

-- SETTINGS
-------------------------------------------------------------------------------
local hyper = {"cmd", "alt", "ctrl"}
local hyperShift = {"cmd", "alt", "ctrl", "shift"}

hs.logger.defaultLogLevel = 'info'
log = hs.logger.new('WM','debug')

-- Tools
-------------------------------------------------------------------------------

-- CONFIG AUTO RELOAD
function reload_config(files)
  hs.reload()
end
hs.pathwatcher.new(os.getenv("HOME") .. "/.hammerspoon/", reload_config):start()
hs.alert.show("HS ✔︎")

-- Hyper+Z - Shortcut to reload config
hs.hotkey.bind(hyper, "z", reload_config)

require('app-switcher')
require('audio')
require('window-management')