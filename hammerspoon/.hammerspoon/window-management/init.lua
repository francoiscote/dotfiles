grid = require("window-management/grid")
layouts = require("window-management/layouts")
helpers = require("window-management/helpers")

-- SETTINGS
-------------------------------------------------------------------------------
hs.window.animationDuration = 0
hs.window.setShadows(false)

-- MAPPINGS
-------------------------------------------------------------------------------
local hyper = {"cmd", "alt", "ctrl"}
local hyperShift = {"cmd", "alt", "ctrl", "shift"}
local areas = grid.areas

-- Layouts
hs.hotkey.bind(hyper, "q", layouts.workBrowse)
hs.hotkey.bind(hyperShift, "q", function()
  layouts.workBrowse(true)
end)

hs.hotkey.bind(hyper, "w", layouts.workCode)
hs.hotkey.bind(hyperShift, "w", function()
  layouts.workCode(true)
end)

hs.hotkey.bind(hyper, "e", layouts.workEven)
hs.hotkey.bind(hyperShift, "e", function()
  layouts.workEven(true)
end)

hs.hotkey.bind(hyper, "r", function() 
  grid.setLargeMargins()
  layouts.workEven()
  grid.setDefaultMargins()
end)
hs.hotkey.bind(hyperShift, "r", function() 
  grid.setLargeMargins()
  layouts.workEven(true)
  grid.setDefaultMargins()
end)

hs.hotkey.bind(hyper, "t", layouts.workMax)
-- hs.hotkey.bind(hyperShift, "t", function() 
-- end)


-- Quick Sizes
-------------------------------------------------------------------------------
hs.hotkey.bind(hyper, "1", function()
  grid.setFocusedWindowToCell(areas.custom.smallLeft)
end)
hs.hotkey.bind(hyperShift, "1", function()
  grid.setLargeMargins()
  grid.setFocusedWindowToCell(areas.custom.smallLeft)
  grid.setDefaultMargins()
end)

hs.hotkey.bind(hyper, "2", function()
  grid.setFocusedWindowToCell(areas.evenSplit.leftFull)
end)
hs.hotkey.bind(hyperShift, "2", function()
  grid.setLargeMargins()
  grid.setFocusedWindowToCell(areas.evenSplit.leftFull)
  grid.setDefaultMargins()
end)

hs.hotkey.bind(hyper, "3", function()
  grid.setFocusedWindowToCell(areas.custom.largeLeft)
end)
hs.hotkey.bind(hyperShift, "3", function()
  grid.setLargeMargins()
  grid.setFocusedWindowToCell(areas.custom.largeLeft)
  grid.setDefaultMargins()
end)


hs.hotkey.bind(hyper, "4", function()
  grid.setFocusedWindowToCell(areas.custom.finder)
end)
hs.hotkey.bind(hyperShift, "4", function()
  grid.setFocusedWindowToCell(areas.customTwitch.finder)
end)

hs.hotkey.bind(hyper, "5", function()
  grid.setFocusedWindowToCell(areas.custom.center)
end)
hs.hotkey.bind(hyperShift, "5", function()
  grid.setFocusedWindowToCell(areas.customTwitch.center)
end)

hs.hotkey.bind(hyper, "6", function()
  grid.setFocusedWindowToCell(areas.custom.browser)
end)
hs.hotkey.bind(hyperShift, "6", function()
  grid.setFocusedWindowToCell(areas.customTwitch.browser)
end)

hs.hotkey.bind(hyper, "7", function()
  grid.setFocusedWindowToCell(areas.custom.largeRight)
end)
hs.hotkey.bind(hyperShift, "7", function()
  grid.setLargeMargins()
  grid.setFocusedWindowToCell(areas.custom.largeRight)
  grid.setDefaultMargins()
end)

hs.hotkey.bind(hyper, "8", function()
  grid.setFocusedWindowToCell(areas.evenSplit.rightFull)
end)
hs.hotkey.bind(hyperShift, "8", function()
  grid.setLargeMargins()
  grid.setFocusedWindowToCell(areas.evenSplit.rightFull)
  grid.setDefaultMargins()
end)


hs.hotkey.bind(hyper, "9", function()
  grid.setFocusedWindowToCell(areas.custom.smallRight)
end)
hs.hotkey.bind(hyperShift, "9", function()
  grid.setLargeMargins()
  grid.setFocusedWindowToCell(areas.custom.smallRight)
  grid.setDefaultMargins()
end)

hs.hotkey.bind(hyper, "0", function()
  local win = hs.window.focusedWindow()
  win:maximize()
end)

hs.hotkey.bind(hyperShift, "0", function()
  -- Full Size for Twitch
  local win = hs.window.focusedWindow()
  grid.hsGrid.set(win, '0,0 7x8')
end)

-- Focus Mode
-------------------------------------------------------------------------------
-- Hyper+A - Focus Mode
-- Center the focused Window and Hide Others
-- the key act as a toggle between focus mode and the previously used layout
local focusMode = false;
local focusedWindow;
local savedFrame;
hs.hotkey.bind(hyper, "a", function()
  if (focusMode == true) then
    -- Restore Window's position
    focusedWindow:setFrame(savedFrame)
    
    -- Show All Windows
    focusedWindow:application():selectMenuItem("Show All");
    
    focusMode = false;
    hyper.triggered = true
  else 
    -- Save focused window and its position
    focusedWindow = hs.window.focusedWindow()
    savedFrame = focusedWindow:frame()

    -- Center Window
    -- Different layouts for different apps
    if (focusedWindow:application():name() == "Google Chrome") then
      grid.setFocusedWindowToCell(areas.custom.browser);
    elseif (focusedWindow:application():name() == "Things") or (focusedWindow:application():name() == "Obsidian") then
      grid.setFocusedWindowToCell(areas.custom.finder);
    else 
      grid.setFocusedWindowToCell(areas.custom.center);
    end
    
    -- Hide all other windows
    local activeApp = hs.application.frontmostApplication();
    activeApp:selectMenuItem("Hide Others");

    focusMode = true;
    hyper.triggered = true
  end
end)


-- Move Windows
-------------------------------------------------------------------------------
-- C - Center
hs.hotkey.bind(hyper, "c", function()
    local win = hs.window.focusedWindow()
    win:centerOnScreen(nil, true)
    hyper.triggered = true
end)


-- Hyper+- - TBD
hs.hotkey.bind(hyper, "-", function()
end)

-- Hyper+equal - Send window to next screen. 
-- If sending to 4k screen, center the window in it. 
-- If sending to the laptop screen, maximize it.
hs.hotkey.bind(hyper, "=", function()
  -- Get the focused window, its window frame dimensions, its screen frame dimensions,
  -- and the next screen's frame dimensions.
  local focusedWindow = hs.window.focusedWindow()
  local nextScreen = focusedWindow:screen():next()
  
  focusedWindow:moveToScreen(nextScreen)

  log.d(nextScreen:name());
  if string.find(nextScreen:name(), "BenQ") then
    log.d("CENTER")
    grid.setFocusedWindowToCell(areas.custom.center)
  else
    log.d("MAXIMISE")
    focusedWindow:maximize()
  end
end)

-- HyperShift+[left, right] - Send and follow window to next/previous space
hs.hotkey.bind(hyperShift, "right", nil, function()
  helpers.moveWindowOneSpace('right', true)
end)
hs.hotkey.bind(hyperShift, "left", nil, function()
  helpers.moveWindowOneSpace('left', true)
end)