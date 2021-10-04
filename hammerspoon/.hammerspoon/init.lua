hs.logger.defaultLogLevel = 'info'
-- USER VARIABLES
-------------------------------------------------------------------------------
local user = {
  terminal = 'alacritty',
  editor = 'Visual Studio Code',
  browser =   'Google Chrome',
  -- browser = 'Firefox Developer Edition',
  -- browser = 'Firefox',
  -- browser = 'qutebrowser',
  mailclient = 'Mailplane',
  gapSize = 10,
  menuGapSize = 0
}

-- INITIALIZATION
-------------------------------------------------------------------------------
helpers = require("helpers")
hyperConstructor = require("hyper")

-- Tools
-------------------------------------------------------------------------------
hyper = hyperConstructor('F18')
log = hs.logger.new('WM','debug')

-- Inspect Focused Window
hyper:bind({"shift"}, 'i', nil, function()
  local win = hs.window.focusedWindow()
  helpers.logWindowInfo(win)
  hyper.triggered = true
end)

-- GRID
-------------------------------------------------------------------------------
local screen = hs.screen.mainScreen()
local frame = nil

if user.menuGapSize > 0 then
  local max = screen:frame()
  frame = hs.geometry(0, user.menuGapSize, max.w, max.h - user.menuGapSize)
end

local defaultMargins = user.gapSize .. 'x' .. user.gapSize
local largeMargins = helpers.getDynamicMargins(0.03, 0.07)

local mygrid = hs.grid.setGrid('10x16', screen, frame).setMargins(defaultMargins)

hyper:bind({}, 'g', nil, function()
  mygrid.toggleShow()
  hyper.triggered = true
end)

-- Resize Windows
-------------------------------------------------------------------------------
hs.window.animationDuration = 0
local wf=hs.window.filter

-- Windows Filters
w_browsers = wf.new{'Google Chrome', 'Firefox Developer Edition', 'Firefox'}
w_editors = wf.new{'Atom', 'Code'}
w_terminals = wf.new{'iTerm2', 'Alacritty'}
w_videos = wf.new(false):setAppFilter('zoom.us')

local seventySplitCells = {
  leftMain = '0,0 7x16',
  leftSecondaryFull = '0,0 3x16',
  leftSecondaryTop = '0,0 3x6',
  leftSecondaryBottom = '0,6 3x10',
  rightMain = '3,0 7x16',
  rightSecondaryFull = '7,0 3x16',
  rightSecondaryTop = '7,0 3x6',
  rightSecondaryBottom = '7,6 3x10',
}

-- q - Work Setup - Browser/Code in Main Right, Terminal in secondary Left
hyper:bind({}, 'q', nil, function()
  -- Different layout depending if we have Video windows or not
  local videoWins = w_videos:getWindows()
  if #videoWins == 0 then
    helpers.setWindowsToCell(w_browsers, mygrid, seventySplitCells.rightMain)
    helpers.setWindowsToCell(w_editors, mygrid, seventySplitCells.rightMain)
    helpers.setWindowsToCell(w_terminals, mygrid, seventySplitCells.leftSecondaryFull)
  else
    helpers.setWindowsToCell(w_browsers, mygrid, seventySplitCells.rightMain)
    helpers.setWindowsToCell(w_editors, mygrid, seventySplitCells.rightMain)
    helpers.setWindowsToCell(w_videos, mygrid, seventySplitCells.leftSecondaryTop)
    helpers.setWindowsToCell(w_terminals, mygrid, seventySplitCells.leftSecondaryBottom)
  end

  hyper.triggered = true
end)

-- Shift+q - Work Setup - Browser/Code in Main Left, Terminal in secondary Right
hyper:bind({'shift'}, 'q', nil, function()
  -- Different layout depending if we have Video windows or not
  local videoWins = w_videos:getWindows()
  if #videoWins == 0 then
    helpers.setWindowsToCell(w_browsers, mygrid, seventySplitCells.leftMain)
    helpers.setWindowsToCell(w_editors, mygrid, seventySplitCells.leftMain)
    helpers.setWindowsToCell(w_terminals, mygrid, seventySplitCells.rightSecondaryFull)
  else
    helpers.setWindowsToCell(w_browsers, mygrid, seventySplitCells.leftMain)
    helpers.setWindowsToCell(w_editors, mygrid, seventySplitCells.leftMain)
    helpers.setWindowsToCell(w_videos, mygrid, seventySplitCells.rightSecondaryTop)
    helpers.setWindowsToCell(w_terminals, mygrid, seventySplitCells.rightSecondaryBottom)
  end
  
  hyper.triggered = true
end)

local sixtySplitCells = {
  leftMain = '0,0 6x16',
  leftSecondaryFull = '0,0 4x16',
  leftSecondaryTop = '0,0 4x6',
  leftSecondaryBottom = '0,6 4x10',
  rightMain = '4,0 6x16',
  rightSecondaryFull = '6,0 4x16',
  rightSecondaryTop = '6,0 4x6',
  rightSecondaryBottom = '6,6 4x10',
}

-- w - Work Setup - Code in Main Right, Browser/Terminal in secondary Left
hyper:bind({}, 'w', nil, function()
  -- Different layout depending if we have Video windows or not
  local videoWins = w_videos:getWindows()
  if #videoWins == 0 then
    helpers.setWindowsToCell(w_browsers, mygrid, sixtySplitCells.leftSecondaryFull)
    helpers.setWindowsToCell(w_terminals, mygrid, sixtySplitCells.leftSecondaryFull)
    helpers.setWindowsToCell(w_editors, mygrid, sixtySplitCells.rightMain)
  else
    helpers.setWindowsToCell(w_videos, mygrid, sixtySplitCells.leftSecondaryTop)
    helpers.setWindowsToCell(w_browsers, mygrid, sixtySplitCells.leftSecondaryBottom)
    helpers.setWindowsToCell(w_terminals, mygrid, sixtySplitCells.leftSecondaryBottom)
    helpers.setWindowsToCell(w_editors, mygrid, sixtySplitCells.rightMain)
  end

  hyper.triggered = true
end)

-- w - Work Setup - Terminal/Code in Main Left, Browser in secondary Right
hyper:bind({'shift'}, 'w', nil, function()
  -- Different layout depending if we have Video windows or not
  local videoWins = w_videos:getWindows()
  if #videoWins == 0 then
    helpers.setWindowsToCell(w_terminals, mygrid, sixtySplitCells.leftMain)
    helpers.setWindowsToCell(w_editors, mygrid, sixtySplitCells.leftMain)
    helpers.setWindowsToCell(w_browsers, mygrid, sixtySplitCells.rightSecondaryFull)
  else
    helpers.setWindowsToCell(w_terminals, mygrid, sixtySplitCells.leftMain)
    helpers.setWindowsToCell(w_editors, mygrid, sixtySplitCells.leftMain)
    helpers.setWindowsToCell(w_videos, mygrid, sixtySplitCells.rightSecondaryTop)
    helpers.setWindowsToCell(w_browsers, mygrid, sixtySplitCells.rightSecondaryBottom)
  end

  hyper.triggered = true
end)


local evenSplitCells = {
  left = '0,0 5x16',
  right = '5,0 5x16',
  center = '2,1 6x14'
}

-- e - Work Setup - 50/50 split, Editor Right, terminal in the center
hyper:bind({}, 'e', nil, function()
  helpers.setWindowsToCell(w_editors, mygrid, evenSplitCells.right)
  helpers.setWindowsToCell(w_browsers, mygrid, evenSplitCells.left)
  helpers.setWindowsToCell(w_terminals, mygrid, evenSplitCells.center)
  
  hyper.triggered = true
end)

-- Shift+e - Work Setup - 50/50 split, Editor Left, terminal in the center
hyper:bind({'shift'}, 'e', nil, function()
  helpers.setWindowsToCell(w_browsers, mygrid, evenSplitCells.right)
  helpers.setWindowsToCell(w_editors, mygrid, evenSplitCells.left)
  helpers.setWindowsToCell(w_terminals, mygrid, evenSplitCells.center)
  
  hyper.triggered = true
end)

-- 1 - 40% Left
local fortyLeftCell = '0,0 4,16'

hyper:bind({}, '1', nil, function()
  local win = hs.window.focusedWindow()
  mygrid.set(win, fortyLeftCell)
  hyper.triggered = true
end)
-- Shift+1 - 40% Left w/ large Margins
hyper:bind({"shift"}, '1', nil, function()
  local win = hs.window.focusedWindow()
  mygrid.setMargins(largeMargins)
  mygrid.set(win, fortyLeftCell)
  mygrid.setMargins(defaultMargins)
  hyper.triggered = true
end)

-- 2 - 50% Left
local halfLeftCell = '0,0 5,16'

hyper:bind({}, '2', nil, function()
  local win = hs.window.focusedWindow()
  mygrid.set(win, halfLeftCell)
  hyper.triggered = true
end)
-- Shift+2 - 50% Left w/ large Margins
hyper:bind({"shift"}, '2', nil, function()
  local win = hs.window.focusedWindow()
  mygrid.setMargins(largeMargins)
  mygrid.set(win, halfLeftCell)
  mygrid.setMargins(defaultMargins)
  hyper.triggered = true
end)

-- 3 - 60% Left
local sixtyLeftCell = '0,0 6,16'

hyper:bind({}, '3', nil, function()
  local win = hs.window.focusedWindow()
  mygrid.set(win, sixtyLeftCell)
  hyper.triggered = true
end)
-- Shift+3 - 60% Left w/ large Margins
hyper:bind({"shift"}, '3', nil, function()
  local win = hs.window.focusedWindow()
  mygrid.setMargins(largeMargins)
  mygrid.set(win, sixtyLeftCell)
  mygrid.setMargins(defaultMargins)
  hyper.triggered = true
end)

-- 4 - "Finder" Size
hyper:bind({}, '4', nil, function()
  local win = hs.window.focusedWindow()
  mygrid.set(win, '3,3 4x10')
  hyper.triggered = true
end)

-- 5 - "Spotify" Size
hyper:bind({}, '5', nil, function()
  local win = hs.window.focusedWindow()
  mygrid.set(win, '2,1 6x14')
  hyper.triggered = true
end)

-- 6 - "Browser" Size
hyper:bind({}, '6', nil, function()
  local win = hs.window.focusedWindow()
  mygrid.set(win, '2,0 6x16')
  hyper.triggered = true
end)

-- 7 - 60% Right
local sixtyRightCells = '4,0 6x16'
hyper:bind({}, '7', nil, function()
  local win = hs.window.focusedWindow()
  mygrid.set(win, sixtyRightCells)
  hyper.triggered = true
end)

-- Shift+7 - Small 50% Right
hyper:bind({"shift"}, '7', nil, function()
  local win = hs.window.focusedWindow()
  mygrid.setMargins(largeMargins)
  mygrid.set(win, sixtyRightCells)
  mygrid.setMargins(defaultMargins)
  hyper.triggered = true
end)

-- 8 - 50% Right
local halfRightCell = '5,0 5x16'
hyper:bind({}, '8', nil, function()
  local win = hs.window.focusedWindow()
  mygrid.set(win, halfRightCell)
  hyper.triggered = true
end)

-- Shift+8 - Small 50% Right
hyper:bind({"shift"}, '8', nil, function()
  local win = hs.window.focusedWindow()
  mygrid.setMargins(largeMargins)
  mygrid.set(win, halfRightCell)
  mygrid.setMargins(defaultMargins)
  hyper.triggered = true
end)

-- 9 - 40% Right
local fortyRightCells = '6,0 4x16'
hyper:bind({}, '9', nil, function()
  local win = hs.window.focusedWindow()
  mygrid.set(win, fortyRightCells)
  hyper.triggered = true
end)

-- Shift+9 - Small 40% Right
hyper:bind({"shift"}, '9', nil, function()
  local win = hs.window.focusedWindow()
  mygrid.setMargins(largeMargins)
  mygrid.set(win, fortyRightCells)
  mygrid.setMargins(defaultMargins)
  hyper.triggered = true
end)

-- 0 - Maximize
hyper:bind({}, '0', nil, function()
    local win = hs.window.focusedWindow()
    win:maximize()
    hyper.triggered = true
end)

-- Picture in Picture on top right
-------------------------------------------------------------------------------
-- hyper:bind({}, 'y', nil, function()
--   local ppWin = hs.window('Picture in Picture')
--   if (ppWin) then
--     local screen = ppWin:screen()
--     local max = screen:frame()

--     ppWin:setFrame({x=max.w-1032, y=max.y, w=1032, h=580})
--   end

--   local termWin = hs.application('iTerm2'):mainWindow()
--   if (termWin) then
--     local screen = termWin:screen()
--     local max = screen:frame()

--     termWin:setFrame({x=max.w-1032, y=603, w=1032, h=837})
--   end
--   hyper.triggered = true
-- end)

-- C - Center
hyper:bind({}, 'c', nil, function()
    local win = hs.window.focusedWindow()
    win:centerOnScreen(nil, true)
    hyper.triggered = true
end)

-- Shortcut to reload config
-------------------------------------------------------------------------------
reload = function()
  hs.reload()
  hs.notify.show("Hammerspoon", "Config Reloaded", "")
  hyper.triggered = true
end
hyper:bind({}, 'r', nil, reload)

-- Single keybinding for app launch
-------------------------------------------------------------------------------
singleapps = {
  -- Top Row: IM + Spotify
  {'u', 'Slack'},
  {'i', 'All-in-One Messenger'},
  {'o', 'Discord'},
  {'p', 'Spotify'},

  -- Middle Row: Dev Tools
  {'h', 'Dash'},
  -- Dev Trifecta (Browser + Editor + Terminal) and SourceTree
  {'j', user.editor},
  {'k', user.browser},
  {'l', user.terminal},
  {';', 'Fork'},

  -- Bottom Row: Email, Calendar and ToDos
  {'n', 'Notion'},
  {'m', user.mailclient},
  {',', 'Fantastical'},
  {'.', 'Finder'}
}

for i, app in ipairs(singleapps) do
  hyper:bind({}, app[1], 
    function() 
      hs.application.launchOrFocus(app[2])
      hyper.triggered = true
    end
  )
end

-- Swap between a Main audio output and a series of ranked secondary outputs
-- Main Output: Vanatoo T0
-- Ranked Secondary Outputs:
--   1) JDS Labs DAC
--   2) Yeti DAC
--   3) Elgato DAC
--   4) Laptop Speakers
-------------------------------------------------------------------------------
hyper:bind({}, 's', nil, function()
  local currentDeviceName = hs.audiodevice.current().name
  local nextDevice
  if string.find(currentDeviceName, 'Vanatoo T0') then
    nextDevice = hs.audiodevice.findOutputByName('EVO4')
    if (nextDevice == nil) then
      nextDevice = hs.audiodevice.findOutputByName('JDS Labs DAC')
    end
    if (nextDevice == nil) then
      nextDevice = hs.audiodevice.findOutputByName('USB audio CODEC')
    end
    if (nextDevice == nil) then
      nextDevice = hs.audiodevice.findOutputByName('MacBook Pro Speakers')
    end
  else
    nextDevice = hs.audiodevice.findOutputByName('Vanatoo T0')
  end

  local didChange = nextDevice:setDefaultOutputDevice()
  if (didChange == true) then
    local audioIcon = hs.image.imageFromPath('/System/Library/PreferencePanes/Sound.prefPane/Contents/Resources/SoundPref.icns')
    hs.notify.new({ title = 'Sound Output Device', subTitle = nextDevice:name(), setIdImage = audioIcon, withdrawAfter = 2}):send()
  end

  hyper.triggered = true
end)
