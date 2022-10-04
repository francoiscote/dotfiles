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
w_videos = wf.new{['YouTube'] = true, ['Twitch'] = true, ['Google Meet'] = true, ['zoom.us'] = true, ['Google Chrome'] = {allowTitles = 'Picture in Picture'}, ['Slack'] = {allowTitles = '(.*)screen share$'}}
w_notes = wf.new{'Notion', 'Obsidian'}:setCurrentSpace(true)
w_chats = wf.new{'Slack', 'Ferdi', 'Discord', 'Messages'}:setCurrentSpace(true)

-- LAYOUTS
-------------------------------------------------------------------------------

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
  grid.setFilteredWindowsToCell(w_chats, areas.custom.center)
end


--[[
  workCodeOrBrowse:
    MAIN: Browser/Code/Figma, 
    SECONDARY: Terminal, Notes and Chats
]]
function export.workCodeOrBrowse()
  grid.setFilteredWindowsToCell(w_browsers, areas.smallSplit.rightMain)
  grid.setFilteredWindowsToCell(w_editors, areas.smallSplit.rightMain)
  grid.setFilteredWindowsToCell(w_figma, areas.smallSplit.rightMain)
  
  if #w_videos:getWindows() > 0 then
    grid.setFilteredWindowsToCell(w_videos, areas.smallSplit.leftSecondaryTop)
    grid.setFilteredWindowsToCell(w_terminals, areas.smallSplit.leftSecondaryBottom)
    grid.setFilteredWindowsToCell(w_notes, areas.smallSplit.leftSecondaryBottom)
    grid.setFilteredWindowsToCell(w_chats, areas.smallSplit.leftSecondaryBottom)
  else 
    grid.setFilteredWindowsToCell(w_terminals, areas.smallSplit.leftSecondaryFull)
    grid.setFilteredWindowsToCell(w_notes, areas.smallSplit.leftSecondaryFull)
    grid.setFilteredWindowsToCell(w_chats, areas.smallSplit.leftSecondaryFull)
  end
end

--[[
workBrowse: 
  MAIN: Browser, 
  SECONDARY: everything else
]]
function export.workBrowse()
  --RIGHT
  grid.setFilteredWindowsToCell(w_browsers, areas.mediumSplit.rightMain)
  grid.setFilteredWindowsToCell(w_figma, areas.mediumSplit.rightMain)
  
  if #w_videos:getWindows() > 0 then
    -- LEFT
    grid.setFilteredWindowsToCell(w_terminals, areas.mediumSplit.leftSecondaryBottom)
    grid.setFilteredWindowsToCell(w_notes, areas.mediumSplit.leftSecondaryBottom)
    grid.setFilteredWindowsToCell(w_chats, areas.mediumSplit.leftSecondaryBottom)
    grid.setFilteredWindowsToCell(w_editors, areas.mediumSplit.leftSecondaryBottom)
    grid.setFilteredWindowsToCell(w_videos, areas.mediumSplit.leftSecondaryTop)
  else
    -- LEFT
    grid.setFilteredWindowsToCell(w_terminals, areas.mediumSplit.leftSecondaryFull)
    grid.setFilteredWindowsToCell(w_editors, areas.mediumSplit.leftSecondaryFull)
    grid.setFilteredWindowsToCell(w_notes, areas.mediumSplit.leftSecondaryFull)
    grid.setFilteredWindowsToCell(w_chats, areas.mediumSplit.leftSecondaryFull)
  end
end

--[[
workCode: 
  MAIN: Code, 
  SECONDARY: everything else
]] 
function export.workCode()
   -- RIGHT
  grid.setFilteredWindowsToCell(w_editors, areas.largeSplit.rightMain)
  grid.setFilteredWindowsToCell(w_figma, areas.largeSplit.rightMain)
  
  if #w_videos:getWindows() > 0 then
    -- LEFT
    grid.setFilteredWindowsToCell(w_browsers, areas.largeSplit.leftSecondaryBottom)
    grid.setFilteredWindowsToCell(w_terminals, areas.largeSplit.leftSecondaryBottom)
    grid.setFilteredWindowsToCell(w_notes, areas.largeSplit.leftSecondaryBottom)
    grid.setFilteredWindowsToCell(w_chats, areas.largeSplit.leftSecondaryBottom)
    grid.setFilteredWindowsToCell(w_videos, areas.largeSplit.leftSecondaryTop)
  else 
    -- LEFT
    grid.setFilteredWindowsToCell(w_browsers, areas.largeSplit.leftSecondaryFull)
    grid.setFilteredWindowsToCell(w_terminals, areas.largeSplit.leftSecondaryFull)
    grid.setFilteredWindowsToCell(w_notes, areas.largeSplit.leftSecondaryFull)
    grid.setFilteredWindowsToCell(w_chats, areas.largeSplit.leftSecondaryFull)
  end
end


--[[
workEven: 
  When Video, place it on the left and everything else on the right
  When no video, browser on the right, everything else on the left
]]
function export.workEven()
  if #w_videos:getWindows() > 0 then
    -- LEFT
    grid.setFilteredWindowsToCell(w_videos, areas.evenSplit.leftFull)
    --RIGHT
    grid.setFilteredWindowsToCell(w_terminals, areas.evenSplit.rightFull)
    grid.setFilteredWindowsToCell(w_notes, areas.evenSplit.rightFull)
    grid.setFilteredWindowsToCell(w_figma, areas.evenSplit.rightFull)
    grid.setFilteredWindowsToCell(w_chats, areas.evenSplit.rightFull)
    grid.setFilteredWindowsToCell(w_browsers, areas.evenSplit.rightFull)
    grid.setFilteredWindowsToCell(w_editors, areas.evenSplit.rightFull)
  else 
    -- LEFT
    grid.setFilteredWindowsToCell(w_browsers, areas.evenSplit.leftFull)
    -- RIGHT
    grid.setFilteredWindowsToCell(w_terminals, areas.evenSplit.rightFull)
    grid.setFilteredWindowsToCell(w_notes, areas.evenSplit.rightFull)
    grid.setFilteredWindowsToCell(w_figma, areas.evenSplit.rightFull)
    grid.setFilteredWindowsToCell(w_chats, areas.evenSplit.rightFull)
    grid.setFilteredWindowsToCell(w_editors, areas.evenSplit.rightFull)
  end
end


return export
