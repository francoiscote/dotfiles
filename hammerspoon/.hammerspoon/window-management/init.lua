local grid = require("window-management/grid")
local layouts = require("window-management/layouts")
local helpers = require("window-management/helpers")
local appWatchers = require("app-watchers")

local hyper = spoon.Hyper
local areas = grid.areas
local hsWindow = hs.getObjectMetatable("hs.window")

local toggleFocusMode
local centerFocusedWindow
local moveFocusedWindowToNextScreen
local togglePrimaryScreenResolution

local rebuildTimer
local function rebuild()
  local primaryScreen = hs.screen.primaryScreen()
  grid.build(primaryScreen)
  layouts.build(primaryScreen)
end

local function scheduleRebuild()
  if rebuildTimer then
    rebuildTimer:stop()
  end
  rebuildTimer = hs.timer.doAfter(0.5, rebuild)
end

local screenWatcher = hs.screen.watcher.new(scheduleRebuild):start()
rebuild()

local function setFocusedWindowToArea(area)
  return function()
    grid.setFocusedWindowToCell(area)
  end
end

local function setFocusedWindowToAreaWithLargeMargins(area)
  return function()
    grid.setLargeMargins()
    grid.setFocusedWindowToCell(area)
    grid.setDefaultMargins()
  end
end

local hyperBindings = {
  { {}, "x", grid.toggleLargeMargins },
  { {}, "q", layouts.workBrowse },
  { { "shift" }, "q", function()
    layouts
        .workBrowse(true)
  end },
  { {}, "w", layouts.workCode },
  { { "shift" }, "w", function()
    layouts
        .workCode(true)
  end },
  { {}, "e", layouts.workEven },
  { { "shift" }, "e", function()
    layouts
        .workEven(true)
  end },
  { {},          "r", layouts.workMax },

  { {},          "1", setFocusedWindowToArea(areas.custom.smallLeft) },
  { { "shift" }, "1", setFocusedWindowToAreaWithLargeMargins(areas.custom.smallLeft) },
  { {},          "2", setFocusedWindowToArea(areas.evenSplit.leftFull) },
  { { "shift" }, "2", setFocusedWindowToAreaWithLargeMargins(areas.evenSplit.leftFull) },
  { {},          "3", setFocusedWindowToArea(areas.custom.largeLeft) },
  { { "shift" }, "3", setFocusedWindowToAreaWithLargeMargins(areas.custom.largeLeft) },
  {
    {}, "4", {
    setFocusedWindowToArea(areas.custom.mini),
    setFocusedWindowToArea(areas.custom.small),
  },
  },
  {
    {}, "5", {
    setFocusedWindowToArea(areas.custom.medium),
    setFocusedWindowToArea(areas.custom.mediumTall),
  },
  },
  {
    {}, "6", {
    setFocusedWindowToArea(areas.custom.large),
    setFocusedWindowToArea(areas.custom.largeTall),
  },
  },
  { {},          "7", setFocusedWindowToArea(areas.custom.largeRight) },
  { { "shift" }, "7", setFocusedWindowToAreaWithLargeMargins(areas.custom.largeRight) },
  { {},          "8", setFocusedWindowToArea(areas.evenSplit.rightFull) },
  { { "shift" }, "8", setFocusedWindowToAreaWithLargeMargins(areas.evenSplit.rightFull) },
  { {},          "9", setFocusedWindowToArea(areas.custom.smallRight) },
  { { "shift" }, "9", setFocusedWindowToAreaWithLargeMargins(areas.custom.smallRight) },
  { {},          "0", function() hsWindow.maximize(hs.window.focusedWindow()) end },
  { { "shift" }, "0", setFocusedWindowToArea(areas.custom.maximizeAlmost) },

  { {},          "a", function() toggleFocusMode() end },
  { {},          "c", function() centerFocusedWindow() end },

  -- Mission Control
  { {}, "up", function()
    hs.spaces.toggleMissionControl()
  end
  },
  { {}, "down", function()
    hs.spaces.toggleShowDesktop()
  end
  },
  { {}, "=", function() moveFocusedWindowToNextScreen() end },
  { {}, "-", function() togglePrimaryScreenResolution() end },
}

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
      grid.setFocusedWindowToCell(grid.areas.custom.medium)
    end
  end)
end


-- MAPPINGS
-------------------------------------------------------------------------------
-- Patch some hs.window functions for the bug with Chrome Windows
-- https://github.com/Hammerspoon/hammerspoon/issues/3224
hsWindow.maximize = helpers.withAxHotfix(hsWindow.maximize)
hsWindow.centerOnScreen = helpers.withAxHotfix(hsWindow.centerOnScreen)

-- Focus Mode
-------------------------------------------------------------------------------
-- Hyper+A - Focus Mode
-- Center the focused Window and Hide Others
-- the key act as a toggle between focus mode and the previously used layout
local focusMode = false;
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

toggleFocusMode = function()
  local focusedWindow = hs.window.focusedWindow()
  local focusedApp = focusedWindow:application()

  if (focusMode == true) then
    -- Restore Window's position
    focusedWindow:setFrame(savedFrame)

    -- Show All Windows
    focusedWindow:application():selectMenuItem("Show All");

    setFocusMode(false);
  else
    -- Save focused window and its position
    savedFrame = focusedWindow:frame()

    -- Center Window
    -- Different layouts for different apps
    if (focusedWindow:application():name() == "Google Chrome") then
      grid.setFocusedWindowToCell(areas.custom.large);
    elseif (focusedWindow:application():name() == "Things") or (focusedWindow:application():name() == "Finder") then
      grid.setFocusedWindowToCell(areas.custom.small);
    else
      grid.setFocusedWindowToCell(areas.custom.medium);
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
  end
end


-- Move Windows
-------------------------------------------------------------------------------
-- C - Center
centerFocusedWindow = function()
  local win = hs.window.focusedWindow()
  win:centerOnScreen(nil, true)
end

-- Hyper+equal - Send window to next screen.
-- If sending to 4k screen, center the window in it.
-- If sending to the laptop screen, maximize it.
moveFocusedWindowToNextScreen = function()
  -- Get the focused window, its window frame dimensions, its screen frame dimensions,
  -- and the next screen's frame dimensions.
  local focusedWindow = hs.window.focusedWindow()
  local nextScreen = focusedWindow:screen():next()

  if nextScreen == hs.screen.mainScreen() then
    return
  end

  local revert = helpers.axHotfix(focusedWindow)
  focusedWindow:moveToScreen(nextScreen)
  local nextScreenName = nextScreen:name()

  if nextScreenName and string.find(nextScreenName, "Studio Display") then
    grid.setFocusedWindowToCell(areas.custom.medium)
  else
    focusedWindow:maximize()
  end
  revert()
end


-- Hyper+minus - Switch Primary Screen Resolution between 1440p or 2880p
togglePrimaryScreenResolution = function()
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
  if currentMode and currentMode.w == mainFullMode.width then
    mainNextMode = mainTwitchMode;
  else
    mainNextMode = mainFullMode;
  end

  hs.screen.primaryScreen():setMode(mainNextMode.width, mainNextMode.height, mainNextMode.scale, mainNextMode.frequency,
    mainNextMode.depth);
end

for _, binding in ipairs(hyperBindings) do
  if type(binding[3]) == "table" then
    hyper:bindSequence(binding[1], binding[2], binding[3])
  else
    hyper:bind(binding[1], binding[2], binding[3], binding[4], binding[5])
  end
end

return {
  rebuild = rebuild,
  screenWatcher = screenWatcher,
}
