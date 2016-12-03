-- A global variable for the Hyper Mode
k = hs.hotkey.modal.new({}, "F17")

-- Trigger existing hyper key shortcuts
k:bind({}, 'up', nil, function() hs.eventtap.keyStroke({"cmd","alt","ctrl"}, 'up') end)
k:bind({}, 'left', nil, function() hs.eventtap.keyStroke({"cmd","alt","ctrl"}, 'left') end)
k:bind({}, 'right', nil, function() hs.eventtap.keyStroke({"cmd","alt","ctrl"}, 'right') end)
k:bind({}, '5', nil, function() hs.eventtap.keyStroke({"cmd","alt","ctrl"}, '5') end)
k:bind({}, '6', nil, function() hs.eventtap.keyStroke({"cmd","alt","ctrl"}, '6') end)
k:bind({}, '7', nil, function() hs.eventtap.keyStroke({"cmd","alt","ctrl"}, '7') end)
k:bind({}, '8', nil, function() hs.eventtap.keyStroke({"cmd","alt","ctrl"}, '8') end)
k:bind({}, '9', nil, function() hs.eventtap.keyStroke({"cmd","alt","ctrl"}, '9') end)
k:bind({}, '0', nil, function() hs.eventtap.keyStroke({"cmd","alt","ctrl"}, '0') end)

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
  {'j', 'Atom Beta'},
  {'n', 'iTerm'},
  {'i', 'FirefoxDeveloperEdition'},
  {'k', 'Google Chrome'},
  {'o', 'Slack'},
  {'l', 'Wmail'},
  {'.', 'Wunderlist'},
  {'h', 'Finder'},
  {'p', 'Spotify'},
  {';', 'Fantastical 2'}
}

for i, app in ipairs(singleapps) do
  k:bind({}, app[1], function() launch(app[2]); k:exit(); end)
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