-- LOAD DEPS
-------------------------------------------------------------------------------
hs.loadSpoon('Hyper')

-- SETTINGS
-------------------------------------------------------------------------------
hs.logger.defaultLogLevel = 'info'
hs.window.animationDuration = 0

Hyper = spoon.Hyper
Hyper:bindHotKeys({ hyperKey = { {}, 'F19' } })

local log = hs.logger.new('WM', 'debug')

-- Tools
-------------------------------------------------------------------------------
function dump(o)
  if type(o) == 'table' then
    local s = '{ '
    for k, v in pairs(o) do
      if type(k) ~= 'number' then k = '"' .. k .. '"' end
      s = s .. '[' .. k .. '] = ' .. dump(v) .. ','
    end
    return s .. '} '
  else
    return tostring(o)
  end
end

-- Hyper+Z - Shortcut to reload config
Hyper:bind({}, 'z', nil, hs.reload)

-- Hyper+Shift+Z - Shortcut to inspect a window
Hyper:bind({ 'shift' }, 'z', nil, function()
  local w = hs.window.focusedWindow()
  log.d("Application Name:", w:application():name())
  log.d("Bundle Id:", w:application():bundleID())
  log.d("Id:", w:id())
  log.d("Title:", w:title())
  log.d("TopLeft:", w:topLeft())
  log.d("Size:", w:size())
  log.d("isFullScreen:", w:isFullScreen())
  log.d("Frame:", w:frame())
  log.d("Role:", w:role())
  log.d("Subrole:", w:subrole())
end)


-- Requires
-------------------------------------------------------------------------------
require('app-switcher')
require('app-watchers');
require('audio')
require('window-management')

-- DONE!
-------------------------------------------------------------------------------
hs.alert("HS ✔︎")
