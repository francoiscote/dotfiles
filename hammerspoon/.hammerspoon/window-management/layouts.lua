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
w_notes = wf.new{['Notion'] = { currentSpace = true }}
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
  grid.setFilteredWindowsToCell(w_terminals, areas.seventySplit.center)
  grid.setFilteredWindowsToCell(w_notes, areas.seventySplit.center)
  grid.setFilteredWindowsToCell(w_chats, areas.seventySplit.center)
end


--[[
  workCodeOrBrowse:
    MAIN: Browser/Code/Figma, 
    SECONDARY: Terminal, Notes and Chats
]]
function export.workCodeOrBrowse()
  grid.setFilteredWindowsToCell(w_browsers, areas.seventySplit.rightMain)
  grid.setFilteredWindowsToCell(w_editors, areas.seventySplit.rightMain)
  grid.setFilteredWindowsToCell(w_figma, areas.seventySplit.rightMain)
  
  if #w_videos:getWindows() > 0 then
    grid.setFilteredWindowsToCell(w_videos, areas.seventySplit.leftSecondaryTop)
    grid.setFilteredWindowsToCell(w_terminals, areas.seventySplit.leftSecondaryBottom)
    grid.setFilteredWindowsToCell(w_notes, areas.seventySplit.leftSecondaryBottom)
    grid.setFilteredWindowsToCell(w_chats, areas.seventySplit.leftSecondaryBottom)
  else 
    grid.setFilteredWindowsToCell(w_terminals, areas.seventySplit.leftSecondaryFull)
    grid.setFilteredWindowsToCell(w_notes, areas.seventySplit.leftSecondaryFull)
    grid.setFilteredWindowsToCell(w_chats, areas.seventySplit.leftSecondaryFull)
  end
end

--[[
workCode: 
  MAIN: Code, 
  SECONDARY: everything else
]] 
function export.workCode()
   -- RIGHT
  grid.setFilteredWindowsToCell(w_editors, areas.sixtySplit.rightMain)
  grid.setFilteredWindowsToCell(w_figma, areas.sixtySplit.rightMain)
  
  if #w_videos:getWindows() > 0 then
    -- LEFT
    grid.setFilteredWindowsToCell(w_browsers, areas.sixtySplit.leftSecondaryBottom)
    grid.setFilteredWindowsToCell(w_terminals, areas.sixtySplit.leftSecondaryBottom)
    grid.setFilteredWindowsToCell(w_notes, areas.sixtySplit.leftSecondaryBottom)
    grid.setFilteredWindowsToCell(w_chats, areas.sixtySplit.leftSecondaryBottom)
    grid.setFilteredWindowsToCell(w_videos, areas.sixtySplit.leftSecondaryTop)
  else 
    -- LEFT
    grid.setFilteredWindowsToCell(w_browsers, areas.sixtySplit.leftSecondaryFull)
    grid.setFilteredWindowsToCell(w_terminals, areas.sixtySplit.leftSecondaryFull)
    grid.setFilteredWindowsToCell(w_notes, areas.sixtySplit.leftSecondaryFull)
    grid.setFilteredWindowsToCell(w_chats, areas.sixtySplit.leftSecondaryFull)
  end
end

--[[
workBrowse: 
  MAIN: Browser, 
  SECONDARY: everything else
]]
function export.workBrowse()
  --RIGHT
  grid.setFilteredWindowsToCell(w_browsers, areas.sixtySplit.rightMain)
  grid.setFilteredWindowsToCell(w_figma, areas.sixtySplit.rightMain)
  
  if #w_videos:getWindows() > 0 then
    -- LEFT
    grid.setFilteredWindowsToCell(w_terminals, areas.sixtySplit.leftSecondaryBottom)
    grid.setFilteredWindowsToCell(w_notes, areas.sixtySplit.leftSecondaryBottom)
    grid.setFilteredWindowsToCell(w_chats, areas.sixtySplit.leftSecondaryBottom)
    grid.setFilteredWindowsToCell(w_editors, areas.sixtySplit.leftSecondaryBottom)
    grid.setFilteredWindowsToCell(w_videos, areas.sixtySplit.leftSecondaryTop)
  else
    -- LEFT
    grid.setFilteredWindowsToCell(w_terminals, areas.sixtySplit.leftSecondaryFull)
    grid.setFilteredWindowsToCell(w_editors, areas.sixtySplit.leftSecondaryFull)
    grid.setFilteredWindowsToCell(w_notes, areas.sixtySplit.leftSecondaryFull)
    grid.setFilteredWindowsToCell(w_chats, areas.sixtySplit.leftSecondaryFull)
  end
end

--[[
workEven: 
  When Video, place it on the left and everything else on the right
  When no video, browser on the left, everything else on the right
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
