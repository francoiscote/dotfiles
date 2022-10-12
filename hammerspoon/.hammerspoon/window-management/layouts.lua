local export = {}
grid = require("window-management/grid")
helpers = require("window-management/helpers")

local areas = grid.areas
local hsGrid = grid.hsGrid

-- FILTERS
-------------------------------------------------------------------------------
local wf = hs.window.filter

-- Single Apps
w_chrome = wf.new{'Google Chrome'}
w_firefox = wf.new{'Firefox Developer Edition'}
w_obs = wf.new{'OBS'}
w_figma = wf.new{'Figma'}

-- Groups of Apps
w_browsers = wf.new{['Firefox Developer Edition'] = true, ['Google Chrome'] = { rejectTitles = 'Picture in Picture' } }
w_editors = wf.new{'Code'}
w_terminals = wf.new{'iTerm2', 'A lacritty'}
w_videos = wf.new{['YouTube'] = true, ['Twitch'] = true, ['Google Meet'] = true, ['zoom.us'] = true, ['Google Chrome'] = {allowTitles = 'Picture in Picture'}, ['Slack'] = {allowTitles = '(.*)screen share$'}}:setCurrentSpace(true)
w_notes = wf.new{'Notion', 'Obsidian'}:setCurrentSpace(true)
w_todos = wf.new{'Asana', 'Todoist'}:setCurrentSpace(true)
w_chats = wf.new{'Slack', 'Ferdi', 'Discord', 'Messages'}:setCurrentSpace(true)

-- LAYOUTS
-------------------------------------------------------------------------------

--[[
workBrowse: 
  MAIN: Browser, 
  SECONDARY: everything else
]]
function export.workBrowse(tight)
  tight = tight or false
  local split = tight and areas.smallSplit or areas.mediumSplit
  --RIGHT
  grid.setFilteredWindowsToCell(w_browsers, split.main)
  grid.setFilteredWindowsToCell(w_figma, split.main)
  grid.setFilteredWindowsToCell(w_todos, split.main)
  
  if #w_videos:getWindows() > 0 then
    -- LEFT
    grid.setFilteredWindowsToCell(w_videos, split.secondaryTop)
    grid.setFilteredWindowsToCell(w_editors, split.secondaryBottom)
    grid.setFilteredWindowsToCell(w_terminals, split.secondaryBottom)
    grid.setFilteredWindowsToCell(w_notes, split.secondaryBottom)
    grid.setFilteredWindowsToCell(w_chats, split.secondaryBottom)
  else
    -- LEFT
    grid.setFilteredWindowsToCell(w_terminals, split.secondaryFull)
    grid.setFilteredWindowsToCell(w_editors, split.secondaryFull)
    grid.setFilteredWindowsToCell(w_notes, split.secondaryFull)
    grid.setFilteredWindowsToCell(w_chats, split.secondaryFull)
  end
end

--[[
workCode: 
  MAIN: Code, 
  SECONDARY: everything else
]] 
function export.workCode(tight)
  tight = tight or false
  local split = tight and areas.smallSplit or areas.mediumSplit
   -- RIGHT
  grid.setFilteredWindowsToCell(w_editors, split.main)
  grid.setFilteredWindowsToCell(w_figma, split.main)
  grid.setFilteredWindowsToCell(w_todos, split.main)
  
  if #w_videos:getWindows() > 0 then
    -- LEFT
    grid.setFilteredWindowsToCell(w_browsers, split.secondaryBottom)
    grid.setFilteredWindowsToCell(w_terminals, split.secondaryBottom)
    grid.setFilteredWindowsToCell(w_notes, split.secondaryBottom)
    grid.setFilteredWindowsToCell(w_chats, split.secondaryBottom)
    grid.setFilteredWindowsToCell(w_videos, split.secondaryTop)
  else 
    -- LEFT
    grid.setFilteredWindowsToCell(w_browsers, split.secondaryFull)
    grid.setFilteredWindowsToCell(w_terminals, split.secondaryFull)
    grid.setFilteredWindowsToCell(w_notes, split.secondaryFull)
    grid.setFilteredWindowsToCell(w_chats, split.secondaryFull)
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
    
    grid.setFilteredWindowsToCell(w_videos, areas.tripleSplit.mainTop)
    grid.setFilteredWindowsToCell(w_notes, areas.tripleSplit.mainBottom)
    grid.setFilteredWindowsToCell(w_todos, areas.tripleSplit.mainBottom)

    grid.setFilteredWindowsToCell(w_figma, areas.tripleSplit.rightFull)
    grid.setFilteredWindowsToCell(w_browsers, areas.tripleSplit.rightFull)
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
    -- LEFT
    grid.setFilteredWindowsToCell(w_videos, areas.evenSplit.leftFull)
    --RIGHT
    grid.setFilteredWindowsToCell(w_terminals, areas.evenSplit.rightFull)
    grid.setFilteredWindowsToCell(w_notes, areas.evenSplit.rightFull)
    grid.setFilteredWindowsToCell(w_todos, areas.evenSplit.rightFull)
    grid.setFilteredWindowsToCell(w_figma, areas.evenSplit.rightFull)
    grid.setFilteredWindowsToCell(w_chats, areas.evenSplit.rightFull)
    grid.setFilteredWindowsToCell(w_browsers, areas.evenSplit.rightFull)
    grid.setFilteredWindowsToCell(w_editors, areas.evenSplit.rightFull)
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
  helpers.maximiseFilteredWindows(w_browsers)
  helpers.maximiseFilteredWindows(w_editors)
  helpers.maximiseFilteredWindows(w_figma)
  grid.setFilteredWindowsToCell(w_terminals, areas.custom.center)
  grid.setFilteredWindowsToCell(w_notes, areas.custom.center)
  grid.setFilteredWindowsToCell(w_todos, areas.custom.center)
  grid.setFilteredWindowsToCell(w_chats, areas.custom.center)
  grid.setFilteredWindowsToCell(w_videos, areas.custom.center)
end

return export
