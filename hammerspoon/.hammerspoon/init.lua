-- SETTINGS
-------------------------------------------------------------------------------
local hyper = { "cmd", "alt", "ctrl" }
local hyperShift = { "cmd", "alt", "ctrl", "shift" }


hs.logger.defaultLogLevel = 'info'
local log = hs.logger.new('WM', 'debug')


-- Tools
-------------------------------------------------------------------------------

-- Hyper+Z - Shortcut to reload config
hs.hotkey.bind(hyper, "z", hs.reload)

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

hs.alert("HS ✔︎")
