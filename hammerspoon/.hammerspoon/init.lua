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
local largeMargins = helpers.getDynamicMargins(0.02, 0.04)
local extraLargeMargins = helpers.getDynamicMargins(0.03, 0.07)

local mygrid = hs.grid.setGrid('10x10', mainScreen, frame).setMargins(defaultMargins)

hyper:bind({}, 'g', nil, function()
  mygrid.toggleShow()
  hyper.triggered = true
end)

-- Window Managements
-------------------------------------------------------------------------------
hs.window.animationDuration = 0
hs.window.setShadows(false)
local wf=hs.window.filter


-- Windows Filters
-- Single Apps
w_chrome = wf.new{'Google Chrome'}
w_firefox = wf.new{'Firefox Developer Edition'}
w_obs = wf.new{'OBS'}
w_figma = wf.new{'Figma'}

-- Groups of Apps
w_browsers = wf.new{['Firefox Developer Edition'] = true, ['Google Chrome'] = { rejectTitles = 'Picture in Picture' } }
w_editors = wf.new{'Code'}
w_terminals = wf.new{'iTerm2', 'Alacritty'}
w_videos = wf.new{['Google Meet'] = true, ['zoom.us'] = true, ['Google Chrome'] = {allowTitles = 'Picture in Picture'}}
w_notes = wf.new{'Notion'}
w_chats = wf.new{'Slack', 'Ferdi', 'Discord', 'Messages'}:setCurrentSpace(true)


local seventySplitCells = {
  center = '2,1 6x8',
  leftMain = '0,0 7x10',
  leftSecondaryFull = '0,0 3x10',
  leftSecondaryTop = '0,0 3x3',
  leftSecondaryBottom = '0,3 3x7',
  rightMain = '3,0 7x10',
  rightSecondaryFull = '7,0 3x10',
  rightSecondaryTop = '7,0 3x3',
  rightSecondaryBottom = '7,3 3x7',
}

-- q - Work Setup - MAIN: Browser/Code Maximized, SECONDARY: Terminal and Notes centered
hyper:bind({}, 'tab', nil, function()  -- Different layout depending if we have Video windows or not
  helpers.maximiseAll(w_browsers)
  helpers.maximiseAll(w_editors)
  helpers.maximiseAll(w_figma)
  helpers.setWindowsToCell(w_terminals, mygrid, seventySplitCells.center)
  helpers.setWindowsToCell(w_notes, mygrid, seventySplitCells.center)
  helpers.setWindowsToCell(w_chats, mygrid, seventySplitCells.center)

  hyper.triggered = true
end)

-- q - Work Setup - MAIN: Browser/Code/Figma, SECONDARY: Terminal, Notes and Chats
function setupQ()
  helpers.setWindowsToCell(w_browsers, mygrid, seventySplitCells.rightMain)
  helpers.setWindowsToCell(w_editors, mygrid, seventySplitCells.rightMain)
  helpers.setWindowsToCell(w_figma, mygrid, seventySplitCells.rightMain)
  
  if #w_videos:getWindows() > 0 then
    helpers.setWindowsToCell(w_videos, mygrid, seventySplitCells.leftSecondaryTop)
    helpers.setWindowsToCell(w_terminals, mygrid, seventySplitCells.leftSecondaryBottom)
    helpers.setWindowsToCell(w_notes, mygrid, seventySplitCells.leftSecondaryBottom)
    helpers.setWindowsToCell(w_chats, mygrid, seventySplitCells.leftSecondaryBottom)
  else 
    helpers.setWindowsToCell(w_terminals, mygrid, seventySplitCells.leftSecondaryFull)
    helpers.setWindowsToCell(w_notes, mygrid, seventySplitCells.leftSecondaryFull)
    helpers.setWindowsToCell(w_chats, mygrid, seventySplitCells.leftSecondaryFull)
  end
end

hyper:bind({}, 'q', nil, function()
  setupQ()
  hyper.triggered = true
end)

-- Shift+q - Work Setup - Same as q, but with large margins
hyper:bind({'shift'}, 'q', nil, function()
  mygrid.setMargins(largeMargins)
  setupQ()
  mygrid.setMargins(defaultMargins)
  hyper.triggered = true
end)

local sixtySplitCells = {
  leftMain = '0,0 6x10',
  leftSecondaryFull = '0,0 4x10',
  leftSecondaryTop = '0,0 4x4',
  leftSecondaryBottom = '0,4 4x6',
  rightMain = '4,0 6x10',
  rightSecondaryFull = '6,0 4x10',
  rightSecondaryTop = '6,0 4x4',
  rightSecondaryBottom = '6,4 4x6',
}

-- w - Work Setup - MAIN: Code, SECONDARY: everything else
function setupW()
  -- RIGHT
  helpers.setWindowsToCell(w_editors, mygrid, sixtySplitCells.rightMain)
  
  if #w_videos:getWindows() > 0 then
    -- LEFT
    helpers.setWindowsToCell(w_browsers, mygrid, sixtySplitCells.leftSecondaryBottom)
    helpers.setWindowsToCell(w_terminals, mygrid, sixtySplitCells.leftSecondaryBottom)
    helpers.setWindowsToCell(w_notes, mygrid, sixtySplitCells.leftSecondaryBottom)
    helpers.setWindowsToCell(w_chats, mygrid, sixtySplitCells.leftSecondaryBottom)
    helpers.setWindowsToCell(w_figma, mygrid, sixtySplitCells.leftSecondaryBottom)
    helpers.setWindowsToCell(w_videos, mygrid, sixtySplitCells.leftSecondaryTop)
  else 
    -- LEFT
    helpers.setWindowsToCell(w_figma, mygrid, sixtySplitCells.leftSecondaryFull)
    helpers.setWindowsToCell(w_browsers, mygrid, sixtySplitCells.leftSecondaryFull)
    helpers.setWindowsToCell(w_terminals, mygrid, sixtySplitCells.leftSecondaryFull)
    helpers.setWindowsToCell(w_notes, mygrid, sixtySplitCells.leftSecondaryFull)
    helpers.setWindowsToCell(w_chats, mygrid, sixtySplitCells.leftSecondaryFull)
  end
end

-- Defaults to small margins, because Code is the main window and I need the max amount of space
hyper:bind({}, 'w', nil, function()
  setupW()
  hyper.triggered = true
end)

-- w - Work Setup - above with large margins
hyper:bind({'shift'}, 'w', nil, function()
  mygrid.setMargins(largeMargins)
  setupW()
  mygrid.setMargins(defaultMargins)

  hyper.triggered = true
end)

-- e - Work Setup - MAIN: BROWSER, SECONDARY: everything else
function setupE()
  --RIGHT
  helpers.setWindowsToCell(w_browsers, mygrid, sixtySplitCells.rightMain)
  
  if #w_videos:getWindows() > 0 then
    -- LEFT
    helpers.setWindowsToCell(w_terminals, mygrid, sixtySplitCells.leftSecondaryBottom)
    helpers.setWindowsToCell(w_notes, mygrid, sixtySplitCells.leftSecondaryBottom)
    helpers.setWindowsToCell(w_chats, mygrid, sixtySplitCells.leftSecondaryBottom)
    helpers.setWindowsToCell(w_editors, mygrid, sixtySplitCells.leftSecondaryBottom)
    helpers.setWindowsToCell(w_figma, mygrid, sixtySplitCells.leftSecondaryBottom)
    helpers.setWindowsToCell(w_videos, mygrid, sixtySplitCells.leftSecondaryTop)
  else
    -- LEFT
    helpers.setWindowsToCell(w_figma, mygrid, sixtySplitCells.leftSecondaryFull)
    helpers.setWindowsToCell(w_terminals, mygrid, sixtySplitCells.leftSecondaryFull)
    helpers.setWindowsToCell(w_editors, mygrid, sixtySplitCells.leftSecondaryFull)
    helpers.setWindowsToCell(w_notes, mygrid, sixtySplitCells.leftSecondaryFull)
    helpers.setWindowsToCell(w_chats, mygrid, sixtySplitCells.leftSecondaryFull)
  end

end

-- Default to large margins, because browser is the main window
hyper:bind({}, 'e', nil, function()
  mygrid.setMargins(largeMargins)
  setupE()
  mygrid.setMargins(defaultMargins)
  hyper.triggered = true
end)

-- Shift+e - Work Setup - above with regular margins
hyper:bind({'shift'}, 'e', nil, function()
  setupE()

  hyper.triggered = true
end)

local evenSplitCells = {
  leftFull = '0,0 5x10',
  leftTop = '0,0 5x5',
  leftBottom = '0,5 5x5',
  rightFull = '5,0 5x10',
  rightTop = '5,0 5x5',
  rightBottom = '5,5 5x5',
  center = '2,1 6x8'
}


-- Hyper+r - Even split. Code and Browser on the right, everything else on the left
function setupR()
  -- LEFT
  if #w_videos:getWindows() > 0 then
  helpers.setWindowsToCell(w_videos, mygrid, evenSplitCells.leftTop)
  helpers.setWindowsToCell(w_terminals, mygrid, evenSplitCells.leftBottom)
  helpers.setWindowsToCell(w_notes, mygrid, evenSplitCells.leftBottom)
  helpers.setWindowsToCell(w_figma, mygrid, evenSplitCells.leftBottom)
  helpers.setWindowsToCell(w_chats, mygrid, evenSplitCells.leftBottom)
  else 
  helpers.setWindowsToCell(w_terminals, mygrid, evenSplitCells.leftFull)
  helpers.setWindowsToCell(w_notes, mygrid, evenSplitCells.leftFull)
  helpers.setWindowsToCell(w_figma, mygrid, evenSplitCells.leftFull)
  helpers.setWindowsToCell(w_chats, mygrid, evenSplitCells.leftFull)
  end
  
  -- RIGHT
  helpers.setWindowsToCell(w_browsers, mygrid, evenSplitCells.rightFull)
  helpers.setWindowsToCell(w_editors, mygrid, evenSplitCells.rightFull)
end

hyper:bind({}, 'r', nil, function()
  mygrid.setMargins(largeMargins)
  setupR()
  mygrid.setMargins(defaultMargins)
  hyper.triggered = true
end)

-- Hyper+Shift+r
hyper:bind({'shift'}, 'r', nil, function()
  setupR()
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
  mygrid.setMargins(extraLargeMargins)
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
  mygrid.setMargins(extraLargeMargins)
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
  mygrid.setMargins(extraLargeMargins)
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
  mygrid.setMargins(extraLargeMargins)
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
  mygrid.setMargins(extraLargeMargins)
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
  mygrid.setMargins(extraLargeMargins)
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
-----------------------------------------------------------E--------------------
-- C - Center
hyper:bind({}, 'c', nil, function()
    local win = hs.window.focusedWindow()
    win:centerOnScreen(nil, true)
    hyper.triggered = true
end)

-- Hyper+equal - Hide everything else and Center
hyper:bind({}, '-', nil, function()
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
  -- {'b', 'com.culturedcode.ThingsMac'},
  --{'b', 'TickTick'},
  {'n', 'Notion'},
  {'m', user.mailclient},
  {',', user.calendar,},
  {'.', 'Finder'},
}

for i, app in ipairs(singleapps) do
  hyper:bind({}, app[1], function()
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
