local hyper = {"cmd", "alt", "ctrl"}
local hyperShift = {"cmd", "alt", "ctrl", "shift"}

local charToApps = {
  -- Top Row: IM + Spotify
  {'u', 'Slack'},
  {'u', 'Messenger', 'shift'},
  {'i', 'WhatsApp'},
  {'i', 'Messages', 'shift'},
  {'o', 'Discord'},
  {'p', 'Spotify'},

  -- Middle Row: Main Apps
  {'h', 'Figma'},
  {'j', 'Google Chrome'},
  {'k', 'Visual Studio Code'},
  {'l', 'iTerm'},
  {';', 'Firefox Developer Edition'},
  
  -- Bottom Row: Email, Calendar and ToDos
  {'b', 'Google Meet'},
  {'b', 'zoom.us', 'shift'},
  {'n', 'Notion'},
  {'n', 'Things3', 'shift'},
  {'m', 'Mimestream'},
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