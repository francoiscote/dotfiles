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
  if not twitchMode.isEnabled() then return end

  local screen = layoutScreen or hs.screen.primaryScreen()
  local function onScreen(window)
    local windowScreen = window:screen()
    return windowScreen and windowScreen:id() == screen:id()
  end

  for _, window in ipairs(obs:getWindows()) do
    if onScreen(window) and window:title():match("^OBS[%s%-]") then
      setWindowToPixelArea(window, export.twitchAreas.secondaryBottom, screen)
    end
  end

  -- Dashboard windows have identical titles; preserve their current left/right order.
  local windows = {}
  for _, window in ipairs(dashboard:getWindows()) do
    if onScreen(window) then windows[#windows + 1] = window end
  end
  table.sort(windows, function(a, b) return a:frame().x < b:frame().x end)
  if #windows == 1 then
    local frame = windows[1]:frame()
    local midpoint = screen:frame().x + export.twitchAreas.main.x + export.twitchAreas.main.w / 2
    local area = frame.x + frame.w / 2 < midpoint and export.twitchAreas.secondaryLeft or export.twitchAreas.secondaryRight
    setWindowToPixelArea(windows[1], area, screen)
  elseif #windows >= 2 then
    setWindowToPixelArea(windows[1], export.twitchAreas.secondaryLeft, screen)
    setWindowToPixelArea(windows[#windows], export.twitchAreas.secondaryRight, screen)
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
    for _, filter in ipairs({ editors, figma, terminals, browsers, notes, videos, todos }) do
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
  helpers.maximiseFilteredWindows(todos)
  -- grid.setFilteredWindowsToCell(terminals, areas.custom.medium)
  -- grid.setFilteredWindowsToCell(browsers, areas.custom.large)
  -- grid.setFilteredWindowsToCell(notes, areas.custom.small)
end

return export
