-- A global variable for the Hyper Mode
k = hs.hotkey.modal.new({}, "F17")

-- Move Windows
-------------------------------------------------------------------------------
-- Mission Control
k:bind({}, 'up', nil, function() hs.eventtap.keyStroke({"cmd","alt","ctrl"}, 'F13') end)

-- Move to Left Screen
k:bind({}, 'left', nil, function() 
    local win = hs.window.focusedWindow()
    win:moveOneScreenWest(false, true);
end)
-- Move to Right Screen
k:bind({}, 'right', nil, function() 
    local win = hs.window.focusedWindow()
    win:moveOneScreenEast(false, true);
end)


-- Resize Windows
-------------------------------------------------------------------------------
hs.window.animationDuration = 0

-- 0 - Maximize
k:bind({}, '0', nil, function() 
    local win = hs.window.focusedWindow()
    win:maximize()
    k.triggered = true
end)

-- 9 - Browser
k:bind({}, '9', nil, function() 
    local win = hs.window.focusedWindow()
    local f = win:frame()
    local screen = win:screen()
    local max = screen:frame()
    
    f.w = max.w * 0.8
    f.y = max.y
    f.h = max.h
    win:setFrame(f)
    win:centerOnScreen(nil, true)
    k.triggered = true
end)

-- 8 - Email
k:bind({}, '8', nil, function() 
    local win = hs.window.focusedWindow()
    local f = win:frame()
    local screen = win:screen()
    local max = screen:frame()
    
    f.w = max.w * 0.8
    f.h = max.h * 0.8
    win:setFrame(f)
    win:centerOnScreen(nil, true)
    k.triggered = true
end)

-- 7 - Finder
k:bind({}, '7', nil, function() 
    local win = hs.window.focusedWindow()
    local f = win:frame()
    local screen = win:screen()
    local max = screen:frame()
    
    f.w = max.w * 0.6
    f.h = max.h * 0.6
    win:setFrame(f)
    win:centerOnScreen(nil, true)
    k.triggered = true
end)

-- 6 - Right
k:bind({}, '6', nil, function() 
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

-- 5 - Left
k:bind({}, '5', nil, function() 
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


-- Shortcut to reload config
ofun = function()
  hs.reload()
  hs.notify.new({title="Hammerspoon", informativeText="Config Reloaded"}):send()
  k.triggered = true
end
k:bind({}, 'r', nil, ofun)

-- Launch Apps
launch = function(appname)
  hs.application.launchOrFocus(appname)
  k.triggered = true
end

-- Single keybinding for app launch
singleapps = {
  {'u', 'SourceTree'},
  {'j', 'Visual Studio Code'},
  {'n', 'iTerm'},
  {'i', 'FirefoxDeveloperEdition'},
  {'k', 'Google Chrome'},
  {'o', 'Slack'},
  {'l', 'Wavebox'},
  {'.', 'Wunderlist'},
  {'h', 'Finder'},
  {'p', 'Spotify'},
  {';', 'Fantastical 2'}
}

for i, app in ipairs(singleapps) do
  k:bind({}, app[1], function() launch(app[2]); end)
end

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