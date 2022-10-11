local hyper = {"cmd", "alt", "ctrl"}

local charToApps = {
  -- Top Row: IM + Spotify
  {'y', 'Messages'},
  {'u', 'Slack'},
  {'i', 'Ferdi'},
  {'o', 'Discord'},
  {'p', 'Spotify'},

  -- Middle Row: Main Apps
  {'h', 'Figma'},
  {'j', 'Google Chrome'},
  {'k', 'Visual Studio Code'},
  {'l', 'iTerm'},
  {';', 'Firefox Developer Edition'},
  
  -- Bottom Row: Email, Calendar and ToDos
  {'v', 'Notion'},
  {'b', 'Asana'},
  {'n', 'Obsidian'},
  {'m', 'Mimestream'},
  {',', 'Fantastical'},
  {'.', 'Finder'},
}

for i, app in ipairs(charToApps) do
  hs.hotkey.bind(hyper, app[1], function()
      if (hs.application.launchOrFocus(app[2])) then
        hyper.triggered = true
      elseif (hs.application.launchOrFocusByBundleID(app[2])) then
        hyper.triggered = true
      end
    end
  )
end