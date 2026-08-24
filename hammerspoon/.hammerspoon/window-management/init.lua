local grid = require("window-management/grid")
local layouts = require("window-management/layouts")
local helpers = require("window-management/helpers")
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
      grid.setFocusedWindowToCell(grid.areas.custom.finder)
    end
  end)
end


-- MAPPINGS
-------------------------------------------------------------------------------
local areas = grid.areas

-- Patch some hs.window functions for the bug with Chrome Windows
-- https://github.com/Hammerspoon/hammerspoon/issues/3224
local hsWindow = hs.getObjectMetatable("hs.window")
hsWindow.maximize = helpers.withAxHotfix(hsWindow.maximize)
hsWindow.centerOnScreen = helpers.withAxHotfix(hsWindow.centerOnScreen)

-- Margins
Hyper:bind({}, "x", grid.toggleLargeMargins)
--hs.hotkey.bind(hyperShift, "x", layouts.workBrowse)

-- Layouts
Hyper:bind({}, "q", function()
  layouts.workBrowse()
end)
Hyper:bind({ 'shift' }, "q", function()
  layouts.workBrowse(true)
end)

Hyper:bind({}, "w", function()
  layouts.workCode()
end)
Hyper:bind({ 'shift' }, "w", function()
  layouts.workCode(true)
end)

Hyper:bind({}, "e", function()
  layouts.workEven()
end)
Hyper:bind({ 'shift' }, "e", function()
  layouts.workEven(true) -- with focus on Notes
end)

Hyper:bind({}, "r", function()
  layouts.workMax()
end)

Hyper:bind({ 'shift' }, "r", function()
end)


-- Quick Sizes
-------------------------------------------------------------------------------
Hyper:bind({}, "1", function()
  grid.setFocusedWindowToCell(areas.custom.smallLeft)
end)
Hyper:bind({ 'shift' }, "1", function()
  grid.setLargeMargins()
  grid.setFocusedWindowToCell(areas.custom.smallLeft)
  grid.setDefaultMargins()
end)

Hyper:bind({}, "2", function()
  grid.setFocusedWindowToCell(areas.evenSplit.leftFull)
end)
Hyper:bind({ 'shift' }, "2", function()
  grid.setLargeMargins()

  grid.setFocusedWindowToCell(areas.evenSplit.leftFull)
  grid.setDefaultMargins()
end)

Hyper:bind({}, "3", function()
  grid.setFocusedWindowToCell(areas.custom.largeLeft)
end)
Hyper:bind({ 'shift' }, "3", function()
  grid.setLargeMargins()

  grid.setFocusedWindowToCell(areas.custom.largeLeft)

  grid.setDefaultMargins()
end)


Hyper:bind({}, "4", function()
  grid.setFocusedWindowToCell(areas.custom.finder)
end)
Hyper:bind({ 'shift' }, "4", function()
  grid.setFocusedWindowToCell(areas.custom.mini)
end)

Hyper:bind({}, "5", function()
  grid.setFocusedWindowToCell(areas.custom.center)
end)
Hyper:bind({ 'shift' }, "5", function()

end)

Hyper:bind({}, "6", function()
  grid.setFocusedWindowToCell(areas.custom.browser)
end)
Hyper:bind({ 'shift' }, "6", function()
  grid.setFocusedWindowToCell(areas.customTwitch.browser)
end)

Hyper:bind({}, "7", function()
  grid.setFocusedWindowToCell(areas.custom.largeRight)
end)
Hyper:bind({ 'shift' }, "7", function()
  grid.setLargeMargins()
  grid.setFocusedWindowToCell(areas.custom.largeRight)
  grid.setDefaultMargins()
end)

Hyper:bind({}, "8", function()
  grid.setFocusedWindowToCell(areas.evenSplit.rightFull)
end)
Hyper:bind({ 'shift' }, "8", function()
  grid.setLargeMargins()
  grid.setFocusedWindowToCell(areas.evenSplit.rightFull)
  grid.setDefaultMargins()
end)


Hyper:bind({}, "9", function()
  grid.setFocusedWindowToCell(areas.custom.smallRight)
end)
Hyper:bind({ 'shift' }, "9", function()
  grid.setLargeMargins()
  grid.setFocusedWindowToCell(areas.custom.smallRight)
  grid.setDefaultMargins()
end)

Hyper:bind({}, "0", function()
  hsWindow.maximize(hs.window.focusedWindow())
end)

Hyper:bind({ 'shift' }, "0", function()
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

Hyper:bind({}, "a", function()
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
      grid.setFocusedWindowToCell(areas.custom.browser);
    elseif (focusedWindow:application():name() == "Things") or (focusedWindow:application():name() == "Obsidian") then
      grid.setFocusedWindowToCell(areas.custom.finder);
    else
      grid.setFocusedWindowToCell(areas.custom.center);
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
Hyper:bind({}, "c", function()
  local win = hs.window.focusedWindow()
  win:centerOnScreen(nil, true)
  hyper.triggered = true
end)

-- HyperShift+[left, right] - Send and follow window to next/previous space
Hyper:bind({ 'shift' }, "right", nil, function()
  helpers.moveWindowOneSpace('right', true)
end)
Hyper:bind({ 'shift' }, "left", nil, function()
  helpers.moveWindowOneSpace('left', true)
end)

-- Hyper+equal - Send window to next screen.
-- If sending to 4k screen, center the window in it.
-- If sending to the laptop screen, maximize it.
Hyper:bind({}, "=", function()
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


-- Hyper+minus - Switch Primary Screen Resolution between 1440p or 2880p
Hyper:bind({}, "-", function()
  local mainFullMode = {
    width = 2880,
    height = 1620,
    scale = 2,
    frequency = 60,
    depth = 8,
  };
  local mainTwitchMode = {
    width = 2560,
    height = 1440,
    scale = 2,
    frequency = 60,
    depth = 8,
  };

  local currentMode = hs.screen.primaryScreen():currentMode();
  local mainNextMode
  if currentMode.w == mainFullMode.width then
    mainNextMode = mainTwitchMode;
  else
    mainNextMode = mainFullMode;
  end

  hs.screen.primaryScreen():setMode(mainNextMode.width, mainNextMode.height, mainNextMode.scale, mainNextMode.frequency,
    mainNextMode.depth);
end)
