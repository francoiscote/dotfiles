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

local hsGrid = hs.grid.setGrid('10x10', mainScreen, frame).setMargins(defaultMargins)

local areas = {
  seventySplit = {
    center = '2,1 6x8',
    leftMain = '0,0 7x10',
    leftSecondaryFull = '0,0 3x10',
    leftSecondaryTop = '0,0 3x3',
    leftSecondaryBottom = '0,3 3x7',
    rightMain = '3,0 7x10',
    rightSecondaryFull = '7,0 3x10',
    rightSecondaryTop = '7,0 3x3',
    rightSecondaryBottom = '7,3 3x7',
  },
  sixtySplit = {
    leftMain = '0,0 6x10',
    leftSecondaryFull = '0,0 4x10',
    leftSecondaryTop = '0,0 4x4',
    leftSecondaryBottom = '0,4 4x6',
    rightMain = '4,0 6x10',
    rightSecondaryFull = '6,0 4x10',
    rightSecondaryTop = '6,0 4x4',
    rightSecondaryBottom = '6,4 4x6',
  }, 
  evenSplit = {
    leftFull = '0,0 5x10',
    leftTop = '0,0 5x5',
    leftBottom = '0,5 5x5',
    rightFull = '5,0 5x10',
    rightTop = '5,0 5x5',
    rightBottom = '5,5 5x5',
    center = '2,1 6x8'
  },
  custom = {
    finder = '3,2 4x6',
    spotify = '2,1 6x8',
    browser = '2,0 6x10'
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
