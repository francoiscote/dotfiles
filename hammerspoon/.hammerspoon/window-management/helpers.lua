local export = {}

-- HELPER FUNCTIONS
-------------------------------------------------------------------------------
function export.maximiseWindows(windows)
  for i,w in pairs(windows) do
    w:maximize()
  end
end

function export.maximiseFilteredWindows(wf)
  local windows = wf:getWindows()
  export.maximiseWindows(windows)
end

function export.getDynamicMargins(h, v)
  local max = hs.window.focusedWindow():screen():frame()
  local hPad = math.floor(max.w * h)
  local vPad = math.floor(max.h * v)

  return hs.geometry.size(hPad,vPad)
end

function export.moveWindowOneSpace(direction)
  local keyCode = direction == "left" and 123 or 124

  -- get current window
  local focusedWindow = hs.window.focusedWindow()
  -- log.d("Window TopLeft:", focusedWindow:topLeft())
  
  -- click at {+64,+4} and hold
  local clickPos = focusedWindow:topLeft():move({64,4})
  -- log.d("Click Pos:", clickPos)
  hs.eventtap.event.newMouseEvent(hs.eventtap.event.types.leftMouseDown, clickPos):post()
  
  -- execute keyboard shortcut
  hs.timer.usleep(1000)
  -- log.d("Key Stroke")
  hs.osascript.applescript([[
    tell application "System Events" 
        keystroke (key code ]] .. keyCode .. [[ using control down)
    end tell
  ]])

  -- -- MouseUp
  hs.timer.usleep(1000)
  hs.eventtap.event.newMouseEvent(hs.eventtap.event.types.leftMouseUp, clickPos):post()
end

return export