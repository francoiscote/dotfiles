local grid = require("window-management/grid")
local layouts = require("window-management/layouts")
local helpers = require("window-management/helpers")
local twitchMode = require("window-management/twitchMode")
local appWatchers = require("app-watchers")
local log = hs.logger.new('WM', 'debug')

-- SETTINGS
-------------------------------------------------------------------------------
hs.window.animationDuration = 0
hs.window.setShadows(false)

-- WINDOW WATCHERS
-------------------------------------------------------------------------------
-- Watch for new Google Chrome Apps and auto resize them
local chromeApp = hs.application.find("Google Chrome")
if chromeApp then
  appWatchers.newWindow(chromeApp, function(app, window)
    if (window:isStandard()) then
      if (twitchMode.isActive() == true) then
        grid.setFocusedWindowToCell(grid.areas.twitch.finder)
      else
        grid.setFocusedWindowToCell(grid.areas.custom.finder)
      end
    end
  end)
end


-- MAPPINGS
-------------------------------------------------------------------------------
local hyper = { "cmd", "alt", "ctrl" }
local hyperShift = { "cmd", "alt", "ctrl", "shift" }
local areas = grid.areas

-- Patch some hs.window functions for the bug with Chrome Windows
-- https://github.com/Hammerspoon/hammerspoon/issues/3224
local hsWindow = hs.getObjectMetatable("hs.window")
hsWindow.maximize = helpers.withAxHotfix(hsWindow.maximize)
hsWindow.centerOnScreen = helpers.withAxHotfix(hsWindow.centerOnScreen)

-- Margins
hs.hotkey.bind(hyper, "x", grid.toggleLargeMargins)
--hs.hotkey.bind(hyperShift, "x", layouts.workBrowse)

-- Layouts
hs.hotkey.bind(hyper, "q", function()
  if (twitchMode.isActive() == true) then
    layouts.twitchBrowseAndCode()
  else
    layouts.workBrowse()
  end
end)
hs.hotkey.bind(hyperShift, "q", function()
  if (twitchMode.isActive() == true) then
    layouts.twitchBrowseAndCode(true)
  else
    layouts.workBrowse(true)
  end
end)

hs.hotkey.bind(hyper, "w", function()
  if (twitchMode.isActive() == true) then
    layouts.twitchCodeEven()
  else
    layouts.workCode()
  end
end)
hs.hotkey.bind(hyperShift, "w", function()
  if (twitchMode.isActive() == true) then
    layouts.twitchCodeEven(true)
  else
    layouts.workCode(true)
  end
end)

hs.hotkey.bind(hyper, "e", function()
  if (twitchMode.isActive() == true) then
    layouts.twitchCodeSmall()
  else
    layouts.workEven()
  end
end)
hs.hotkey.bind(hyperShift, "e", function()
  if (twitchMode.isActive() == true) then
    layouts.twitchCodeSmall(true)
  else
    layouts.workEven(true) -- with focus on Notes
  end
end)

hs.hotkey.bind(hyper, "r", function()
  if (twitchMode.isActive() == true) then
    layouts.twitchMax()
  else
    layouts.workMax()
  end
end)

hs.hotkey.bind(hyperShift, "r", function()
end)

-- Twitch Mode
-------------------------------------------------------------------------------
-- HyperShift+T - Twitch Mode
hs.hotkey.bind(hyperShift, "t", function()
  if (twitchMode.isActive() == true) then
    twitchMode.set(false);
    hyper.triggered = true
  else
    twitchMode.set(true);
    hyper.triggered = true
  end
end)

-- Quick Sizes
-------------------------------------------------------------------------------
hs.hotkey.bind(hyper, "1", function()
  if (twitchMode.isActive() == true) then
    grid.setFocusedWindowToCell(areas.twitch.leftSecondaryMini)
  else
    grid.setFocusedWindowToCell(areas.custom.smallLeft)
  end
end)
hs.hotkey.bind(hyperShift, "1", function()
  grid.setLargeMargins()
  if (twitchMode.isActive() == true) then
    grid.setFocusedWindowToCell(areas.twitch.leftSecondaryMini)
  else
    grid.setFocusedWindowToCell(areas.custom.smallLeft)
  end
  grid.setDefaultMargins()
end)

hs.hotkey.bind(hyper, "2", function()
  if (twitchMode.isActive() == true) then
    grid.setFocusedWindowToCell(areas.twitch.evenLeft)
  else
    grid.setFocusedWindowToCell(areas.evenSplit.leftFull)
  end
end)
hs.hotkey.bind(hyperShift, "2", function()
  grid.setLargeMargins()
  if (twitchMode.isActive() == true) then
    grid.setFocusedWindowToCell(areas.twitch.evenLeft)
  else
    grid.setFocusedWindowToCell(areas.evenSplit.leftFull)
  end
  grid.setDefaultMargins()
end)

hs.hotkey.bind(hyper, "3", function()
  if (twitchMode.isActive() == true) then
    grid.setFocusedWindowToCell(areas.twitch.leftMainBig)
  else
    grid.setFocusedWindowToCell(areas.custom.largeLeft)
  end
end)
hs.hotkey.bind(hyperShift, "3", function()
  grid.setLargeMargins()
  if (twitchMode.isActive() == true) then
    grid.setFocusedWindowToCell(areas.twitch.leftMainBig)
  else
    grid.setFocusedWindowToCell(areas.custom.largeLeft)
  end
  grid.setDefaultMargins()
end)


hs.hotkey.bind(hyper, "4", function()
  if (twitchMode.isActive() == true) then
    grid.setFocusedWindowToCell(areas.twitch.finder)
  else
    grid.setFocusedWindowToCell(areas.custom.finder)
  end
end)
hs.hotkey.bind(hyperShift, "4", function()
  grid.setFocusedWindowToCell(areas.custom.mini)
end)

hs.hotkey.bind(hyper, "5", function()
  if (twitchMode.isActive() == true) then
    grid.setFocusedWindowToCell(areas.twitch.center)
  else
    grid.setFocusedWindowToCell(areas.custom.center)
  end
end)
hs.hotkey.bind(hyperShift, "5", function()

end)

hs.hotkey.bind(hyper, "6", function()
  if (twitchMode.isActive() == true) then
    grid.setFocusedWindowToCell(areas.twitch.browser)
  else
    grid.setFocusedWindowToCell(areas.custom.browser)
  end
end)
hs.hotkey.bind(hyperShift, "6", function()
  grid.setFocusedWindowToCell(areas.customTwitch.browser)
end)

hs.hotkey.bind(hyper, "7", function()
  if (twitchMode.isActive() == true) then
    grid.setFocusedWindowToCell(areas.twitch.rightMainBig)
  else
    grid.setFocusedWindowToCell(areas.custom.largeRight)
  end
end)
hs.hotkey.bind(hyperShift, "7", function()
  grid.setLargeMargins()
  if (twitchMode.isActive() == true) then
    grid.setFocusedWindowToCell(areas.twitch.rightMainBig)
  else
    grid.setFocusedWindowToCell(areas.custom.largeRight)
  end
  grid.setDefaultMargins()
end)

hs.hotkey.bind(hyper, "8", function()
  if (twitchMode.isActive() == true) then
    grid.setFocusedWindowToCell(areas.twitch.evenRight)
  else
    grid.setFocusedWindowToCell(areas.evenSplit.rightFull)
  end
end)
hs.hotkey.bind(hyperShift, "8", function()
  grid.setLargeMargins()
  if (twitchMode.isActive() == true) then
    grid.setFocusedWindowToCell(areas.twitch.evenRight)
  else
    grid.setFocusedWindowToCell(areas.evenSplit.rightFull)
  end
  grid.setDefaultMargins()
end)


hs.hotkey.bind(hyper, "9", function()
  if (twitchMode.isActive() == true) then
    grid.setFocusedWindowToCell(areas.twitch.rightSecondaryMini)
  else
    grid.setFocusedWindowToCell(areas.custom.smallRight)
  end
end)
hs.hotkey.bind(hyperShift, "9", function()
  grid.setLargeMargins()
  if (twitchMode.isActive() == true) then
    grid.setFocusedWindowToCell(areas.twitch.rightSecondaryMini)
  else
    grid.setFocusedWindowToCell(areas.custom.smallRight)
  end
  grid.setDefaultMargins()
end)

hs.hotkey.bind(hyper, "0", function()
  if (twitchMode.isActive() == true) then
    grid.setFocusedWindowToCell(areas.twitch.maximize)
  else
    hsWindow.maximize(hs.window.focusedWindow())
  end
end)

hs.hotkey.bind(hyperShift, "0", function()
  grid.setFocusedWindowToCell(areas.custom.maximizeAlmost)
end)

-- Focus Mode
-------------------------------------------------------------------------------
-- Hyper+A - Focus Mode
-- Center the focused Window and Hide Others
-- the key act as a toggle between focus mode and the previously used layout
local focusMode = false;
local focusedWindow;
local savedFrame;

local focusedMenuBar = hs.menubar.new()
local function setFocusMode(state)
  if state then
    focusMode = true;
    focusedMenuBar:setTitle(hs.styledtext.new("FOCUSED",
      { backgroundColor = { red = 0, blue = 0, green = 0.7 }, color = { red = 1, blue = 1, green = 1 } }))
    -- focusedMenuBar:setTitle("FOCUSED");
  else
    focusMode = false;
    focusedMenuBar:setTitle();
  end
end

hs.hotkey.bind(hyper, "a", function()
  local focusedWindow = hs.window.focusedWindow()
  local focusedApp = focusedWindow:application()

  if (focusMode == true) then
    -- Restore Window's position
    focusedWindow:setFrame(savedFrame)

    -- Show All Windows
    focusedWindow:application():selectMenuItem("Show All");

    setFocusMode(false);
    hyper.triggered = true
  else
    -- Save focused window and its position
    savedFrame = focusedWindow:frame()

    -- Center Window
    -- Different layouts for different apps
    if (focusedWindow:application():name() == "Google Chrome") then
      if (twitchMode.isActive() == true) then
        grid.setFocusedWindowToCell(areas.twitch.center);
      else
        grid.setFocusedWindowToCell(areas.custom.browser);
      end
    elseif (focusedWindow:application():name() == "Things") or (focusedWindow:application():name() == "Obsidian") then
      if (twitchMode.isActive() == true) then
        grid.setFocusedWindowToCell(areas.twitch.center);
      else
        grid.setFocusedWindowToCell(areas.custom.finder);
      end
    else
      if (twitchMode.isActive() == true) then
        grid.setFocusedWindowToCell(areas.twitch.center);
      else
        grid.setFocusedWindowToCell(areas.custom.center);
      end
    end

    -- Hide all other apps.
    local allWindows = hs.window.filter.new():setCurrentSpace(true):getWindows()
    for i, w in pairs(allWindows) do
      local winApp = w:application()
      if (winApp ~= focusedApp) then
        if (winApp:name() ~= "OBS Studio" and winApp:name() ~= "Twitch Dashboard") then
          winApp:hide()
        end
      end
    end

    setFocusMode(true);
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

  local revert = axHotfix(focusedWindow)
  focusedWindow:moveToScreen(nextScreen)

  if string.find(nextScreen:name(), "BenQ") then
    grid.setFocusedWindowToCell(areas.custom.center)
  else
    focusedWindow:maximize()
  end
  revert()
end)

-- HyperShift+[left, right] - Send and follow window to next/previous space
hs.hotkey.bind(hyperShift, "right", nil, function()
  helpers.moveWindowOneSpace('right', true)
end)
hs.hotkey.bind(hyperShift, "left", nil, function()
  helpers.moveWindowOneSpace('left', true)
end)
