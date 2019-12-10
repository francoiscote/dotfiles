-- USER VARIABLES
-------------------------------------------------------------------------------
local user = {
  terminal = 'Alacritty',
  browser =   'Google Chrome'
  -- browser = 'Firefox Developer Edition',
  -- browser = 'qutebrowser',
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

-- Resize Windows
-------------------------------------------------------------------------------
hs.window.animationDuration = 0

-- 1 - Work Setup - Code Editor Left
hyper:bind({}, '1', nil, function()
  
  local withoutZoomLayout = {
    {"Google Chrome", nil, nil, hs.layout.left70, nil, nil},
    {"Firefox Developer Edition", nil, nil, hs.layout.left70, nil, nil},
    {"qutebrowser", nil, nil, hs.layout.left70, nil, nil},
    {"Atom", nil, nil, hs.layout.left70, nil, nil},
    {"Code", nil, nil, hs.layout.left70, nil, nil},
    {"iTerm2", nil, nil, hs.layout.right30, nil, nil },
    {"Alacritty", nil, nil, hs.layout.right30, nil, nil }
  }

  local withZoomLayout = {
    {"Google Chrome", nil, nil, hs.layout.left70, nil, nil},
    {"Firefox Developer Edition", nil, nil, hs.layout.left70, nil, nil},
    {"qutebrowser", nil, nil, hs.layout.left70, nil, nil},
    {"Atom", nil, nil, hs.layout.left70, nil, nil},
    {"Code", nil, nil, hs.layout.left70, nil, nil},
    {"zoom.us", nil, nil, {x=0.7, y=0, w=0.3, h=0.5}, nil, nil },
    {"iTerm2", nil, nil, {x=0.7, y=0.5, w=0.3, h=0.5}, nil, nil },
    {"Alacritty", nil, nil, {x=0.7, y=0.5, w=0.3, h=0.5}, nil, nil }
  }
    
  if helpers.isZoomRunning() then
    hs.layout.apply(withZoomLayout)
  else
    hs.layout.apply(withoutZoomLayout)
  end
  hyper.triggered = true
end)

-- Shift+1 - Work Setup - Code Editor Right
hyper:bind({'shift'}, '1', nil, function()
  
  local withoutZoomLayout = {
    {"Google Chrome", nil, nil, hs.layout.right70, nil, nil},
    {"Firefox Developer Edition", nil, nil, hs.layout.right70, nil, nil},
    {"qutebrowser", nil, nil, hs.layout.right70, nil, nil},
    {"Atom", nil, nil, hs.layout.right70, nil, nil},
    {"Code", nil, nil, hs.layout.right70, nil, nil},
    {"iTerm2", nil, nil, hs.layout.left30, nil, nil },
    {"Alacritty", nil, nil, hs.layout.left30, nil, nil }
  }

  local withZoomLayout = {
    {"Google Chrome", nil, nil, hs.layout.right70, nil, nil},
    {"Firefox Developer Edition", nil, nil, hs.layout.right70, nil, nil},
    {"qutebrowser", nil, nil, hs.layout.right70, nil, nil},
    {"Atom", nil, nil, hs.layout.right70, nil, nil},
    {"Code", nil, nil, hs.layout.right70, nil, nil},
    {"zoom.us", nil, nil, {x=0, y=0, w=0.3, h=0.5}, nil, nil },
    {"iTerm2", nil, nil, {x=0, y=0.5, w=0.3, h=0.5}, nil, nil },
    {"Alacritty", nil, nil, {x=0, y=0.5, w=0.3, h=0.5}, nil, nil }
  }
    
  if helpers.isZoomRunning() then
    hs.layout.apply(withZoomLayout)
  else
    hs.layout.apply(withoutZoomLayout)
  end
  hyper.triggered = true
end)


-- 2 - Work Setup - 50/50 split, Editor Left, terminal in the center
hyper:bind({}, '2', nil, function()
  local windowLayout = {
    {"iTerm2", nil, nil, {x=0.2, y=0.1, w=0.6, h=0.8}, nil, nil },
    {"Alacritty", nil, nil, {x=0.2, y=0.1, w=0.6, h=0.8}, nil, nil },
    {"Atom", nil, nil, hs.layout.left50, nil, nil},
    {"Code", nil, nil, hs.layout.left50, nil, nil},
    {"Google Chrome", nil, nil, hs.layout.right50, nil, nil},
    {"Firefox Developer Edition", nil, nil, hs.layout.right50, nil, nil}
  }
  hs.layout.apply(windowLayout, string.find)
  hyper.triggered = true
end)

-- Shift+2 - Work Setup - 50/50 split, Editor Right, terminal in the center
hyper:bind({'shift'}, '2', nil, function()
  local windowLayout = {
    {"iTerm2", nil, nil, {x=0.2, y=0.1, w=0.6, h=0.8}, nil, nil },
    {"Alacritty", nil, nil, {x=0.2, y=0.1, w=0.6, h=0.8}, nil, nil },
    {"Atom", nil, nil, hs.layout.right50, nil, nil},
    {"Code", nil, nil, hs.layout.right50, nil, nil},
    {"Google Chrome", nil, nil, hs.layout.left50, nil, nil},
    {"Firefox Developer Edition", nil, nil, hs.layout.left50, nil, nil}
  }
  hs.layout.apply(windowLayout, string.find)
  hyper.triggered = true
end)

-- 3 - TBD ?
-- Shift+3 - TBD ?

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
    local win = hs.window.focullsedWindow()
    win:maximize()
    hyper.triggered = true
end)

-- 9 - Right
hyper:bind({}, '9', nil, function()
  local win = hs.window.focusedWindow()
  local f = win:frame()
  local screen = win:screen()
  local max = screen:frame()

  f.x = max.x + (max.w / 2)
  f.y = max.y
  f.w = max.w / 2
  f.h = max.h
  win:setFrame(f)
  hyper.triggered = true
end)

-- Shift+9 - Small Right
hyper:bind({"shift"}, '9', nil, function()
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
  hyper.triggered = true
end)

-- 8 - Left
hyper:bind({}, '8', nil, function()
  local win = hs.window.focusedWindow()
  local f = win:frame()
  local screen = win:screen()
  local max = screen:frame()

  f.x = max.x
  f.y = max.y
  f.w = max.w / 2
  f.h = max.h
  win:setFrame(f)
  hyper.triggered = true
end)

-- Shift+8 - Small Left
hyper:bind({"shift"}, '8', nil, function()
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
  hyper.triggered = true
end)

-- 7 - "Browser" Size
hyper:bind({}, '7', nil, function()
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
    hyper.triggered = true
end)

-- 6 - "Email" Size
hyper:bind({}, '6', nil, function()
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
    hyper.triggered = true
end)

-- 5 - "Finder" Size
hyper:bind({}, '5', nil, function()
    local win = hs.window.focusedWindow()
    local f = win:frame()
    local screen = win:screen()
    local max = screen:frame()

    f.h = max.h * 0.6
    f.w = f.h * 1.5
    win:setFrame(f)
    win:centerOnScreen(nil, true)
    hyper.triggered = true
end)

-- Picture in Picture on top right
-------------------------------------------------------------------------------
hyper:bind({}, 'y', nil, function()
  local ppWin = hs.window('Picture in Picture')
  if (ppWin) then
    local screen = ppWin:screen()
    local max = screen:frame()

    ppWin:setFrame({x=max.w-1032, y=max.y, w=1032, h=580})
  end

  local termWin = hs.application('iTerm2'):mainWindow()
  if (termWin) then
    local screen = termWin:screen()
    local max = screen:frame()

    termWin:setFrame({x=max.w-1032, y=603, w=1032, h=837})
  end
  hyper.triggered = true
end)

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
  {'i', 'Franz'},
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
  {'n', 'Mailplane'},
  {'m', 'Fantastical 2'},
  {',', 'Notion'},
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

-- Swap between Audio Outputs (Built in and Yeti Stereo Microphoneb)
-------------------------------------------------------------------------------
hyper:bind({}, 's', nil, function()
  local currentDeviceName = hs.audiodevice.current().name
  local nextDevice
  if string.find(currentDeviceName, 'Vanatoo T0') then
    nextDevice = hs.audiodevice.findDeviceByName('Elgato Dock')
    if (nextDevice == nil) then
      nextDevice = hs.audiodevice.findDeviceByName('MacBook Pro Speakers')
    end
  else
    nextDevice = hs.audiodevice.findDeviceByName('Vanatoo T0')
  end
  nextDevice:setDefaultOutputDevice()
  hyper.triggered = true
end)
