hs.logger.defaultLogLevel = 'info'
-- USER VARIABLES
-------------------------------------------------------------------------------
local user = {
  terminal = 'iTerm',
  editor = 'Visual Studio Code',
  browser_main = 'Google Chrome',
  browser_alt = 'Firefox Developer Edition',
  mailclient = 'Gmail',
  calendar = 'Fantastical',
  gapSize = 10,
  menuGapSize = 0
}

-- INITIALIZATION
-------------------------------------------------------------------------------
helpers = require("helpers")
hyperConstructor = require("hyper")


hs.spaces.watcher.new(function(spaceNum)
  log.d("Space", spaceNum);
end):start()

-- Tools
-------------------------------------------------------------------------------
hyper = hyperConstructor('F18')
log = hs.logger.new('WM','debug')

-- Inspect Focused Window
hyper:bind({"shift"}, 'i', nil, function()
  log.d("screens", hs.screen.mainScreen())
  local win = hs.window.focusedWindow()
  helpers.logWindowInfo(win)
  hyper.triggered = true
end)

-- GRID
-------------------------------------------------------------------------------
local mainScreen = hs.screen.mainScreen()
local frame = nil

if user.menuGapSize > 0 then
  local max = mainScreen:frame()
  frame = hs.geometry(0, user.menuGapSize, max.w, max.h - user.menuGapSize)
end

local defaultMargins = user.gapSize .. 'x' .. user.gapSize
local largeMargins = helpers.getDynamicMargins(0.03, 0.07)

local mygrid = hs.grid.setGrid('10x10', mainScreen, frame).setMargins(defaultMargins)

hyper:bind({}, 'g', nil, function()
  mygrid.toggleShow()
  hyper.triggered = true
end)

-- Window Managements
-------------------------------------------------------------------------------
hs.window.animationDuration = 0
local wf=hs.window.filter

-- Windows Filters
-- Single Apps
w_chrome = wf.new{'Google Chrome'}
w_firefox = wf.new{'Firefox Developer Edition'}
w_obs = wf.new{'OBS'}
w_figma = wf.new{'Figma'}

-- Groups of Apps
w_browsers = wf.new{'Google Chrome', 'Firefox Developer Edition'}
w_editors = wf.new{'Code'}
w_terminals = wf.new{'iTerm2', 'Alacritty'}
w_videos = wf.new{'Google Meet', 'zoom.us'}
w_notes = wf.new{['Notion'] = {currentSpace = true}}
w_chats = wf.new{'Slack', 'Ferdi', 'Discord'}


local seventySplitCells = {
  center = '2,1 6x8',
  leftMain = '0,0 7x10',
  leftSecondaryFull = '0,0 3x10',
  leftSecondaryTop = '0,0 3x4',
  leftSecondaryBottom = '0,4 3x6',
  rightMain = '3,0 7x10',
  rightSecondaryFull = '7,0 3x10',
  rightSecondaryTop = '7,0 3x4',
  rightSecondaryBottom = '7,4 3x6',
}

-- q - Work Setup - Browser/Code Maximized, Terminal centered
hyper:bind({}, 'tab', nil, function()  -- Different layout depending if we have Video windows or not
  helpers.maximiseAll(w_browsers)
  helpers.maximiseAll(w_editors)
  helpers.maximiseAll(w_figma)
  helpers.setWindowsToCell(w_terminals, mygrid, seventySplitCells.center)
  helpers.setWindowsToCell(w_notes, mygrid, seventySplitCells.center)

  hyper.triggered = true
end)

-- q - Work Setup - Browser/Code in Main Right, Terminal in secondary Left
hyper:bind({}, 'q', nil, function()  -- Different layout depending if we have Video windows or not
  log.d("helpers.isVideoWindows()", helpers.isVideoWindows());

  helpers.setWindowsToCell(w_terminals, mygrid, seventySplitCells.leftSecondaryFull)
  -- helpers.setWindowsToCell(w_notes, mygrid, seventySplitCells.leftSecondaryFull)
  helpers.setWindowsToCell(w_browsers, mygrid, seventySplitCells.rightMain)
  helpers.setWindowsToCell(w_editors, mygrid, seventySplitCells.rightMain)
  helpers.setWindowsToCell(w_figma, mygrid, seventySplitCells.rightMain)

  hyper.triggered = true
end)

-- Shift+q - Work Setup - Browser/Code in Main Left, Terminal in secondary Right
hyper:bind({'shift'}, 'q', nil, function()
  helpers.setWindowsToCell(w_terminals, mygrid, seventySplitCells.rightSecondaryFull)
  -- helpers.setWindowsToCell(w_notes, mygrid, seventySplitCells.rightSecondaryFull)
  helpers.setWindowsToCell(w_browsers, mygrid, seventySplitCells.leftMain)
  helpers.setWindowsToCell(w_editors, mygrid, seventySplitCells.leftMain)
  helpers.setWindowsToCell(w_figma, mygrid, seventySplitCells.leftMain)
  
  hyper.triggered = true
end)

local sixtySplitCells = {
  leftMain = '0,0 6x10',
  leftSecondaryFull = '0,0 4x10',
  leftSecondaryTop = '0,0 4x5',
  leftSecondaryBottom = '0,5 4x5',
  rightMain = '4,0 6x10',
  rightSecondaryFull = '6,0 4x10',
  rightSecondaryTop = '6,0 4x5',
  rightSecondaryBottom = '6,5 4x5',
}

-- w - Work Setup - Code in Main Right, Browser/Terminal in secondary Left
hyper:bind({}, 'w', nil, function()
  helpers.setWindowsToCell(w_browsers, mygrid, sixtySplitCells.leftSecondaryFull)
  helpers.setWindowsToCell(w_terminals, mygrid, sixtySplitCells.leftSecondaryFull)
  -- helpers.setWindowsToCell(w_notes, mygrid, sixtySplitCells.leftSecondaryFull)
  helpers.setWindowsToCell(w_figma, mygrid, sixtySplitCells.rightMain)
  helpers.setWindowsToCell(w_editors, mygrid, sixtySplitCells.rightMain)
  hyper.triggered = true
end)

-- w - Work Setup - Terminal/Code in Main Left, Browser in secondary Right
hyper:bind({'shift'}, 'w', nil, function()
  helpers.setWindowsToCell(w_browsers, mygrid, sixtySplitCells.rightSecondaryFull)
  helpers.setWindowsToCell(w_terminals, mygrid, sixtySplitCells.rightSecondaryFull)
  -- helpers.setWindowsToCell(w_notes, mygrid, sixtySplitCells.rightSecondaryFull)
  helpers.setWindowsToCell(w_editors, mygrid, sixtySplitCells.leftMain)  
  helpers.setWindowsToCell(w_figma, mygrid, sixtySplitCells.leftMain)

  hyper.triggered = true
end)


local evenSplitCells = {
  leftFull = '0,0 5x10',
  leftTop = '0,0 5x6',
  leftBottom = '0,6 5x4',
  rightFull = '5,0 5x10',
  rightTop = '5,0 5x6',
  rightBottom = '5,6 5x4',
  center = '2,1 6x8'
}

-- e - Work Setup - 50/50 split, Editor Right, terminal in the center
hyper:bind({}, 'e', nil, function()
  helpers.setWindowsToCell(w_browsers, mygrid, evenSplitCells.leftFull)
  helpers.setWindowsToCell(w_figma, mygrid, evenSplitCells.leftFull)
  helpers.setWindowsToCell(w_terminals, mygrid, evenSplitCells.center)
  helpers.setWindowsToCell(w_editors, mygrid, evenSplitCells.rightFull)
  -- helpers.setWindowsToCell(w_notes, mygrid, evenSplitCells.rightFull)
  
  hyper.triggered = true
end)

-- Shift+e - Work Setup - 50/50 split, Editor Left, terminal in the center
hyper:bind({'shift'}, 'e', nil, function()
  helpers.setWindowsToCell(w_browsers, mygrid, evenSplitCells.right)
  helpers.setWindowsToCell(w_figma, mygrid, evenSplitCells.right)
  helpers.setWindowsToCell(w_editors, mygrid, evenSplitCells.left)
  helpers.setWindowsToCell(w_terminals, mygrid, evenSplitCells.center)
  -- helpers.setWindowsToCell(w_notes, mygrid, evenSplitCells.left)
  
  hyper.triggered = true
end)


-- Hyper+t - EMPTY
hyper:bind({}, 't', nil, function()
end)

-- Hyper+Shit+t - EMPTY
hyper:bind({'shift'}, 't', nil, function()
end)

-- 1 - 30% Left
hyper:bind({}, '1', nil, function()
  local win = hs.window.focusedWindow()
  mygrid.set(win, '0,0 3,10')
  hyper.triggered = true
end)
-- Shift+1 - 40% Left w/ large Margins
hyper:bind({"shift"}, '1', nil, function()
  local win = hs.window.focusedWindow()
  mygrid.setMargins(largeMargins)
  mygrid.set(win, '0,0 3,10')
  mygrid.setMargins(defaultMargins)
  hyper.triggered = true
end)

-- 2 - 50% Left
hyper:bind({}, '2', nil, function()
  local win = hs.window.focusedWindow()
  mygrid.set(win, '0,0 5,10')
  hyper.triggered = true
end)
-- Shift+2 - 50% Left w/ large Margins
hyper:bind({"shift"}, '2', nil, function()
  local win = hs.window.focusedWindow()
  mygrid.setMargins(largeMargins)
  mygrid.set(win, '0,0 5,10')
  mygrid.setMargins(defaultMargins)
  hyper.triggered = true
end)

-- 3 - 70% Left
hyper:bind({}, '3', nil, function()
  local win = hs.window.focusedWindow()
  mygrid.set(win, '0,0 7,10')
  hyper.triggered = true
end)
-- Shift+3 - 70% Left w/ large Margins
hyper:bind({"shift"}, '3', nil, function()
  local win = hs.window.focusedWindow()
  mygrid.setMargins(largeMargins)
  mygrid.set(win, '0,0 7,10')
  mygrid.setMargins(defaultMargins)
  hyper.triggered = true
end)

-- 4 - "Finder" Size
hyper:bind({}, '4', nil, function()
  local win = hs.window.focusedWindow()
  mygrid.set(win, '3,2 4x6')
  hyper.triggered = true
end)

-- Shift-4 - "Finder" Size - Twich Mode
hyper:bind({'shift'}, '4', nil, function()
  local win = hs.window.focusedWindow()
  mygrid.set(win, '2,1.5 3x4')
  hyper.triggered = true
end)

-- 5 - "Spotify" Size
hyper:bind({}, '5', nil, function()
  local win = hs.window.focusedWindow()
  mygrid.set(win, '2,1 6x8')
  hyper.triggered = true
end)

-- 5 - "Spotify" Size - Twitch Mode
hyper:bind({'shift'}, '5', nil, function()
  local win = hs.window.focusedWindow()
  mygrid.set(win, '0.5,0.5 6x7')
  hyper.triggered = true
end)

-- 6 - "Browser" Size
hyper:bind({}, '6', nil, function()
  local win = hs.window.focusedWindow()
  mygrid.set(win, '2,0 6x10')
  hyper.triggered = true
end)

-- 6 - "Browser" Size for Twich
hyper:bind({'shift'}, '6', nil, function()
  local win = hs.window.focusedWindow()
  mygrid.set(win, '1,0 5x8')
  hyper.triggered = true
end)

-- 7 - 70% Right
hyper:bind({}, '7', nil, function()
  local win = hs.window.focusedWindow()
  mygrid.set(win, '3,0 7x10')
  hyper.triggered = true
end)

-- Shift+7 - Small 70% Right
hyper:bind({"shift"}, '7', nil, function()
  local win = hs.window.focusedWindow()
  mygrid.setMargins(largeMargins)
  mygrid.set(win, '3,0 7x10')
  mygrid.setMargins(defaultMargins)
  hyper.triggered = true
end)

-- 8 - 50% Right
hyper:bind({}, '8', nil, function()
  local win = hs.window.focusedWindow()
  mygrid.set(win, '5,0 5x10')
  hyper.triggered = true
end)

-- Shift+8 - Small 50% Right
hyper:bind({"shift"}, '8', nil, function()
  local win = hs.window.focusedWindow()
  mygrid.setMargins(largeMargins)
  mygrid.set(win, '5,0 5x10')
  mygrid.setMargins(defaultMargins)
  hyper.triggered = true
end)

-- 9 - 30% Right
hyper:bind({}, '9', nil, function()
  local win = hs.window.focusedWindow()
  mygrid.set(win, '7,0 3x10')
  hyper.triggered = true
end)

-- Shift+9 - Small 40% Right
hyper:bind({"shift"}, '9', nil, function()
  local win = hs.window.focusedWindow()
  mygrid.setMargins(largeMargins)
  mygrid.set(win, '7,0 3x10')
  mygrid.setMargins(defaultMargins)
  hyper.triggered = true
end)

-- 0 - Maximize
hyper:bind({}, '0', nil, function()
    local win = hs.window.focusedWindow()
    win:maximize()
    hyper.triggered = true
end)


-- Shift-0 - "Full" Size for Twich
hyper:bind({"shift"}, '0', nil, function()
  local win = hs.window.focusedWindow()
  mygrid.set(win, '0,0 7x8')
  hyper.triggered = true
end)

-- Move Windows
-------------------------------------------------------------------------------
-- C - Center
hyper:bind({}, 'c', nil, function()
    local win = hs.window.focusedWindow()
    win:centerOnScreen(nil, true)
    hyper.triggered = true
end)

-- Hyper+equal - Send window to next screen
hyper:bind({}, '=', nil, function()
  -- Get the focused window, its window frame dimensions, its screen frame dimensions,
  -- and the next screen's frame dimensions.
  local focusedWindow = hs.window.focusedWindow()
  local focusedScreenFrame = focusedWindow:screen():frame()
  local nextScreenFrame = focusedWindow:screen():next():frame()
  local windowFrame = focusedWindow:frame()

  -- Calculate the coordinates of the window frame in the next screen and retain aspect ratio
  windowFrame.x = ((((windowFrame.x - focusedScreenFrame.x) / focusedScreenFrame.w) * nextScreenFrame.w) + nextScreenFrame.x)
  windowFrame.y = ((((windowFrame.y - focusedScreenFrame.y) / focusedScreenFrame.h) * nextScreenFrame.h) + nextScreenFrame.y)
  windowFrame.h = ((windowFrame.h / focusedScreenFrame.h) * nextScreenFrame.h)
  windowFrame.w = ((windowFrame.w / focusedScreenFrame.w) * nextScreenFrame.w)

  -- Set the focused window's new frame dimensions
  focusedWindow:setFrame(windowFrame)
end)

function moveWindowOneSpace(direction)
  local keyCode = direction == "left" and 123 or 124

  -- get current window
  local focusedWindow = hs.window.focusedWindow()
  -- log.d("Window TopLeft:", focusedWindow:topLeft())
  
  -- click at {+64,+4} and hold
  local clickPos = focusedWindow:topLeft():move({64,4})
  -- log.d("Click Pos:", clickPos)
  hs.eventtap.event.newMouseEvent(hs.eventtap.event.types.leftMouseDown, clickPos):post()
  
  -- execute keyboard shortcut
  hs.timer.usleep(1000)
  -- log.d("Key Stroke")
  hs.osascript.applescript([[
    tell application "System Events" 
        keystroke (key code ]] .. keyCode .. [[ using control down)
    end tell
  ]])

  -- -- MouseUp
  hs.timer.usleep(1000)
  log.d("MouseUp")
  hs.eventtap.event.newMouseEvent(hs.eventtap.event.types.leftMouseUp, clickPos):post()
end

hyper:bind({}, 'right', nil, function()
  moveWindowOneSpace('right')
end)

hyper:bind({}, 'left', nil, function()
  moveWindowOneSpace('left')
end)


-- Hyper+Z - Shortcut to reload config
-------------------------------------------------------------------------------
reload = function()
  hs.reload()
  hs.notify.show("Hammerspoon", "Config Reloaded", "")
  hyper.triggered = true
end
hyper:bind({}, 'z', nil, reload)

-- Single keybinding for app launch
-------------------------------------------------------------------------------
singleapps = {
  -- Top Row: IM + Spotify
  {'y', 'Messages'},
  {'u', 'Slack'},
  {'i', 'Ferdi'},
  {'o', 'Discord'},
  {'p', 'Spotify'},

  -- Middle Row: Dev Tools
  {'h', 'Figma'},
  -- Dev Trifecta (Browsers + Editor + Terminal) and SourceTree
  {'j', user.browser_main},
  {'k', user.editor},
  {'l', user.terminal},

  {';', user.browser_alt},
  -- Bottom Row: Email, Calendar and ToDos
  {'b', 'com.culturedcode.ThingsMac'},
  {'n', 'Notion'},
  {'m', user.mailclient},
  {',', user.calendar,},
  {'.', 'Finder'},
}

for i, app in ipairs(singleapps) do
  hyper:bind({}, app[1], 
    function()
      if (hs.application.launchOrFocus(app[2])) then
        hyper.triggered = true
      elseif (hs.application.launchOrFocusByBundleID(app[2])) then
        hyper.triggered = true
      end
    end
  )
end

-- Hyper+Shift+p = Pretzel
-- TODO: make this possible with a shift option above.
-- TODO: also map secondary browser to Hyper+Shift+J
hyper:bind({'shift'}, 'p', function() 
  hs.application.launchOrFocus('Pretzel')
  hyper.triggered = true
end)

-- Swap between a Main audio output and a series of ranked secondary outputs
-- Main Output: Vanatoo T0
-- Ranked Secondary Outputs:x
--   1) JDS Labs DAC
--   2) Yeti DAC
--   3) Elgato DAC
--   4) Laptop Speakers
-------------------------------------------------------------------------------
hyper:bind({}, 's', nil, function()
  local currentDeviceName = hs.audiodevice.defaultOutputDevice():name()
  local nextDevice
  if string.find(currentDeviceName, 'Vanatoo T0') or string.find(currentDeviceName, 'USB audio CODEC') then
    nextDevice = hs.audiodevice.findOutputByName('EVO4')
    if (nextDevice == nil) then
      nextDevice = hs.audiodevice.findOutputByName('External Headphones')
    end
  else
    nextDevice = hs.audiodevice.findOutputByName('Vanatoo T0')
    if (nextDevice == nil) then
      nextDevice = hs.audiodevice.findOutputByName('USB audio CODEC')
    end
  end

  local didChange = nextDevice:setDefaultOutputDevice()
  -- Also set the default Effect device because of a bug where it would change to something random when using setDefaultOutputDevice()
  -- it can't keep the "Selected Sound Output Device" setting.
  nextDevice:setDefaultEffectDevice()

  if (didChange == true) then
    local notif = hs.notify.new({ title = 'Sound Output Device', subTitle = nextDevice:name(), withdrawAfter = 2}):send()
  end

  hyper.triggered = true
end)
