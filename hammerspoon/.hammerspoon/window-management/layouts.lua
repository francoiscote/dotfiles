local export = {}
local grid = require("window-management/grid")
local helpers = require("window-management/helpers")
local twitchMode = require("twitch-mode")

local areas = grid.areas
local layoutScreen

export.twitchAreas = require("window-management/twitch-areas")

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
local videos = windowFilter.new { ['YouTube'] = true, ['Twitch'] = true, ['Google Meet'] = true, ['zoom.us'] = true, ['VLC'] = true, ['Vial'] = true, ['Google Chrome'] = { allowTitles = 'Picture in Picture' }, ['OBS Studio'] = { allowTitles = '(.*)Windowed Projector(.*)' }, ['Arc'] = { allowRoles = 'AXSystemDialog' }, ['Slack'] = { allowTitles = '(.*)Huddle$' }, ['Oryx'] = true }
local editors = windowFilter.new({ Code = true, Zed = true }):setCurrentSpace(true)
local terminals = windowFilter.new({ "iTerm2", "Ghostty" }):setCurrentSpace(true)
local todos = windowFilter.new({ "Linear" }):setCurrentSpace(true)
local notes = windowFilter.new({ "Notion", "Obsidian", "Bear" }):setCurrentSpace(true)
local figma = windowFilter.new({ "Figma" }):setCurrentSpace(true)
local obs = windowFilter.new({ "OBS Studio" }):setCurrentSpace(true)
local dashboard = windowFilter.new({ "Twitch - Dashboard" }):setCurrentSpace(true)

local primaryScreenFilters = {
  browsers,
  editors,
  terminals,
  todos,
  notes,
  figma,
  obs,
  dashboard,
  videos
}

local function hasVideo()
  return #videos:getWindows() > 0
end

local function pinTwitchWindows()
  if twitchMode.isEnabled() then
    setFilteredWindowsToPixelArea(obs, export.twitchAreas.secondaryBottom)
    setFilteredWindowsToPixelArea(dashboard, export.twitchAreas.secondaryRight)
  end
end

local function setLayoutWindows(windowFilter, cell)
  if twitchMode.isEnabled() then
    if windowFilter ~= obs then
      grid.setFilteredWindowsToCell(windowFilter, cell, export.twitchAreas.main)
    end
  else
    grid.setFilteredWindowsToCell(windowFilter, cell)
  end
end

function export.build(screen)
  layoutScreen = screen or hs.screen.primaryScreen()
  local screenName = layoutScreen:name()
  for _, filter in ipairs(primaryScreenFilters) do
    filter:setScreens(screenName)
  end
end

-- LAYOUTS
-------------------------------------------------------------------------------
--- Q - Work and Video
function export.workVideo(inverted)
  pinTwitchWindows()
  local layout = inverted and areas.smallSplitInverted or areas.smallSplit

  setLayoutWindows(browsers, layout.main)
  setLayoutWindows(editors, layout.main)
  setLayoutWindows(figma, layout.main)
  setLayoutWindows(todos, layout.main)

  if hasVideo() then
    setLayoutWindows(videos, layout.secondaryTop)
    setLayoutWindows(terminals, layout.secondaryBottom)
    setLayoutWindows(notes, layout.secondaryBottom)
    setLayoutWindows(obs, layout.secondaryBottom)
  else
    setLayoutWindows(terminals, layout.secondaryFull)
    setLayoutWindows(notes, layout.secondaryFull)
    setLayoutWindows(obs, layout.secondaryFull)
  end
end

function export.workCode(inverted)
  pinTwitchWindows()
  local layout = inverted and areas.mediumSplitInverted or areas.mediumSplit

  setLayoutWindows(editors, layout.main)
  setLayoutWindows(figma, layout.main)
  setLayoutWindows(terminals, layout.main)
  setLayoutWindows(videos, layout.main)
  setLayoutWindows(browsers, layout.secondaryFull)
  setLayoutWindows(notes, layout.secondaryFull)
  setLayoutWindows(obs, layout.secondaryFull)
end

function export.workEven(mainNotes)
  pinTwitchWindows()
  if mainNotes then
    setLayoutWindows(browsers, areas.evenSplit.leftFull)
    setLayoutWindows(terminals, areas.evenSplit.leftFull)
    setLayoutWindows(editors, areas.evenSplit.leftFull)
    setLayoutWindows(figma, areas.evenSplit.leftFull)
    setLayoutWindows(videos, areas.evenSplit.leftFull)
    setLayoutWindows(notes, areas.evenSplit.rightFull)
  else
    setLayoutWindows(notes, areas.evenSplit.leftFull)
    setLayoutWindows(browsers, areas.evenSplit.leftFull)
    setLayoutWindows(terminals, areas.evenSplit.leftFull)
    setLayoutWindows(videos, areas.evenSplit.rightFull)
    setLayoutWindows(figma, areas.evenSplit.rightFull)
    setLayoutWindows(editors, areas.evenSplit.rightFull)
  end
end

function export.twitch()
  pinTwitchWindows()
end

function export.workMax()
  pinTwitchWindows()
  if twitchMode.isEnabled() then
    for _, filter in ipairs({ editors, figma, terminals, browsers, notes, videos }) do
      setLayoutWindows(filter, "0,0 12x12")
    end
    return
  end
  helpers.maximiseFilteredWindows(editors)
  helpers.maximiseFilteredWindows(figma)
  helpers.maximiseFilteredWindows(terminals)
  helpers.maximiseFilteredWindows(browsers)
  helpers.maximiseFilteredWindows(notes)
  helpers.maximiseFilteredWindows(videos)
  -- grid.setFilteredWindowsToCell(terminals, areas.custom.medium)
  -- grid.setFilteredWindowsToCell(browsers, areas.custom.large)
  -- grid.setFilteredWindowsToCell(notes, areas.custom.small)
end

return export
