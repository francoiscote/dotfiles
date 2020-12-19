hs.logger.defaultLogLevel = 'info'
-- USER VARIABLES
-------------------------------------------------------------------------------
local user = {
  terminal = 'alacritty',
  browser =   'Google Chrome',
  -- browser = 'Firefox Developer Edition',
  -- browser = 'qutebrowser',
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


-- Mission Control
-------------------------------------------------------------------------------

-- Mission Control
hyper:bind({"shift"}, 'up', nil, function()
  -- hs.eventtap.keyStroke({"ctrl"}, "f10")
  -- hyper.triggered = true
end)

-- Go To Previous Space
hyper:bind({"shift"}, 'left', nil, function()
  -- helpers.doKeyStroke({"ctrl","shift","cmd"}, 'left')
  -- hyper.triggered = true
end)

-- Go To Next Space
hyper:bind({"shift"}, 'right', nil, function()
  -- helpers.doKeyStroke({"ctrl","shift","cmd"}, 'right')
  -- hyper.triggered = true
end)

-- Show Desktop
hyper:bind({"shift"}, 'down', nil, function()
  -- helpers.doKeyStroke({"ctrl","shift","cmd"}, 'down')
  -- hyper.triggered = true
end)

-- Focus Windows
-------------------------------------------------------------------------------
-- Up
hyper:bind({}, 'up', nil, function()
  hs.window.filter.defaultCurrentSpace:focusWindowNorth(nil,true,true)
  hyper.triggered = true
end)
-- Down
hyper:bind({}, 'down', nil, function()
  hs.window.filter.defaultCurrentSpace:focusWindowSouth(nil,true,true)
  hyper.triggered = true
end)
-- Left
hyper:bind({}, 'left', nil, function()
  hs.window.filter.defaultCurrentSpace:focusWindowWest(nil,true,true)
  hyper.triggered = true
end)
-- Right
hyper:bind({}, 'right', nil, function()
  hs.window.filter.defaultCurrentSpace:focusWindowEast(nil,true,true)
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
w_browsers = wf.new{'Google Chrome', 'Firefox Developer Edition', 'qtebrowser'}
w_editors = wf.new{'Atom', 'Code'}
w_terminals = wf.new{'iTerm2', 'Alacritty'}
w_videos = wf.new(false):setAppFilter('zoom.us')

  local workCells = {
    leftMain = '0,0 7x16',
    leftSecondaryFull = '0,0 3x16',
    leftSecondaryTop = '0,0 3x8',
    leftSecondaryBottom = '0,8 3x10',
    rightMain = '3,0 7x16',
    rightSecondaryFull = '7,0 3x16',
    rightSecondaryTop = '7,0 3x8',
    rightSecondaryBottom = '7,8 3x10',
  }

  -- 1 - Work Setup - Code Editor Right
  hyper:bind({}, '1', nil, function()
    -- Different layout depending if we have Video windows or not
    local videoWins = w_videos:getWindows()
    if #videoWins == 0 then
      helpers.setWindowsToCell(w_browsers, mygrid, workCells.rightMain)
      helpers.setWindowsToCell(w_editors, mygrid, workCells.rightMain)
      helpers.setWindowsToCell(w_terminals, mygrid, workCells.leftSecondaryFull)
    else
      helpers.setWindowsToCell(w_browsers, mygrid, workCells.rightMain)
      helpers.setWindowsToCell(w_editors, mygrid, workCells.rightMain)
      helpers.setWindowsToCell(w_videos, mygrid, workCells.leftSecondaryTop)
      helpers.setWindowsToCell(w_terminals, mygrid, workCells.leftSecondaryBottom)
    end
  
    hyper.triggered = true
  end)

  -- Shift+1 - Work Setup - Code Editor Left
hyper:bind({'shift'}, '1', nil, function()
  -- Different layout depending if we have Video windows or not
  local videoWins = w_videos:getWindows()
  if #videoWins == 0 then
    helpers.setWindowsToCell(w_browsers, mygrid, workCells.leftMain)
    helpers.setWindowsToCell(w_editors, mygrid, workCells.leftMain)
    helpers.setWindowsToCell(w_terminals, mygrid, workCells.rightSecondaryFull)
  else
    helpers.setWindowsToCell(w_browsers, mygrid, workCells.leftMain)
    helpers.setWindowsToCell(w_editors, mygrid, workCells.leftMain)
    helpers.setWindowsToCell(w_videos, mygrid, workCells.rightSecondaryTop)
    helpers.setWindowsToCell(w_terminals, mygrid, workCells.rightSecondaryBottom)
  end
  
  hyper.triggered = true
end)


local evenSplitCells = {
  left = '0,0 5x16',
  right = '5,0 5x16',
  center = '2,1 6x14'
}


-- 2 - Work Setup - 50/50 split, Editor Right, terminal in the center
hyper:bind({}, '2', nil, function()
  helpers.setWindowsToCell(w_editors, mygrid, evenSplitCells.right)
  helpers.setWindowsToCell(w_browsers, mygrid, evenSplitCells.left)
  helpers.setWindowsToCell(w_terminals, mygrid, evenSplitCells.center)
  
  hyper.triggered = true
end)

-- Shift+2 - Work Setup - 50/50 split, Editor Left, terminal in the center
hyper:bind({'shift'}, '2', nil, function()
  helpers.setWindowsToCell(w_browsers, mygrid, evenSplitCells.right)
  helpers.setWindowsToCell(w_editors, mygrid, evenSplitCells.left)
  helpers.setWindowsToCell(w_terminals, mygrid, evenSplitCells.center)
  hyper.triggered = true
end)

-- TODO: layout #3 (with and without Shift)

-- 4 - Twitch Setup
hyper:bind({}, '4', nil, function()
  local windowLayout = {
      {"OBS", "Windowed Projector (Preview)", nil, nil, {x=0, y=963, w=800, h=600}, nil},
      {"iTerm2", nil, nil, nil, {x=0, y=0, w=800, h=962}, nil},
      {"Alacritty", nil, nil, nil, {x=0, y=0, w=800, h=962}, nil},
      {"Atom", nil, nil, nil, {x=801, y=0, w=1724, h=1418}, nil},
      {"Code", nil, nil, nil, {x=801, y=0, w=1724, h=1418}, nil},
      {"Google Chrome", "francoiscote", nil, nil, {x=801, y=0, w=1724, h=1418}, nil},
      {"Google Chrome", "Alert Box Widget", nil, nil, {x=1725, y=985, w=800, h=455}, nil},
	    {"Google Chrome", "Twitch", nil, nil, {x=2525, y=0, w=914, h=615}, nil},
      {"OBS", nil, nil, nil, {x=2525, y=637, w=914, h=803}, nil}
	}
    hs.layout.apply(windowLayout, string.find)
    hyper.triggered = true
end)

-- 0 - Maximize
hyper:bind({}, '0', nil, function()
    local win = hs.window.focusedWindow()
    win:maximize()
    hyper.triggered = true
end)

-- 9 - Right
local halfRightCell = '5,0 5x16'

hyper:bind({}, '9', nil, function()
  local win = hs.window.focusedWindow()
  mygrid.set(win, halfRightCell)
  hyper.triggered = true
end)

-- Shift+9 - Small Right
hyper:bind({"shift"}, '9', nil, function()
  local win = hs.window.focusedWindow()
  mygrid.setMargins(largeMargins)
  mygrid.set(win, halfRightCell)
  mygrid.setMargins(defaultMargins)
  hyper.triggered = true
end)

-- 8 - Left
local halfLeftCell = '0,0 5,16'

hyper:bind({}, '8', nil, function()
  local win = hs.window.focusedWindow()
  mygrid.set(win, halfLeftCell)
  hyper.triggered = true
end)

-- Shift+8 - Small Left
hyper:bind({"shift"}, '8', nil, function()
  local win = hs.window.focusedWindow()
  mygrid.setMargins(largeMargins)
  mygrid.set(win, halfLeftCell)
  mygrid.setMargins(defaultMargins)
  hyper.triggered = true
end)

-- 7 - "Browser" Size
hyper:bind({}, '7', nil, function()
    local win = hs.window.focusedWindow()
    mygrid.set(win, '2,0 6x16')
    hyper.triggered = true
end)

-- 6 - "Spotify" Size
hyper:bind({}, '6', nil, function()
    local win = hs.window.focusedWindow()
    mygrid.set(win, '2,1 6x14')
    hyper.triggered = true
end)

-- 5 - "Finder" Size
hyper:bind({}, '5', nil, function()
    local win = hs.window.focusedWindow()
    mygrid.set(win, '3,3 4x10')
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
  {'j', 'Visual Studio Code'},
  {'k', user.browser},
  {'l', user.terminal},
  {';', 'Fork'},

  -- Bottom Row: Email, Calendar and ToDos
  {'n', 'Notion'},
  {'m', 'Mailplane'},
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
    nextDevice = hs.audiodevice.findOutputByName('JDS Labs DAC')
    if (nextDevice == nil) then
      nextDevice = hs.audiodevice.findOutputByName('Yeti Stereo Microphone')
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
