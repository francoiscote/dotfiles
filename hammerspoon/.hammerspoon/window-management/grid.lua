helpers = require("window-management/helpers")

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
    secondaryFull = '0,0 4x12',
    secondaryTop = '0,0 4x4.3',
    secondaryBottom = '0,4.3 4x7.7',
    main = '4,0 8x12',
  },
  smallSplitInverted = {
    secondaryFull = '8,0 4x12',
    secondaryTop = '8,0 4x4.3',
    secondaryBottom = '8,4.3 4x7.7',
    main = '0,0 8x12',
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
    largeLeft = '0,0 8x12',
    finder = '3,2 6x8',
    center = '2,1 8x10',
    twitchCenter = '0,0 7x8',
    browser = '3,0 6x12',
    largeRight = '4,0 8x12',
    smallRight = '8,0 4x12',
    maximize = '0,0 12x12'
  },
  twitch = {
    hiddenRight = '9,0 3x12',
    hiddenRightTop = '9,0 3x3.3',
    hiddenRightBottom = '9,3.3 3x8.7',
    hiddenBottom = '0,9 9x3',
    leftSecondaryMini = '0,0 3x9',
    leftSecondary = '0,0 4x9',
    leftMainBig = '0,0 6x9',
    leftMain = '0,0 5x9',
    rightMain = '4,0 5x9',
    rightMainBig = '3,0 6x9',
    rightSecondary = '5,0 4x9',
    rightSecondaryMini = '6,0 3x9',
    evenLeft = '0,0 4.5x9',
    evenRight = '4.5,0 4.5x9',
    maximize = '0,0 9x9',
    finder = '2.5,2 4x5',
    center = '1,0.5 7x8',
    browser = '1.5,0 6x9',
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
