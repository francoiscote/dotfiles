local grid = require("window-management/grid")
local layouts = require("window-management/layouts")
local helpers = require("window-management/helpers")

local hyper = { "cmd", "ctrl", "alt" }
local hyperShift = { "cmd", "ctrl", "alt", "shift" }
local areas = grid.areas
local hsWindow = hs.getObjectMetatable("hs.window")

local toggleFocusMode
local centerFocusedWindow
local maximizeFocusedWindow
local moveFocusedWindowToNextScreen
local togglePrimaryScreenResolution

local rebuildTimer
local chromeRefreshTimer
local chromeWindowFilter

local function scheduleChromeRefresh()
  if chromeRefreshTimer then
    chromeRefreshTimer:stop()
  end
  chromeRefreshTimer = hs.timer.doAfter(1, function()
    if chromeWindowFilter then
      chromeWindowFilter:pause():resume()
    end
  end)
end

local function rebuild()
  local primaryScreen = hs.screen.primaryScreen()
  grid.build(primaryScreen)
  layouts.build(primaryScreen)
end

local function scheduleRebuild()
  if rebuildTimer then
    rebuildTimer:stop()
  end
  rebuildTimer = hs.timer.doAfter(0.5, function()
    rebuild()
    scheduleChromeRefresh()
  end)
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
    grid.withLargeMargins(function()
      grid.setFocusedWindowToCell(area)
    end)
  end
end

local hyperBindings = {
  { hyper, "x", grid.toggleLargeMargins },
  { hyper, "q", layouts.workBrowse },
  { hyperShift, "q", function()
    layouts
        .workBrowse(true)
  end },
  { hyper, "w", layouts.workCode },
  { hyperShift, "w", function()
    layouts
        .workCode(true)
  end },
  { hyper, "e", layouts.workEven },
  { hyperShift, "e", function()
    layouts
        .workEven(true)
  end },
  { hyper,      "r", layouts.workMax },

  { hyper,      "1", setFocusedWindowToArea(areas.custom.smallLeft) },
  { hyperShift, "1", setFocusedWindowToAreaWithLargeMargins(areas.custom.smallLeft) },
  { hyper,      "2", setFocusedWindowToArea(areas.evenSplit.leftFull) },
  { hyperShift, "2", setFocusedWindowToAreaWithLargeMargins(areas.evenSplit.leftFull) },
  { hyper,      "3", setFocusedWindowToArea(areas.custom.largeLeft) },
  { hyperShift, "3", setFocusedWindowToAreaWithLargeMargins(areas.custom.largeLeft) },
  { hyper,      "4", setFocusedWindowToArea(areas.custom.mini) },
  { hyperShift, "4", setFocusedWindowToArea(areas.custom.small) },
  { hyper,      "5", setFocusedWindowToArea(areas.custom.medium) },
  { hyperShift, "5", setFocusedWindowToArea(areas.custom.mediumTall) },
  { hyper,      "6", setFocusedWindowToArea(areas.custom.large) },
  { hyperShift, "6", setFocusedWindowToArea(areas.custom.largeTall) },
  { hyper,      "7", setFocusedWindowToArea(areas.custom.largeRight) },
  { hyperShift, "7", setFocusedWindowToAreaWithLargeMargins(areas.custom.largeRight) },
  { hyper,      "8", setFocusedWindowToArea(areas.evenSplit.rightFull) },
  { hyperShift, "8", setFocusedWindowToAreaWithLargeMargins(areas.evenSplit.rightFull) },
  { hyper,      "9", setFocusedWindowToArea(areas.custom.smallRight) },
  { hyperShift, "9", setFocusedWindowToAreaWithLargeMargins(areas.custom.smallRight) },
  { hyper,      "0", function() maximizeFocusedWindow() end },
  { hyperShift, "0", setFocusedWindowToArea(areas.custom.maximizeAlmost) },

  { hyper,      "a", function() toggleFocusMode() end },
  { hyper,      "c", function() centerFocusedWindow() end },

  -- Mission Control
  { hyper, "up", function()
    hs.spaces.toggleMissionControl()
  end
  },
  { hyper, "down", function()
    hs.spaces.toggleAppExpose()
  end
  },
  { hyper, "=", function() moveFocusedWindowToNextScreen() end },
  { hyper, "-", function() togglePrimaryScreenResolution() end },
}

-- SETTINGS
-------------------------------------------------------------------------------
hs.window.animationDuration = 0
hs.window.setShadows(false)

-- WINDOW WATCHERS
-------------------------------------------------------------------------------
-- Resize new Google Chrome windows, including windows created after Chrome launches.
chromeWindowFilter = hs.window.filter.new({
  ["Google Chrome"] = { rejectTitles = "Picture in Picture" },
})
chromeWindowFilter:subscribe(hs.window.filter.windowCreated, function(window)
  if window:isStandard() then
    grid.setWindowToCell(window, areas.custom.medium)
  end
end)

-- Refresh Chrome tracking after wake, once its accessibility tree is ready.
local chromeWakeWatcher = hs.caffeinate.watcher.new(function(event)
  if event == hs.caffeinate.watcher.systemDidWake
      or event == hs.caffeinate.watcher.screensDidUnlock then
    scheduleChromeRefresh()
  end
end):start()


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
local focusMode = false
local focusModeWindow
local savedFrame

local focusedMenuBar = hs.menubar.new()
local function setFocusMode(state)
  focusMode = state

  if state then
    focusedMenuBar:setTitle(hs.styledtext.new("FOCUSED", {
      backgroundColor = { red = 0, blue = 0, green = 0.7 },
      color = { red = 1, blue = 1, green = 1 },
    }))
  else
    focusedMenuBar:setTitle()
  end
end

toggleFocusMode = function()
  if focusMode then
    if focusModeWindow and savedFrame then
      pcall(function()
        focusModeWindow:setFrame(savedFrame)
      end)
    end

    helpers.unhideAllApps()
    focusModeWindow = nil
    savedFrame = nil
    setFocusMode(false)
    return
  end

  local focusedWindow = hs.window.focusedWindow()
  local focusedApp = focusedWindow and focusedWindow:application()
  if not focusedWindow or not focusedApp then
    return
  end

  focusModeWindow = focusedWindow
  savedFrame = focusedWindow:frame()

  local appName = focusedApp:name()
  if appName == "Google Chrome" then
    grid.setWindowToCell(focusedWindow, areas.custom.large)
  elseif appName == "Things" or appName == "Finder" then
    grid.setWindowToCell(focusedWindow, areas.custom.small)
  else
    grid.setWindowToCell(focusedWindow, areas.custom.medium)
  end

  local allWindows = hs.window.filter.new():setCurrentSpace(true):getWindows()
  for _, window in ipairs(allWindows) do
    local app = window:application()
    local name = app and app:name()
    if app and app ~= focusedApp and name ~= "OBS Studio" and name ~= "Twitch Dashboard" then
      app:hide()
    end
  end

  setFocusMode(true)
end


-- Move Windows
-------------------------------------------------------------------------------
-- C - Center
centerFocusedWindow = function()
  local window = hs.window.focusedWindow()
  if window then
    window:centerOnScreen(nil, true)
  end
end

maximizeFocusedWindow = function()
  local window = hs.window.focusedWindow()
  if window then
    window:maximize()
  end
end

-- Hyper+equal - Send window to next screen.
-- If sending to 4k screen, center the window in it.
-- If sending to the laptop screen, maximize it.
local moveWindowToScreen = helpers.withAxHotfix(function(window, screen)
  window:moveToScreen(screen)

  local screenName = screen:name()
  if not screenName or not string.find(screenName, "Studio Display")
      or not grid.setWindowToCell(window, areas.custom.medium) then
    window:maximize()
  end
end)

moveFocusedWindowToNextScreen = function()
  local window = hs.window.focusedWindow()
  local currentScreen = window and window:screen()
  local nextScreen = currentScreen and currentScreen:next()

  if not window or not nextScreen or nextScreen == currentScreen then
    return
  end

  moveWindowToScreen(window, nextScreen)
end


-- Hyper+minus - Switch Primary Screen Resolution between 1440p or 2880p
togglePrimaryScreenResolution = function()
  local mainFullMode = {
    width = 2880,
    height = 1620,
    scale = 2,
    frequency = 60,
    depth = 8,
  }
  local mainCompactMode = {
    width = 2560,
    height = 1440,
    scale = 2,
    frequency = 60,
    depth = 8,
  }

  local primaryScreen = hs.screen.primaryScreen()
  local currentMode = primaryScreen:currentMode()
  local nextMode = currentMode and currentMode.w == mainFullMode.width and mainCompactMode or mainFullMode

  primaryScreen:setMode(nextMode.width, nextMode.height, nextMode.scale, nextMode.frequency, nextMode.depth)
end

for _, binding in ipairs(hyperBindings) do
  hs.hotkey.bind(binding[1], binding[2], binding[3], binding[4], binding[5])
end

return {
  rebuild = rebuild,
  screenWatcher = screenWatcher,
  chromeWindowFilter = chromeWindowFilter,
  chromeWakeWatcher = chromeWakeWatcher,
}
