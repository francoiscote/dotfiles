-- A global variable for the Hyper Mode
k = hs.hotkey.modal.new({}, "F17")
log = hs.logger.new('WM','debug')

-- Tools
-------------------------------------------------------------------------------
-- Inspect Focused Window
k:bind({"shift"}, 'i', nil, function()
  local win = hs.window.focusedWindow()
  log.d("Size", win:size())
  log.d("Frame", win:frame())
end)

-- Move Windows
-------------------------------------------------------------------------------
-- Mission Control
k:bind({}, 'up', nil, function()
  hs.eventtap.keyStroke({"cmd","alt","ctrl"}, '0')
end)

-- Go To Previous Space
k:bind({}, 'left', nil, function()
  hs.eventtap.keyStroke({"ctrl"}, 'left')
end)

-- Go To Next Space
k:bind({}, 'right', nil, function()
  hs.eventtap.keyStroke({"ctrl"}, 'right')
end)

-- Resize Windows
-------------------------------------------------------------------------------
hs.window.animationDuration = 0

-- 1 - Work Setup - Main Editor Left
k:bind({}, '1', nil, function()
  local windowLayout = {
    {"Google Chrome", nil, nil, {x=0, y=0, w=0.7, h=1}, nil, nil},
    {"Atom", nil, nil, {x=0, y=0, w=0.7, h=1}, nil, nil},
    {"Code", nil, nil, {x=0, y=0, w=0.7, h=1}, nil, nil},
    {"iTerm2", nil, nil, {x=0.7, y=0, w=0.3, h=1}, nil, nil }
	}
  hs.layout.apply(windowLayout)
end)

-- 2 - Work Setup - 50/50 split, terminal in the center
k:bind({}, '2', nil, function()
  local windowLayout = {
    {"iTerm2", nil, nil, {x=0.2, y=0.1, w=0.6, h=0.8}, nil, nil },
    {"Google Chrome", nil, nil, {x=0, y=0, w=0.5, h=1}, nil, nil},
    {"Atom", nil, nil, {x=0.5, y=0, w=0.5, h=1}, nil, nil},
    {"Code", nil, nil, {x=0.5, y=0, w=0.5, h=1}, nil, nil}
  }
  hs.layout.apply(windowLayout, string.find)
end)

-- 3 - Work Setup - 1/3 split, Browser + Editor + Terminal
k:bind({}, '3', nil, function()
  local windowLayout = {
    {"Google Chrome", nil, nil, {x=0, y=0, w=0.4, h=1}, nil, nil},
    {"Atom", nil, nil, {x=0.4, y=0, w=0.4, h=1}, nil, nil},
    {"Code", nil, nil1, {x=0.4, y=0, w=0.4, h=1}, nil, nil},
    {"iTerm2", nil, nil, {x=0.8, y=0, w=0.2, h=1}, nil, nil }
  }
  hs.layout.apply(windowLayout, string.find)
end)

-- 4 - Twitch Setup
k:bind({}, '4', nil, function()
  local windowLayout = {
	    {"Google Chrome", "Twitch", nil, nil, {x=0, y=0, w=914, h=615}, nil},
      {"OBS", nil, nil, nil, {x=0, y=637, w=914, h=803}, nil},
      {"Atom", nil, nil, nil, {x=915, y=0, w=1724, h=1418}, nil},
      {"Code", nil, nil, nil, {x=915, y=0, w=1724, h=1418}, nil},
      {"Google Chrome", "francoiscote", nil, nil, {x=915, y=0, w=1724, h=1418}, nil},
	    {"iTerm2", nil, nil, nil, {x=2640, y=0, w=800, h=962}, nil},
      {"Google Chrome", "Alert Box Widget", nil, nil, {x=2640, y=985, w=800, h=455}, nil},
	}
    hs.layout.apply(windowLayout, string.find)
end)

-- 0 - Maximize
k:bind({}, '0', nil, function()
    local win = hs.window.focusedWindow()
    win:maximize()
    k.triggered = true
end)

-- 9 - Right
k:bind({}, '9', nil, function()
  local win = hs.window.focusedWindow()
  local f = win:frame()
  local screen = win:screen()
  local max = screen:frame()

  f.x = max.x + (max.w / 2)
  f.y = max.y
  f.w = max.w / 2
  f.h = max.h
  win:setFrame(f)
  k.triggered = true
end)

-- Shift+9 - Small Right
k:bind({"shift"}, '9', nil, function()
  local win = hs.window.focusedWindow()
  local f = win:frame()
  local screen = win:screen()
  local max = screen:frame()
  local vPad = 0.07
  local hPad = 0.02

  f.x = (max.w / 2) + (hPad / 2 * max.w)
  f.y = max.y + (max.h * vPad)
  f.w = max.w * (1 - (hPad * 3)) / 2
  f.h = max.h * (1 - (vPad * 2))
  win:setFrame(f)
  k.triggered = true
end)

-- 8 - Left
k:bind({}, '8', nil, function()
  local win = hs.window.focusedWindow()
  local f = win:frame()
  local screen = win:screen()
  local max = screen:frame()

  f.x = max.x
  f.y = max.y
  f.w = max.w / 2
  f.h = max.h
  win:setFrame(f)
  k.triggered = true
end)

-- Shift+8 - Small Left
k:bind({"shift"}, '8', nil, function()
  local win = hs.window.focusedWindow()
  local f = win:frame()
  local screen = win:screen()
  local max = screen:frame()
  local vPad = 0.07
  local hPad = 0.02

  f.x = (hPad * max.w)
  f.y = max.y + (max.h * vPad)
  f.w = max.w * (1 - (hPad * 3)) / 2
  f.h = max.h * (1 - (vPad * 2))
  win:setFrame(f)
  k.triggered = true
end)

-- 7 - "Browser" Size
k:bind({}, '7', nil, function()
    local win = hs.window.focusedWindow()
    local f = win:frame()
    local screen = win:screen()
    local max = screen:frame()
    local screenratio = max.w / max.h
    local widthratio = 1

    if screenratio > 2 then
      widthratio = 0.5
    else
      widthratio = 0.8
    end

    f.w = max.w * widthratio
    f.y = max.y
    f.h = max.h
    win:setFrame(f)
    win:centerOnScreen(nil, true)
    k.triggered = true
end)

-- 6 - "Email" Size
k:bind({}, '6', nil, function()
    local win = hs.window.focusedWindow()
    local f = win:frame()
    local screen = win:screen()
    local max = screen:frame()
    local screenratio = max.w / max.h
    local widthratio = 1

    if screenratio > 2 then
      widthratio = 0.6
    else
      widthratio = 0.8
    end

    f.w = max.w * widthratio
    f.h = max.h * 0.8
    win:setFrame(f)
    win:centerOnScreen(nil, true)
    k.triggered = true
end)

-- 5 - "Finder" Size
k:bind({}, '5', nil, function()
    local win = hs.window.focusedWindow()
    local f = win:frame()
    local screen = win:screen()
    local max = screen:frame()

    f.h = max.h * 0.6
    f.w = f.h * 1.5
    win:setFrame(f)
    win:centerOnScreen(nil, true)
    k.triggered = true
end)

-- Shortcut to reload config
-------------------------------------------------------------------------------
reload = function()
  hs.reload()
  hs.notify.new({title="Hammerspoon", informativeText="Config Reloaded"}):send()
  k.triggered = true
end
k:bind({}, 'r', nil, reload)

-- Launch Apps
-------------------------------------------------------------------------------
launch = function(appname)
  hs.application.launchOrFocus(appname)
  k.triggered = true
end

-- Single keybinding for app launch
-------------------------------------------------------------------------------
singleapps = {
  -- Top Row: IM + Spotify
  {'u', 'Slack'},
  {'i', 'Discord'},
  {'o', 'Messages'},
  {'p', 'Spotify'},

  -- Middle Row: Dev Tools
  -- Dev Trifecta (Browser + Editor + Terminal) and SourceTree
  {'j', 'Google Chrome'},
  {'k', 'Visual Studio Code'},
  {'l', 'iTerm'},
  {';', 'Sourcetree'},

  -- Bottom Row: Email, Calendar and ToDos
  {'n', 'Boxy'},
  {'m', 'Fantastical 2'},
  {',', 'Wunderlist'},
  {'.', 'Finder'}
}

for i, app in ipairs(singleapps) do
  k:bind({}, app[1], function() launch(app[2]); end)
end

-- Swap between Audio Outputs (Built in and Yeti Stereo Microphoneb)
-------------------------------------------------------------------------------
k:bind({}, 's', nil, function()
  local currentDeviceName = hs.audiodevice.current().name
  local nextDevice
  if string.find(currentDeviceName, 'Yeti') then
    nextDevice = hs.audiodevice.findDeviceByName('Elgato Dock')
    if (nextDevice == nil) then
      nextDevice = hs.audiodevice.findDeviceByName('MacBook Pro Speakers')
    end
  else
    nextDevice = hs.audiodevice.findDeviceByName('Yeti Stereo Microphone')
  end
  nextDevice:setDefaultOutputDevice()
end)

-- Enter Hyper Mode when F18 (Hyper/Capslock) is pressed
pressedF18 = function()
  k.triggered = false
  k:enter()
end

-- Leave Hyper Mode when F18 (Hyper/Capslock) is pressed,
--   send ESCAPE if no other keys are pressed.
releasedF18 = function()
  k:exit()
  if not k.triggered then
    hs.eventtap.keyStroke({}, 'ESCAPE')
  end
end

-- Bind the Hyper key
f18 = hs.hotkey.bind({}, 'F18', pressedF18, releasedF18)
