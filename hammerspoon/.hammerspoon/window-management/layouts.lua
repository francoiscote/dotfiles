local export = {}
grid = require("window-management/grid")
helpers = require("window-management/helpers")

local areas = grid.areas
local hsGrid = grid.hsGrid

-- FILTERS
-------------------------------------------------------------------------------
local wf = hs.window.filter
local mainScreenName = hs.screen.mainScreen():name()
-- Groups of Apps
local w_browsers = wf.new { ['Arc'] = true, ['Safari'] = true, ['Firefox Developer Edition'] = true, ['Google Chrome'] = { rejectTitles = 'Picture in Picture' } }
    :setCurrentSpace(true):setScreens(mainScreenName)
local w_editors = wf.new { 'Code' }:setCurrentSpace(true):setScreens(mainScreenName)
local w_terminals = wf.new { 'iTerm2', 'kitty' }:setCurrentSpace(true):setScreens(mainScreenName)
local w_videos = wf.new { ['YouTube'] = true, ['Twitch'] = true, ['Google Meet'] = true, ['zoom.us'] = true, ['VLC'] = true, ['Google Chrome'] = { allowTitles = 'Picture in Picture' }, ['OBS Studio'] = { allowTitles = '(.*)Windowed Projector(.*)' }, ['Arc'] = { allowRoles = 'AXSystemDialog' }, ['Slack'] = { allowTitles = '(.*)Huddle$' }, ['Oryx'] = true }
    :setCurrentSpace(true):setScreens(mainScreenName)
local w_cam = wf.new { ['Google Meet'] = true, ['zoom.us'] = true, ['OBS Studio'] = { allowTitles = '(.*)Windowed Projector(.*)' }, ['Slack'] = { allowTitles = '(.*)Huddle$' } }
local w_notes = wf.new { 'Notion', 'Obsidian', 'Bear' }:setCurrentSpace(true):setScreens(mainScreenName)
local w_todos = wf.new { 'Todoist', 'Things' }:setCurrentSpace(true):setScreens(mainScreenName)
local w_chats = wf.new { 'Slack', 'WhatsApp', 'Discord', 'Messages', 'Messenger' }:setCurrentSpace(true):setScreens(
  mainScreenName)
-- Single Apps
local w_figma = wf.new { 'Figma' }:setCurrentSpace(true)
local w_obs = wf.new { 'OBS Studio' }:setCurrentSpace(true):setScreens(mainScreenName)
local w_twitch = wf.new { 'Twitch Dashboard' }:setCurrentSpace(true):setScreens(mainScreenName)

-- LAYOUTS
-------------------------------------------------------------------------------

--[[
workBrowse:
  MAIN: Browser and Code,
  SECONDARY: everything else
]]
function export.workBrowse(inverted)
  local layout

  -- Force inverted if camera is on
  if #w_cam:getWindows() > 0 then
    inverted = true
  end

  if inverted then
    layout = areas.smallSplitInverted
  else
    layout = areas.smallSplit
  end

  --MAIN
  grid.setFilteredWindowsToCell(w_browsers, layout.main)
  grid.setFilteredWindowsToCell(w_editors, layout.main)
  grid.setFilteredWindowsToCell(w_figma, layout.main)

  if #w_videos:getWindows() > 0 then
    -- SECONDARY
    grid.setFilteredWindowsToCell(w_terminals, layout.secondaryBottom)
    grid.setFilteredWindowsToCell(w_notes, layout.secondaryBottom)
    grid.setFilteredWindowsToCell(w_todos, layout.secondaryBottom)
    grid.setFilteredWindowsToCell(w_chats, layout.secondaryBottom)
    grid.setFilteredWindowsToCell(w_obs, layout.secondaryBottom)
    grid.setFilteredWindowsToCell(w_videos, layout.secondaryTop)
  else
    -- SECONDARY
    grid.setFilteredWindowsToCell(w_terminals, layout.secondaryFull)
    grid.setFilteredWindowsToCell(w_notes, layout.secondaryFull)
    grid.setFilteredWindowsToCell(w_todos, layout.secondaryFull)
    grid.setFilteredWindowsToCell(w_chats, layout.secondaryFull)
    grid.setFilteredWindowsToCell(w_obs, layout.secondaryFull)
  end
end

--[[
workCode:
  MAIN: Code,
  SECONDARY: everything else
]]
function export.workCode(inverted)
  local layout

  -- Force inverted if camera is on
  if #w_cam:getWindows() > 0 then
    inverted = true
  end

  if inverted then
    layout = areas.mediumSplitInverted
  else
    layout = areas.mediumSplit
  end

  -- MAIN
  grid.setFilteredWindowsToCell(w_editors, layout.main)
  grid.setFilteredWindowsToCell(w_figma, layout.main)
  grid.setFilteredWindowsToCell(w_terminals, layout.main)

  if #w_videos:getWindows() > 0 then
    -- SECONDARY
    grid.setFilteredWindowsToCell(w_browsers, layout.secondaryBottom)
    grid.setFilteredWindowsToCell(w_notes, layout.secondaryBottom)
    grid.setFilteredWindowsToCell(w_todos, layout.secondaryBottom)
    grid.setFilteredWindowsToCell(w_chats, layout.secondaryBottom)
    grid.setFilteredWindowsToCell(w_obs, layout.secondaryBottom)
    grid.setFilteredWindowsToCell(w_videos, layout.secondaryTop)
  else
    -- SECONDARY
    grid.setFilteredWindowsToCell(w_browsers, layout.secondaryFull)
    grid.setFilteredWindowsToCell(w_notes, layout.secondaryFull)
    grid.setFilteredWindowsToCell(w_todos, layout.secondaryFull)
    grid.setFilteredWindowsToCell(w_chats, layout.secondaryFull)
    grid.setFilteredWindowsToCell(w_obs, layout.secondaryFull)
  end
end

--[[
workEvnet:
notes on the right, everything else on the left
  ]]
function export.workEven(mainNotes)
  if (mainNotes == true) then
    -- LEFT
    grid.setFilteredWindowsToCell(w_browsers, areas.evenSplit.leftFull)
    grid.setFilteredWindowsToCell(w_terminals, areas.evenSplit.leftFull)
    grid.setFilteredWindowsToCell(w_editors, areas.evenSplit.leftFull)
    grid.setFilteredWindowsToCell(w_todos, areas.evenSplit.leftFull)
    grid.setFilteredWindowsToCell(w_chats, areas.evenSplit.leftFull)
    grid.setFilteredWindowsToCell(w_figma, areas.evenSplit.leftFull)
    -- RIGHT
    grid.setFilteredWindowsToCell(w_notes, areas.evenSplit.rightFull)
  else
    -- LEFT
    grid.setFilteredWindowsToCell(w_notes, areas.evenSplit.leftFull)
    grid.setFilteredWindowsToCell(w_browsers, areas.evenSplit.leftFull)
    grid.setFilteredWindowsToCell(w_todos, areas.evenSplit.leftFull)
    grid.setFilteredWindowsToCell(w_chats, areas.evenSplit.leftFull)
    grid.setFilteredWindowsToCell(w_figma, areas.evenSplit.leftFull)
    -- RIGHT
    grid.setFilteredWindowsToCell(w_terminals, areas.evenSplit.rightFull)
    grid.setFilteredWindowsToCell(w_editors, areas.evenSplit.rightFull)
  end
end

--[[
workMax:
  MAIN: Browser/Code Maximized,
  SECONDARY: Terminal and Notes centered
]]

function export.workMax()
  helpers.maximiseFilteredWindows(w_editors)
  helpers.maximiseFilteredWindows(w_figma)
  helpers.maximiseFilteredWindows(w_terminals)
  grid.setFilteredWindowsToCell(w_browsers, areas.custom.browser)
  grid.setFilteredWindowsToCell(w_notes, areas.custom.finder)
  grid.setFilteredWindowsToCell(w_todos, areas.custom.finder)
  grid.setFilteredWindowsToCell(w_chats, areas.custom.center)
  grid.setFilteredWindowsToCell(w_videos, areas.custom.center)
end

local function twitchHiddenWindows()
  grid.setFilteredWindowsToCell(w_obs, areas.twitch.hiddenBottom)

  if #w_videos:getWindows() > 0 then
    grid.setFilteredWindowsToCell(w_videos, areas.twitch.hiddenLeftTop)
    grid.setFilteredWindowsToCell(w_twitch, areas.twitch.hiddenLeftBottom)
  else
    grid.setFilteredWindowsToCell(w_twitch, areas.twitch.hiddenLeft)
  end
end

function export.twitchBrowseAndCode(inverted)
  -- Hidden
  twitchHiddenWindows()

  if (inverted) then
    --Left
    grid.setFilteredWindowsToCell(w_browsers, areas.twitch.leftMainBig)
    grid.setFilteredWindowsToCell(w_editors, areas.twitch.leftMainBig)
    grid.setFilteredWindowsToCell(w_figma, areas.twitch.leftMainBig)

    --Right
    grid.setFilteredWindowsToCell(w_terminals, areas.twitch.rightSecondaryMini)
    grid.setFilteredWindowsToCell(w_notes, areas.twitch.rightSecondaryMini)
    grid.setFilteredWindowsToCell(w_todos, areas.twitch.rightSecondaryMini)
    grid.setFilteredWindowsToCell(w_chats, areas.twitch.rightSecondaryMini)
  else
    --Left
    grid.setFilteredWindowsToCell(w_terminals, areas.twitch.leftSecondaryMini)
    grid.setFilteredWindowsToCell(w_notes, areas.twitch.leftSecondaryMini)
    grid.setFilteredWindowsToCell(w_todos, areas.twitch.leftSecondaryMini)
    grid.setFilteredWindowsToCell(w_chats, areas.twitch.leftSecondaryMini)

    --Right
    grid.setFilteredWindowsToCell(w_browsers, areas.twitch.rightMainBig)
    grid.setFilteredWindowsToCell(w_editors, areas.twitch.rightMainBig)
    grid.setFilteredWindowsToCell(w_figma, areas.twitch.rightMainBig)
  end
end

function export.twitchCodeEven(inverted)
  -- Hidden
  twitchHiddenWindows()

  if (inverted) then
    --LEFT
    grid.setFilteredWindowsToCell(w_terminals, areas.twitch.evenLeft)
    grid.setFilteredWindowsToCell(w_notes, areas.twitch.evenLeft)
    grid.setFilteredWindowsToCell(w_todos, areas.twitch.evenLeft)
    grid.setFilteredWindowsToCell(w_chats, areas.twitch.evenLeft)
    grid.setFilteredWindowsToCell(w_editors, areas.twitch.evenLeft)

    --RIGHT
    grid.setFilteredWindowsToCell(w_figma, areas.twitch.evenRight)
    grid.setFilteredWindowsToCell(w_browsers, areas.twitch.evenRight)
  else
    --LEFT
    grid.setFilteredWindowsToCell(w_figma, areas.twitch.evenLeft)
    grid.setFilteredWindowsToCell(w_browsers, areas.twitch.evenLeft)

    --RIGHT
    grid.setFilteredWindowsToCell(w_terminals, areas.twitch.evenRight)
    grid.setFilteredWindowsToCell(w_notes, areas.twitch.evenRight)
    grid.setFilteredWindowsToCell(w_todos, areas.twitch.evenRight)
    grid.setFilteredWindowsToCell(w_chats, areas.twitch.evenRight)
    grid.setFilteredWindowsToCell(w_editors, areas.twitch.evenRight)
  end
end

function export.twitchCodeSmall(inverted) -- Hidden
  twitchHiddenWindows()

  if (inverted) then
    --LEFT
    grid.setFilteredWindowsToCell(w_terminals, areas.twitch.leftSecondaryMini)
    grid.setFilteredWindowsToCell(w_notes, areas.twitch.leftSecondaryMini)
    grid.setFilteredWindowsToCell(w_todos, areas.twitch.leftSecondaryMini)
    grid.setFilteredWindowsToCell(w_chats, areas.twitch.leftSecondaryMini)
    grid.setFilteredWindowsToCell(w_editors, areas.twitch.leftSecondaryMini)

    --RIGHT
    grid.setFilteredWindowsToCell(w_figma, areas.twitch.rightMainBig)
    grid.setFilteredWindowsToCell(w_browsers, areas.twitch.rightMainBig)
  else
    --LEFT
    grid.setFilteredWindowsToCell(w_figma, areas.twitch.leftMainBig)
    grid.setFilteredWindowsToCell(w_browsers, areas.twitch.leftMainBig)

    --RIGHT
    grid.setFilteredWindowsToCell(w_terminals, areas.twitch.rightSecondaryMini)
    grid.setFilteredWindowsToCell(w_notes, areas.twitch.rightSecondaryMini)
    grid.setFilteredWindowsToCell(w_todos, areas.twitch.rightSecondaryMini)
    grid.setFilteredWindowsToCell(w_chats, areas.twitch.rightSecondaryMini)
    grid.setFilteredWindowsToCell(w_editors, areas.twitch.rightSecondaryMini)
  end
end

function export.twitchMax()
  -- Hidden
  twitchHiddenWindows()

  grid.setFilteredWindowsToCell(w_editors, areas.twitch.maximize)
  grid.setFilteredWindowsToCell(w_figma, areas.twitch.maximize)
  grid.setFilteredWindowsToCell(w_browsers, areas.twitch.maximize)

  grid.setFilteredWindowsToCell(w_terminals, areas.twitch.center)
  grid.setFilteredWindowsToCell(w_notes, areas.twitch.center)
  grid.setFilteredWindowsToCell(w_todos, areas.twitch.center)
  grid.setFilteredWindowsToCell(w_chats, areas.twitch.center)
end

return export
