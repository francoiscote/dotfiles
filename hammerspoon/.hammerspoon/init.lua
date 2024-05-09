-- SETTINGS
-------------------------------------------------------------------------------
local hyper = { "cmd", "alt", "ctrl" }
local hyperShift = { "cmd", "alt", "ctrl", "shift" }


hs.logger.defaultLogLevel = 'info'
Log = hs.logger.new('WM', 'debug')


-- Tools
-------------------------------------------------------------------------------

-- CONFIG AUTO RELOAD
local configWatcher = hs.pathwatcher.new(os.getenv("HOME") .. "/.hammerspoon/", hs.reload):start()

-- Hyper+Z - Shortcut to reload config
hs.hotkey.bind(hyper, "z", hs.reload)

-- Hyper+Shift+Z - Shortcut to inspect a window
hs.hotkey.bind(hyperShift, "z", function()
  local w = hs.window.focusedWindow()
  Log.d("Application Name:", w:application():name())
  Log.d("Id:", w:id())
  Log.d("Title:", w:title())
  Log.d("TopLeft:", w:topLeft())
  Log.d("Size:", w:size())
  Log.d("isFullScreen:", w:isFullScreen())
  Log.d("Frame:", w:frame())
  Log.d("Role:", w:role())
  Log.d("Subrole:", w:subrole())
end)

require('app-switcher')
require('audio')
require('window-management')

hs.alert("HS ✔︎")
