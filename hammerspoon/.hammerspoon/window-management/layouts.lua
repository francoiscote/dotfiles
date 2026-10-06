local export = {}
local grid = require("window-management/grid")
local helpers = require("window-management/helpers")

local areas = grid.areas
local layoutScreen

-- Fixed sizes in Hammerspoon screen coordinates (points on Retina displays).
-- Origins are relative to the usable screen's top-left. No grid or margins.
export.twitchAreas = {
  main = { x = 640, y = 0, w = 1280, h = 1080 },
  secondaryTop = { x = 0, y = 0, w = 640, h = 540 },
  secondaryBottom = { x = 0, y = 540, w = 640, h = 540 },
}

local setFrame = helpers.withAxHotfix(function(window, frame)
  window:setFrame(frame, 0)
end)

local function setFilteredWindowsToPixelArea(windowFilter, area)
  local screen = layoutScreen or hs.screen.primaryScreen()
  local origin = screen:frame()
  local frame = hs.geometry.rect(origin.x + area.x, origin.y + area.y, area.w, area.h)

  for _, window in ipairs(windowFilter:getWindows()) do
    local windowScreen = window:screen()
    if windowScreen and windowScreen:id() == screen:id() then
      setFrame(window, frame)
    end
  end
end

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
  layoutScreen = screen or hs.screen.primaryScreen()
  local screenName = layoutScreen:name()
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

function export.twitch()
  setFilteredWindowsToPixelArea(editors, export.twitchAreas.main)
  setFilteredWindowsToPixelArea(figma, export.twitchAreas.main)
  setFilteredWindowsToPixelArea(browsers, export.twitchAreas.secondaryTop)
  setFilteredWindowsToPixelArea(terminals, export.twitchAreas.secondaryBottom)
  setFilteredWindowsToPixelArea(notes, export.twitchAreas.secondaryBottom)
  setFilteredWindowsToPixelArea(obs, export.twitchAreas.secondaryBottom)
  setFilteredWindowsToPixelArea(obs, export.twitchAreas.secondaryBottom)
end

function export.workMax()
  helpers.maximiseFilteredWindows(editors)
  helpers.maximiseFilteredWindows(figma)
  helpers.maximiseFilteredWindows(terminals)
  helpers.maximiseFilteredWindows(browsers)
  helpers.maximiseFilteredWindows(notes)
  -- grid.setFilteredWindowsToCell(terminals, areas.custom.medium)
  -- grid.setFilteredWindowsToCell(browsers, areas.custom.large)
  -- grid.setFilteredWindowsToCell(notes, areas.custom.small)
end

return export
