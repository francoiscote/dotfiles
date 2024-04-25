local hyper = {"cmd", "alt", "ctrl"}
local hyperShift = {"cmd", "alt", "ctrl", "shift"}

local charToApps = {
  -- Top Row: IM + Spotify
  {'t', 'Toggl Track', 'shift'},
  {'u', 'Slack'},
  {'i', 'Messages'},
  {'i', 'WhatsApp', 'shift'},
  {'o', 'Messenger'},
  {'o', 'Discord', 'shift'},
  {'p', 'Spotify'},

  -- Middle Row: Main Apps
  {'h', 'com.culturedcode.ThingsMac'},
  {'j', 'Google Chrome'},
  {'j', 'Safari', 'shift'},
  {'k', 'Visual Studio Code'},
  {'l', 'iTerm'},
  {';', 'Figma'},
  
  -- Bottom Row: Email, Calendar and ToDos
  {'b', 'Google Meet'},
  {'b', 'zoom.us', 'shift'},
  {'n', 'Obsidian'},
  {'n', 'Notion', 'shift'},
  {'m', 'Mail'},
  {',', 'Fantastical'},
  {'.', 'Finder'},
}

for i, app in ipairs(charToApps) do
  local hyperKey = app[3] == 'shift' and hyperShift or hyper
  hs.hotkey.bind(hyperKey, app[1], function()
      if (hs.application.launchOrFocus(app[2])) then
        hyperKey.triggered = true
      elseif (hs.application.launchOrFocusByBundleID(app[2])) then
        hyperKey.triggered = true
      end
    end
  )
end