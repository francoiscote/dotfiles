local export = {}
local grid = require("window-management/grid")
local helpers = require("window-management/helpers")
local twitchMode = require("twitch-mode")

local areas = grid.areas
local layoutScreen

local twitchAreas = require("window-management/twitch-areas")

local setFrame = helpers.withAxHotfix(function(window, frame)
  window:setFrame(frame, 0)
end)

local function setWindowToPixelArea(window, area, screen)
  local origin = screen:frame()
  setFrame(window, hs.geometry.rect(origin.x + area.x, origin.y + area.y, area.w, area.h))
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
local terminals = windowFilter.new({ "iTerm2", "Ghostty", "Rex" }):setCurrentSpace(true)
local ai = windowFilter.new({ "T3 Code (Beta)", "ChatGPT" }):setCurrentSpace(true)
local todos = windowFilter.new({ "Linear" }):setCurrentSpace(true)
local notes = windowFilter.new({ "Notion", "Obsidian", "Bear" }):setCurrentSpace(true)
local figma = windowFilter.new({ "Figma" }):setCurrentSpace(true)
local obs = windowFilter.new({ "OBS Studio" }):setCurrentSpace(true)
local obsidian = windowFilter.new({ "Obsidian" }):setCurrentSpace(true)

local primaryScreenFilters = {
  browsers,
  editors,
  terminals,
  todos,
  notes,
  figma,
  obs,
  obsidian,
  videos
}

local function hasVideo()
  return #videos:getWindows() > 0
end

local function pinTwitchWindows()
  if not twitchMode.isEnabled() then return end

  local screen = layoutScreen or hs.screen.primaryScreen()
  local function onScreen(window)
    local windowScreen = window:screen()
    return windowScreen and windowScreen:id() == screen:id()
  end

  for _, window in ipairs(obs:getWindows()) do
    if onScreen(window) and window:title():match("^OBS[%s%-]") then
      setWindowToPixelArea(window, export.twitchAreas.obs, screen)
    end
  end

  for _, window in ipairs(obsidian:getWindows()) do
    if onScreen(window) then
      setWindowToPixelArea(window, export.twitchAreas.obsidian, screen)
    end
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
  export.twitchAreas = twitchAreas.forScreen(layoutScreen)
  -- Screen names are Lua patterns; escape punctuation (e.g. "Built-in").
  local screenName = layoutScreen:name():gsub("(%W)", "%%%1")
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
  setLayoutWindows(ai, areas.custom.medium)

  if hasVideo() then
    setLayoutWindows(browsers, layout.main)
    setLayoutWindows(editors, layout.main)
    setLayoutWindows(figma, layout.main)
    setLayoutWindows(todos, layout.main)
    setLayoutWindows(terminals, layout.main)
    setLayoutWindows(videos, layout.secondaryTop)
    setLayoutWindows(notes, layout.secondaryBottom)
    setLayoutWindows(obs, layout.secondaryBottom)
  else
    setLayoutWindows(browsers, layout.main)
    setLayoutWindows(editors, layout.main)
    setLayoutWindows(figma, layout.main)
    setLayoutWindows(todos, layout.main)
    setLayoutWindows(terminals, layout.secondaryFull)
    setLayoutWindows(notes, layout.secondaryFull)
    setLayoutWindows(obs, layout.secondaryFull)
  end
end

function export.workCode(inverted)
  pinTwitchWindows()
  local layout = inverted and areas.mediumSplitInverted or areas.mediumSplit

  setLayoutWindows(ai, areas.custom.medium)

  setLayoutWindows(editors, layout.main)
  setLayoutWindows(figma, layout.main)
  setLayoutWindows(terminals, layout.main)
  setLayoutWindows(videos, layout.main)
  setLayoutWindows(browsers, layout.secondaryFull)
  setLayoutWindows(notes, layout.secondaryFull)
  setLayoutWindows(obs, layout.secondaryFull)
  setLayoutWindows(todos, layout.secondaryFull)
end

function export.workEven(mainNotes)
  pinTwitchWindows()
  
  setLayoutWindows(ai, areas.custom.medium)
  
  if mainNotes then
    setLayoutWindows(browsers, areas.evenSplit.leftFull)
    setLayoutWindows(terminals, areas.evenSplit.leftFull)
    setLayoutWindows(editors, areas.evenSplit.leftFull)
    setLayoutWindows(figma, areas.evenSplit.leftFull)
    setLayoutWindows(videos, areas.evenSplit.leftFull)
    setLayoutWindows(todos, areas.evenSplit.leftFull)
    setLayoutWindows(notes, areas.evenSplit.rightFull)
  else
    setLayoutWindows(notes, areas.evenSplit.leftFull)
    setLayoutWindows(todos, areas.evenSplit.leftFull)
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
    for _, filter in ipairs({ editors, figma, terminals, browsers, notes, videos, todos, ai }) do
      setLayoutWindows(filter, "0,0 12x12")
    end
    return
  end
  helpers.maximiseFilteredWindows(editors)
  helpers.maximiseFilteredWindows(figma)
  helpers.maximiseFilteredWindows(videos)
  helpers.maximiseFilteredWindows(todos)
  
  grid.setFilteredWindowsToCell(browsers, areas.custom.largeTall)
  grid.setFilteredWindowsToCell(terminals, areas.custom.large)
  grid.setFilteredWindowsToCell(ai, areas.custom.large)
  grid.setFilteredWindowsToCell(notes, areas.custom.large)
end

return export
