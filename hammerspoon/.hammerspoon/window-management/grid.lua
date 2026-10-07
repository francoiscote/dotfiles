local helpers = require("window-management/helpers")
local twitchMode = require("twitch-mode")
local twitchAreas = require("window-management/twitch-areas")

-- SETTINGS
-------------------------------------------------------------------------------
local gapSize = 10
local menuGapSize = 0

-- GRID
-------------------------------------------------------------------------------
local isLargeMargins = false
local defaultMargins = gapSize .. "x" .. gapSize
local largeMargins
local gridScreenID

local hsGrid = hs.grid
local patchedGridSet = helpers.withAxHotfix(hsGrid.set)
local patchedSetFrame = helpers.withAxHotfix(function(window, frame)
  window:setFrame(frame, 0)
end)

local areas = {
  smallSplit = {
    main = "5,0 7x12",
    secondaryFull = "0,0 5x12",
    secondaryTop = "0,0 5x5.5",
    secondaryBottom = "0,5.5 5x6.5",
  },
  smallSplitInverted = {
    main = "0,0 7x12",
    secondaryFull = "7,0 5x12",
    secondaryTop = "7,0 5x5.5",
    secondaryBottom = "7,5.5 5x6.5",
  },
  mediumSplit = {
    secondaryFull = "0,0 5x12",
    main = "5,0 7x12",
  },
  mediumSplitInverted = {
    secondaryFull = "7,0 5x12",
    main = "0,0 7x12",
  },
  evenSplit = {
    leftFull = "0,0 6x12",
    rightFull = "6,0 6x12",
  },
  custom = {
    smallLeft = "0,0 4x12",
    largeLeft = "0,0 7x12",
    mini = "3,2 6x8",
    small = "2.5,1.5 7x9",
    medium = "2,1 8x10",
    mediumTall = "2,0 8x12",
    large = "1,0.5 10x11",
    largeTall = "1,0 10x12",
    largeRight = "5,0 7x12",
    smallRight = "8,0 4x12",
    maximizeAlmost = "2,0 10x12",
  },
}

-- FUNCTIONS
-------------------------------------------------------------------------------
local function build(screen)
  screen = screen or hs.screen.primaryScreen()
  local frame

  if menuGapSize > 0 then
    local screenFrame = screen:frame()
    frame = hs.geometry(
      screenFrame.x,
      screenFrame.y + menuGapSize,
      screenFrame.w,
      screenFrame.h - menuGapSize
    )
  end

  gridScreenID = screen:id()
  largeMargins = helpers.getDynamicMargins(0.02, 0.04, screen)
  hsGrid.setGrid("12x12", screen, frame)
  hsGrid.setMargins(isLargeMargins and largeMargins or defaultMargins)
end

local marginsMenuBar = hs.menubar.new()
local function toggleLargeMargins()
  isLargeMargins = not isLargeMargins
  hsGrid.setMargins(isLargeMargins and largeMargins or defaultMargins)

  if isLargeMargins then
    marginsMenuBar:setTitle(hs.styledtext.new("LARGE", {
      backgroundColor = { red = 0.1, blue = 0, green = 0.7 },
      color = { red = 1, blue = 1, green = 1 },
    }))
  else
    marginsMenuBar:setTitle()
  end
end

local function withLargeMargins(callback)
  hsGrid.setMargins(largeMargins)
  local ok, err = xpcall(callback, debug.traceback)
  hsGrid.setMargins(isLargeMargins and largeMargins or defaultMargins)

  if not ok then
    error(err, 0)
  end
end

local function setWindowToCell(window, cell, area)
  local screen = window and window:screen()
  if not screen or screen:id() ~= gridScreenID then
    return false
  end

  if area then
    local x, y, w, h = cell:match("^([%d%.]+),([%d%.]+) ([%d%.]+)x([%d%.]+)$")
    assert(x, "Invalid grid cell: " .. tostring(cell))
    local origin = screen:frame()
    patchedSetFrame(window, hs.geometry.rect(
      origin.x + area.x + tonumber(x) * area.w / 12,
      origin.y + area.y + tonumber(y) * area.h / 12,
      tonumber(w) * area.w / 12,
      tonumber(h) * area.h / 12
    ))
  else
    patchedGridSet(window, cell)
  end
  return true
end

local function setWindowsToCell(windows, cell, area)
  for _, window in ipairs(windows) do
    setWindowToCell(window, cell, area)
  end
end

local function setFilteredWindowsToCell(windowFilter, cell, area)
  setWindowsToCell(windowFilter:getWindows(), cell, area)
end

local function setFocusedWindowToCell(cell)
  local area = twitchMode.isEnabled() and twitchAreas.main or nil
  return setWindowToCell(hs.window.focusedWindow(), cell, area)
end

return {
  areas = areas,
  build = build,
  toggleLargeMargins = toggleLargeMargins,
  withLargeMargins = withLargeMargins,
  setWindowToCell = setWindowToCell,
  setWindowsToCell = setWindowsToCell,
  setFilteredWindowsToCell = setFilteredWindowsToCell,
  setFocusedWindowToCell = setFocusedWindowToCell,
}
