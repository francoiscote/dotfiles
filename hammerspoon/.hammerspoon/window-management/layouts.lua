local export = {}
grid = require("window-management/grid")
helpers = require("window-management/helpers")

local areas = grid.areas
local hsGrid = grid.hsGrid

-- FILTERS
-------------------------------------------------------------------------------
local wf = hs.window.filter
local mainScreenName = hs.screen.mainScreen():name()
-- Single Apps
w_chrome = wf.new{'Google Chrome'}:setCurrentSpace(true)
w_firefox = wf.new{'Firefox Developer Edition'}:setCurrentSpace(true)
w_obs = wf.new{'OBS'}:setCurrentSpace(true)
w_figma = wf.new{'Figma'}:setCurrentSpace(true)

-- Groups of Apps
w_browsers = wf.new{['Firefox Developer Edition'] = true, ['Google Chrome'] = { rejectTitles = 'Picture in Picture' } }:setCurrentSpace(true):setScreens(mainScreenName)
w_editors = wf.new{'Code'}:setCurrentSpace(true):setScreens(mainScreenName)
w_terminals = wf.new{'iTerm2', 'Alacritty'}:setCurrentSpace(true):setScreens(mainScreenName)
w_videos = wf.new{['YouTube'] = true, ['Twitch'] = true, ['Google Meet'] = true, ['zoom.us'] = true, ['VLC'] = true, ['Google Chrome'] = {allowTitles = 'Picture in Picture'}, ['Slack'] = {allowTitles = '(.*)Huddle$'}, ['Oryx'] = true}:setCurrentSpace(true):setScreens(mainScreenName)
w_notes = wf.new{'Notion', 'Obsidian'}:setCurrentSpace(true):setScreens(mainScreenName)
w_todos = wf.new{'Todoist', 'Things'}:setCurrentSpace(true):setScreens(mainScreenName)
w_chats = wf.new{'Slack', 'WhatsApp', 'Discord', 'Messages', 'Messenger'}:setCurrentSpace(true):setScreens(mainScreenName)

-- LAYOUTS
-------------------------------------------------------------------------------

--[[
workBrowse: 
  MAIN: Browser and Code, 
  SECONDARY: everything else
]]
function export.workBrowse()
  --RIGHT
  grid.setFilteredWindowsToCell(w_browsers, areas.smallSplit.main)
  grid.setFilteredWindowsToCell(w_editors, areas.smallSplit.main)
  grid.setFilteredWindowsToCell(w_figma, areas.smallSplit.main)
  
  if #w_videos:getWindows() > 0 then
    -- LEFT
    grid.setFilteredWindowsToCell(w_terminals, areas.smallSplit.secondaryBottom)
    grid.setFilteredWindowsToCell(w_notes, areas.smallSplit.secondaryBottom)
    grid.setFilteredWindowsToCell(w_todos, areas.smallSplit.secondaryBottom)
    grid.setFilteredWindowsToCell(w_chats, areas.smallSplit.secondaryBottom)
    grid.setFilteredWindowsToCell(w_videos, areas.smallSplit.secondaryTop)
  else
    -- LEFT
    grid.setFilteredWindowsToCell(w_terminals, areas.smallSplit.secondaryFull)
    grid.setFilteredWindowsToCell(w_notes, areas.smallSplit.secondaryFull)
    grid.setFilteredWindowsToCell(w_todos, areas.smallSplit.secondaryFull)
    grid.setFilteredWindowsToCell(w_chats, areas.smallSplit.secondaryFull)
  end
end

--[[
workCode: 
  MAIN: Code, 
  SECONDARY: everything else
]] 
function export.workCode(tight)
   -- RIGHT
  grid.setFilteredWindowsToCell(w_editors, areas.mediumSplit.main)
  grid.setFilteredWindowsToCell(w_figma, areas.mediumSplit.main)
  
  if #w_videos:getWindows() > 0 then
    -- LEFT
    grid.setFilteredWindowsToCell(w_browsers, areas.mediumSplit.secondaryBottom)
    grid.setFilteredWindowsToCell(w_terminals, areas.mediumSplit.secondaryBottom)
    grid.setFilteredWindowsToCell(w_notes, areas.mediumSplit.secondaryBottom)
    grid.setFilteredWindowsToCell(w_todos, areas.mediumSplit.secondaryBottom)
    grid.setFilteredWindowsToCell(w_chats, areas.mediumSplit.secondaryBottom)
    grid.setFilteredWindowsToCell(w_videos, areas.mediumSplit.secondaryTop)
  else 
    -- LEFT
    grid.setFilteredWindowsToCell(w_browsers, areas.mediumSplit.secondaryFull)
    grid.setFilteredWindowsToCell(w_terminals, areas.mediumSplit.secondaryFull)
    grid.setFilteredWindowsToCell(w_notes, areas.mediumSplit.secondaryFull)
    grid.setFilteredWindowsToCell(w_todos, areas.mediumSplit.secondaryFull)
    grid.setFilteredWindowsToCell(w_chats, areas.mediumSplit.secondaryFull)
  end
end

--[[
  workTriple:
    LEFT: Terminal + Code + Chat
    MAIN: Video + Notes      
    RIGHT: Browser
]]
function export.workTriple()
  if #w_videos:getWindows() > 0 then
    grid.setFilteredWindowsToCell(w_terminals, areas.tripleSplit.leftFull)
    grid.setFilteredWindowsToCell(w_chats, areas.tripleSplit.leftFull)
    grid.setFilteredWindowsToCell(w_editors, areas.tripleSplit.leftFull)
    
    grid.setFilteredWindowsToCell(w_notes, areas.tripleSplit.mainBottom)
    grid.setFilteredWindowsToCell(w_todos, areas.tripleSplit.mainBottom)
    
    grid.setFilteredWindowsToCell(w_figma, areas.tripleSplit.rightFull)
    grid.setFilteredWindowsToCell(w_browsers, areas.tripleSplit.rightFull)

    grid.setFilteredWindowsToCell(w_videos, areas.tripleSplit.mainTop)
  else 
    grid.setFilteredWindowsToCell(w_terminals, areas.tripleSplit.leftFull)
    grid.setFilteredWindowsToCell(w_chats, areas.tripleSplit.leftFull)
    grid.setFilteredWindowsToCell(w_editors, areas.tripleSplit.leftFull)
    
    grid.setFilteredWindowsToCell(w_browsers, areas.tripleSplit.mainFull)
    
    grid.setFilteredWindowsToCell(w_notes, areas.tripleSplit.rightFull)
    grid.setFilteredWindowsToCell(w_todos, areas.tripleSplit.rightFull)
    grid.setFilteredWindowsToCell(w_figma, areas.tripleSplit.rightFull)
  end
end

--[[
workEven: 
  When Video, place it on the left and everything else on the right
  When no video, browser, notes and chats on the left, everything else on the right
]]
function export.workEven()
  if #w_videos:getWindows() > 0 then
    --RIGHT
    grid.setFilteredWindowsToCell(w_terminals, areas.evenSplit.rightFull)
    grid.setFilteredWindowsToCell(w_notes, areas.evenSplit.rightFull)
    grid.setFilteredWindowsToCell(w_todos, areas.evenSplit.rightFull)
    grid.setFilteredWindowsToCell(w_figma, areas.evenSplit.rightFull)
    grid.setFilteredWindowsToCell(w_chats, areas.evenSplit.rightFull)
    grid.setFilteredWindowsToCell(w_browsers, areas.evenSplit.rightFull)
    grid.setFilteredWindowsToCell(w_editors, areas.evenSplit.rightFull)
    -- LEFT
    grid.setFilteredWindowsToCell(w_videos, areas.evenSplit.leftFull)
  else 
    -- LEFT
    grid.setFilteredWindowsToCell(w_browsers, areas.evenSplit.leftFull)
    grid.setFilteredWindowsToCell(w_todos, areas.evenSplit.leftFull)
    grid.setFilteredWindowsToCell(w_chats, areas.evenSplit.leftFull)
    -- RIGHT
    grid.setFilteredWindowsToCell(w_terminals, areas.evenSplit.rightFull)
    grid.setFilteredWindowsToCell(w_notes, areas.evenSplit.rightFull)
    grid.setFilteredWindowsToCell(w_figma, areas.evenSplit.rightFull)
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
  grid.setFilteredWindowsToCell(w_browsers, areas.custom.browser)
  grid.setFilteredWindowsToCell(w_terminals, areas.custom.center)
  grid.setFilteredWindowsToCell(w_notes, areas.custom.center)
  grid.setFilteredWindowsToCell(w_todos, areas.custom.center)
  grid.setFilteredWindowsToCell(w_chats, areas.custom.center)
  grid.setFilteredWindowsToCell(w_videos, areas.custom.center)
end

return export
