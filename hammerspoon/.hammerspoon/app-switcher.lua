local hyper = {"cmd", "alt", "ctrl"}
local hyperShift = {"cmd", "alt", "ctrl", "shift"}

local charToApps = {
  -- Top Row: IM + Spotify
  {'u', 'Slack'},
  {'u', 'Messages', 'shift'},
  {'i', 'Messenger'},
  {'i', 'Discord', 'shift'},
  {'o', 'WhatsApp'},
  {'p', 'Spotify'},

  -- Middle Row: Main Apps
  {'h', 'Figma'},
  {'j', 'Google Chrome'},
  {'j', 'Firefox Developer Edition', 'shift'},
  {'k', 'Visual Studio Code'},
  {'l', 'iTerm'},
  --{';', ''},
  
  -- Bottom Row: Email, Calendar and ToDos
  {'v', 'Notion'},
  {'b', 'Asana'},
  {'n', 'Obsidian'},
  {'m', 'Mailplane'},
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