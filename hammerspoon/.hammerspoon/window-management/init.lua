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
local twitchMode = false;

-- Margins
hs.hotkey.bind(hyper, "x", grid.toggleLargeMargins)
--hs.hotkey.bind(hyperShift, "x", layouts.workBrowse)

-- Layouts
hs.hotkey.bind(hyper, "q", function()
  if (twitchMode == true) then
    layouts.twitchSplit()
  else
    layouts.workBrowse()
  end
end)
hs.hotkey.bind(hyperShift, "q", function()
    layouts.workBrowse(true)
end)

hs.hotkey.bind(hyper, "w", function()
  if (twitchMode == true) then
    layouts.twitchVerticalSplit()
  else 
    layouts.workCode()
  end
end)
hs.hotkey.bind(hyperShift, "w", function()
  layouts.workCode(true)
end)

hs.hotkey.bind(hyper, "e", function()
  if (twitchMode == true) then
    layouts.twitchEvenSplit()
  else
    layouts.workEven()
  end
end)
hs.hotkey.bind(hyperShift, "e", function()
  if (twitchMode == true) then
    layouts.twitchEvenSplit(true)
  else
    layouts.workEven(true) -- with focus on Notes
  end
end)

hs.hotkey.bind(hyper, "r", function()
  if (twitchMode == true) then
    layouts.twitchMax()
  else
    layouts.workMax()
  end
end)

hs.hotkey.bind(hyperShift, "r", function()
  layouts.stream()
end)


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
  if (twitchMode == true) then
    grid.setFocusedWindowToCell(areas.twitch.mainLeft)
  else
    grid.setFocusedWindowToCell(areas.evenSplit.leftFull)
  end
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
    
end)

hs.hotkey.bind(hyper, "5", function()
  grid.setFocusedWindowToCell(areas.custom.center)
end)
hs.hotkey.bind(hyperShift, "5", function()

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
  if (twitchMode == true) then
    grid.setFocusedWindowToCell(areas.twitch.mainRight)
  else
    grid.setFocusedWindowToCell(areas.evenSplit.rightFull)
  end
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
  -- grid.setFocusedWindowToCell(areas.custom.maximize)
  local win = hs.window.focusedWindow()
  if (twitchMode == true) then
      grid.setFocusedWindowToCell(areas.twitch.mainFull)
  else
    win:maximize();
  end
end)

hs.hotkey.bind(hyperShift, "0", function()
  
end)

-- Focus Mode
-------------------------------------------------------------------------------
-- Hyper+A - Focus Mode
-- Center the focused Window and Hide Others
-- the key act as a toggle between focus mode and the previously used layout
local focusMode = false;
local focusedWindow;
local savedFrame;

focusedMenuBar = hs.menubar.new()
function setFocusMode(state)
  if state then
    focusMode = true;
    focusedMenuBar:setTitle(hs.styledtext.new("FOCUSED", { backgroundColor = { red = 1, blue = 0, green = 0 }, color = { red = 1, blue = 1, green = 1 }}))
    -- focusedMenuBar:setTitle("FOCUSED");
  else
    focusMode = false;
    focusedMenuBar:setTitle();
  end
end


hs.hotkey.bind(hyper, "a", function()
  if (focusMode == true) then
    -- Restore Window's position
    focusedWindow:setFrame(savedFrame)
    
    -- Show All Windows
    focusedWindow:application():selectMenuItem("Show All");
    
    setFocusMode(false);
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

    setFocusMode(true);
    hyper.triggered = true
  end
end)

-- Twitch Mode
-------------------------------------------------------------------------------
-- HyperShift+T - Twitch Mode

TwitchMenuBar = hs.menubar.new()
function setTwitchMode(state)
  if state then
    twitchMode = true;
    TwitchMenuBar:setTitle(hs.styledtext.new("TWITCH", { backgroundColor = { red = 1, blue = 0, green = 0 }, color = { red = 1, blue = 1, green = 1 }}))
  else
    twitchMode = false;
    TwitchMenuBar:setTitle();
  end
end


hs.hotkey.bind(hyperShift, "t", function()
  if (twitchMode == true) then
    setTwitchMode(false);
    hyper.triggered = true
  else 
    setTwitchMode(true);
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

  if nextScreen == hs.screen.mainScreen() then
    return
  end

  focusedWindow:moveToScreen(nextScreen)

  if string.find(nextScreen:name(), "BenQ") then
    grid.setFocusedWindowToCell(areas.custom.center)
  else
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