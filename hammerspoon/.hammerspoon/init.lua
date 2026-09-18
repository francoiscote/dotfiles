-- LOAD DEPS
-------------------------------------------------------------------------------


-- SETTINGS
-------------------------------------------------------------------------------
hs.logger.defaultLogLevel = 'info'
hs.window.animationDuration = 0

hs.loadSpoon("Hyper")
local hyper = spoon.Hyper

local log = hs.logger.new('WM', 'debug')

-- Tools
-------------------------------------------------------------------------------
Dump = function(o)
  if type(o) == 'table' then
    local s = '{ '
    for k, v in pairs(o) do
      if type(k) ~= 'number' then k = '"' .. k .. '"' end
      s = s .. '[' .. k .. '] = ' .. Dump(v) .. ','
    end
    return s .. '} '
  else
    return tostring(o)
  end
end

local function inspectFocusedWindow()
  local w = hs.window.focusedWindow()
  if not w then
    log.w("No focused window")
    return
  end

  local app = w:application()
  log.d("Application Name:", app and app:name())
  log.d("Bundle Id:", app and app:bundleID())
  log.d("Id:", w:id())
  log.d("Title:", w:title())
  log.d("TopLeft:", w:topLeft())
  log.d("Size:", w:size())
  log.d("isFullScreen:", w:isFullScreen())
  log.d("Frame:", w:frame())
  log.d("Role:", w:role())
  log.d("Subrole:", w:subrole())
end

local hyperBindings = {
  { {},          "z", nil, hs.reload },
  { { "shift" }, "z", nil, inspectFocusedWindow },
}

for _, binding in ipairs(hyperBindings) do
  hyper:bind(binding[1], binding[2], binding[3], binding[4], binding[5])
end


-- Requires
-------------------------------------------------------------------------------
require('app-switcher')
require('audio')
require('window-management')

hyper:start()

-- DONE!
-------------------------------------------------------------------------------
hs.alert("HS ✔︎")

hs.loadSpoon('EmmyLua')
