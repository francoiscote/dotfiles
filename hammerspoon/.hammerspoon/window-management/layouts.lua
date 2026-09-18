local export = {}
local grid = require("window-management/grid")
local helpers = require("window-management/helpers")

local areas = grid.areas

-- FILTERS
-------------------------------------------------------------------------------
local windowFilter = hs.window.filter
local browsers = windowFilter.new({
  Arc = true,
  Safari = true,
  ["Firefox Developer Edition"] = true,
  ["Google Chrome"] = { rejectTitles = "Picture in Picture" },
}):setCurrentSpace(true)
local editors = windowFilter.new({ Code = true, Zed = true }):setCurrentSpace(true)
local terminals = windowFilter.new({ "iTerm2", "Ghostty" }):setCurrentSpace(true)
local notes = windowFilter.new({ "Notion", "Obsidian", "Bear" }):setCurrentSpace(true)
local figma = windowFilter.new({ "Figma" }):setCurrentSpace(true)
local obs = windowFilter.new({ "OBS Studio" }):setCurrentSpace(true)

local primaryScreenFilters = {
  browsers,
  editors,
  terminals,
  notes,
  figma,
  obs,
}

function export.build(screen)
  local screenName = (screen or hs.screen.primaryScreen()):name()
  for _, filter in ipairs(primaryScreenFilters) do
    filter:setScreens(screenName)
  end
end

-- LAYOUTS
-------------------------------------------------------------------------------
function export.workBrowse(inverted)
  local layout = inverted and areas.smallSplitInverted or areas.smallSplit

  grid.setFilteredWindowsToCell(browsers, layout.main)
  grid.setFilteredWindowsToCell(editors, layout.main)
  grid.setFilteredWindowsToCell(figma, layout.main)
  grid.setFilteredWindowsToCell(terminals, layout.secondaryFull)
  grid.setFilteredWindowsToCell(notes, layout.secondaryFull)
  grid.setFilteredWindowsToCell(obs, layout.secondaryFull)
end

function export.workCode(inverted)
  local layout = inverted and areas.mediumSplitInverted or areas.mediumSplit

  grid.setFilteredWindowsToCell(editors, layout.main)
  grid.setFilteredWindowsToCell(figma, layout.main)
  grid.setFilteredWindowsToCell(terminals, layout.main)
  grid.setFilteredWindowsToCell(browsers, layout.secondaryFull)
  grid.setFilteredWindowsToCell(notes, layout.secondaryFull)
  grid.setFilteredWindowsToCell(obs, layout.secondaryFull)
end

function export.workEven(mainNotes)
  if mainNotes then
    grid.setFilteredWindowsToCell(browsers, areas.evenSplit.leftFull)
    grid.setFilteredWindowsToCell(terminals, areas.evenSplit.leftFull)
    grid.setFilteredWindowsToCell(editors, areas.evenSplit.leftFull)
    grid.setFilteredWindowsToCell(figma, areas.evenSplit.leftFull)
    grid.setFilteredWindowsToCell(notes, areas.evenSplit.rightFull)
  else
    grid.setFilteredWindowsToCell(notes, areas.evenSplit.leftFull)
    grid.setFilteredWindowsToCell(browsers, areas.evenSplit.leftFull)
    grid.setFilteredWindowsToCell(terminals, areas.evenSplit.leftFull)
    grid.setFilteredWindowsToCell(figma, areas.evenSplit.rightFull)
    grid.setFilteredWindowsToCell(editors, areas.evenSplit.rightFull)
  end
end

function export.workMax()
  helpers.maximiseFilteredWindows(editors)
  helpers.maximiseFilteredWindows(figma)
  grid.setFilteredWindowsToCell(terminals, areas.custom.medium)
  grid.setFilteredWindowsToCell(browsers, areas.custom.large)
  grid.setFilteredWindowsToCell(notes, areas.custom.small)
end

return export
