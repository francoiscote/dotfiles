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
hs.hotkey.bind(hyper, "q", function() 
  layouts.workBrowse(true)
end)
hs.hotkey.bind(hyperShift, "q", layouts.workBrowse)

hs.hotkey.bind(hyper, "w", function() 
  layouts.workCode(true)
end)
hs.hotkey.bind(hyperShift, "w", layouts.workCode)


hs.hotkey.bind(hyper, "e", layouts.workEven)
hs.hotkey.bind(hyperShift, "e", function() 
  grid.setLargeMargins()
  layouts.workEven()
  grid.setDefaultMargins()
end)

hs.hotkey.bind(hyper, "r", layouts.workTriple)

hs.hotkey.bind(hyper, "t", layouts.workMax)
hs.hotkey.bind(hyperShift, "t", function() 
  grid.setLargeMargins()
  layouts.workMax()
  grid.setDefaultMargins()
end)


-- Quick Sizes
-------------------------------------------------------------------------------
hs.hotkey.bind(hyper, "1", function()
  grid.setFocusedWindowToCell(areas.seventySplit.leftSecondaryFull)
end)
hs.hotkey.bind(hyperShift, "1", function()
  grid.setLargeMargins()
  grid.setFocusedWindowToCell(areas.seventySplit.leftSecondaryFull)
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
  grid.setFocusedWindowToCell(areas.seventySplit.leftMain)
end)
hs.hotkey.bind(hyperShift, "1", function()
  grid.setLargeMargins()
  grid.setFocusedWindowToCell(areas.seventySplit.leftMain)
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
  grid.setFocusedWindowToCell(areas.seventySplit.rightMain)
end)
hs.hotkey.bind(hyperShift, "7", function()
  grid.setLargeMargins()
  grid.setFocusedWindowToCell(areas.seventySplit.rightMain)
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
  grid.setFocusedWindowToCell(areas.seventySplit.rightSecondaryFull)
end)
hs.hotkey.bind(hyperShift, "9", function()
  grid.setLargeMargins()
  grid.setFocusedWindowToCell(areas.seventySplit.rightSecondaryFull)
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

-- Move Windows
-------------------------------------------------------------------------------
-- C - Center
hs.hotkey.bind(hyper, "c", function()
    local win = hs.window.focusedWindow()
    win:centerOnScreen(nil, true)
    hyper.triggered = true
end)

-- Hyper+- - Hide everything else and Center
-- TBD
hs.hotkey.bind(hyper, "-", function()
end)

-- Hyper+equal - Send window to next screen
hs.hotkey.bind(hyper, "=", function()
  -- Get the focused window, its window frame dimensions, its screen frame dimensions,
  -- and the next screen's frame dimensions.
  local focusedWindow = hs.window.focusedWindow()
  local windowFrame = focusedWindow:frame()
  local focusedScreenFrame = focusedWindow:screen():frame()
  local nextScreenFrame = focusedWindow:screen():next():frame()
  local windowFrame = focusedWindow:frame()

  -- Calculate the coordinates of the window frame in the next screen and retain aspect ratio
  windowFrame.x = ((((windowFrame.x - focusedScreenFrame.x) / focusedScreenFrame.w) * nextScreenFrame.w) + nextScreenFrame.x)
  windowFrame.y = ((((windowFrame.y - focusedScreenFrame.y) / focusedScreenFrame.h) * nextScreenFrame.h) + nextScreenFrame.y)
  windowFrame.h = ((windowFrame.h / focusedScreenFrame.h) * nextScreenFrame.h)
  windowFrame.w = ((windowFrame.w / focusedScreenFrame.w) * nextScreenFrame.w)

  -- Set the focused window's new frame dimensions
  focusedWindow:setFrame(windowFrame)
end)

hs.hotkey.bind(hyperShift, "right", function()
  helpers.moveWindowOneSpace('right')
end)

hs.hotkey.bind(hyperShift, "left", function()
  helpers.moveWindowOneSpace('left')
end)