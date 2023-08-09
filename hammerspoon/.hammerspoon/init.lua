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

-- Hyper+Shift+Z - Shortcut to inspect a window
hs.hotkey.bind(hyperShift, "z", function()
  local w = hs.window.focusedWindow()
  log.d("Application Name:", w:application():name())
  log.d("Id:", w:id())
  log.d("Title:", w:title())
  log.d("TopLeft:", w:topLeft())
  log.d("Size:", w:size())
  log.d("isFullScreen:", w:isFullScreen())
  log.d("Frame:", w:frame())
  log.d("Role:", w:role())
  log.d("Subrole:", w:subrole())
end)

require('app-switcher')
require('audio')
require('window-management')