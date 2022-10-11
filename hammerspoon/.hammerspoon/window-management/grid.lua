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

local defaultMargins = gapSize .. 'x' .. gapSize
local largeMargins = helpers.getDynamicMargins(0.02, 0.04)
local extraLargeMargins = helpers.getDynamicMargins(0.03, 0.07)

local hsGrid = hs.grid.setGrid('12x12', mainScreen, frame).setMargins(defaultMargins)

local areas = {
  smallSplit = {
    secondaryFull = '0,0 4x12',
    secondaryTop = '0,0 4x5',
    secondaryBottom = '0,5 4x7',
    main = '4,0 8x12',
  }, 
  mediumSplit = {
    secondaryFull = '0,0 5x12',
    secondaryTop = '0,0 5x6',
    secondaryBottom = '0,6 5x6',
    main = '5,0 7x12',
  },
  evenSplit = {
    leftFull = '0,0 6x12',
    leftTop = '0,0 6x5',
    leftBottom = '0,6 6x5',
    rightFull = '6,0 6x12',
    rightTop = '6,0 6x5',
    rightBottom = '6,6 6x5',
  },
  tripleSplit = {
    leftFull = '0,0 4x12',
    leftTop = '0,0 4x6',
    leftBottom = '0,6 4x6',
    mainFull = '4,0 4x12',
    mainTop = '4,0 4x5',
    mainBottom = '4,5 4x7',
    rightFull = '8,0 4x12',
    rightTop = '8,0 4x6',
    rightBottom = '8,6 4x6',
  },
  custom = {
    finder = '3,2 4x6',
    center = '2,1 8x10',
    browser = '2,0 8x12'
  },
  customTwitch = {
    finder = '2,1.5 3x4',
    spotify = '0.5,0.5 6x7',
    browser = '1,0 5x8'
  }
}

-- FUNCTIONS
-----------------------------------------------------------------------------
function setDefaultMargins() 
  hsGrid.setMargins(defaultMargins)
end

function setLargeMargins() 
  hsGrid.setMargins(largeMargins)
end

function setExtraLargeMargins() 
  hsGrid.setMargins(extraLargeMargins)
end

function setWindowsToCell(windows, cell)
  for i,w in pairs(windows) do
    hsGrid.set(w, cell)
  end
end

function setFilteredWindowsToCell(wf, cell)
  local windows = wf:getWindows()
  setWindowsToCell(windows, cell)
end

function setFocusedWindowToCell(cell)
  local win = hs.window.focusedWindow()
  hsGrid.set(win, cell)
end

-- EXPORT
-----------------------------------------------------------------------------

local export = {
  hsGrid = hsGrid,
  areas = areas,
  setDefaultMargins = setDefaultMargins,
  setLargeMargins = setLargeMargins,
  setExtraLargeMargins = setExtraLargeMargins,
  setWindowsToCell = setWindowsToCell,
  setFilteredWindowsToCell = setFilteredWindowsToCell,
  setFocusedWindowToCell = setFocusedWindowToCell
}

return export
