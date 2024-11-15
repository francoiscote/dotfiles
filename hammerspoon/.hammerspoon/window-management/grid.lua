local helpers = require("window-management/helpers")

-- SETTINGS
-------------------------------------------------------------------------------
local gapSize = 10
local menuGapSize = 0

-- GRID
-------------------------------------------------------------------------------
local mainScreen = hs.screen.mainScreen()
local frame = nil

if menuGapSize > 0 then
  local max = mainScreen:frame()
  frame = hs.geometry(0, menuGapSize, max.w, max.h - menuGapSize)
end

local isLargeMargins = false;
local defaultMargins = gapSize .. 'x' .. gapSize
local largeMargins = helpers.getDynamicMargins(0.02, 0.04)

local hsGrid = hs.grid.setGrid('12x12', mainScreen, frame).setMargins(defaultMargins)
local patchedGridSet = helpers.withAxHotfix(hsGrid.set)

local areas = {
  smallSplit = {
    main = '4,0 8x12',
    secondaryFull = '0,0 4x12',
    secondaryTop = '0,0 4x4.3',
    secondaryBottom = '0,4.3 4x7.7',
  },
  smallSplitInverted = {
    main = '0,0 8x12',
    secondaryFull = '8,0 4x12',
    secondaryTop = '8,0 4x4.3',
    secondaryBottom = '8,4.3 4x7.7'
  },
  mediumSplit = {
    secondaryFull = '0,0 5x12',
    secondaryTop = '0,0 5x5.35',
    secondaryBottom = '0,5.35 5x6.65',
    main = '5,0 7x12',
  },
  mediumSplitInverted = {
    secondaryFull = '7,0 5x12',
    secondaryTop = '7,0 5x5.35',
    secondaryBottom = '7,5.35 5x6.65',
    main = '0,0 7x12',
  },
  evenSplit = {
    leftFull = '0,0 6x12',
    leftTop = '0,0 6x5',
    leftBottom = '0,6 6x5',
    rightFull = '6,0 6x12',
    rightTop = '6,0 6x5',
    rightBottom = '6,6 6x5',
  },
  custom = {
    smallLeft = '0,0 4x12',
    smallLeftBottom = '0,4.3 4x7.7',
    largeLeft = '0,0 8x12',
    mini = '4,3 4x6',
    finder = '3,2 6x8',
    center = '2,1 8x10',
    browser = '2,0 8x12',
    largeRight = '4,0 8x12',
    smallRight = '8,0 4x12',
    smallRightBottom = '8,4.3 4x7.7',
    maximizeAlmost = '2,0 10x12',
    maximize = '0,0 12x12'
  },
  twitch = {
    hiddenSide = '0,0 3x12',
    hiddenSideTop = '0,0 3x7',
    hiddenSideBottom = '0,7 3x5',
    leftSecondaryMini = '3,0 3x12',
    leftSecondary = '3,0 4x12',
    leftMainBig = '3,0 6x12',
    leftMain = '3,0 5x12',
    rightMain = '7,0 5x12',
    rightMainBig = '6,0 6x12',
    rightSecondary = '8,0 4x12',
    rightSecondaryMini = '9,0 3x12',
    evenLeft = '3,0 4.5x12',
    evenRight = '7.5,0 4.5x12',
    maximize = '3,0 9x12',
    finder = '4,2 7x8',
    center = '4,1 7x10',
    browser = '4.5,0 6x12',
  },
}


-- FUNCTIONS
-----------------------------------------------------------------------------
function setNoMargins()
  hsGrid.setMargins('0x0')
end

function setDefaultMargins()
  hsGrid.setMargins(defaultMargins)
end

function setLargeMargins()
  hsGrid.setMargins(largeMargins)
end

local marginsMenuBar = hs.menubar.new()
function toggleLargeMargins()
  if isLargeMargins then
    isLargeMargins = false;
    hsGrid.setMargins(defaultMargins)
    marginsMenuBar:setTitle();
  else
    isLargeMargins = true;
    hsGrid.setMargins(largeMargins)
    marginsMenuBar:setTitle(hs.styledtext.new("LARGE",
      { backgroundColor = { red = 0.1, blue = 0, green = 0.7 }, color = { red = 1, blue = 1, green = 1 } }))
  end
end

function setWindowsToCell(windows, cell)
  for i, w in pairs(windows) do
    patchedGridSet(w, cell)
  end
end

function setFilteredWindowsToCell(wf, cell)
  local windows = wf:getWindows()
  setWindowsToCell(windows, cell)
end

function setFocusedWindowToCell(cell)
  local win = hs.window.focusedWindow()
  patchedGridSet(win, cell)
end

-- EXPORT
-----------------------------------------------------------------------------

local export = {
  hsGrid = hsGrid,
  areas = areas,
  setNoMargins = setNoMargins,
  setDefaultMargins = setDefaultMargins,
  setLargeMargins = setLargeMargins,
  toggleLargeMargins = toggleLargeMargins,
  setWindowsToCell = setWindowsToCell,
  setFilteredWindowsToCell = setFilteredWindowsToCell,
  setFocusedWindowToCell = setFocusedWindowToCell
}

return export
