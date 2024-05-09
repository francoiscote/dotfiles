local hyper = { "cmd", "alt", "ctrl" }
local hyperShift = { "cmd", "alt", "ctrl", "shift" }

local charToApps = {
  -- Top Row: IM + Spotify
  { 't', 'Toggl Track' },
  { 'u', 'Slack' },
  { 'u', 'Discord',                   'shift' },
  { 'i', 'Messages' },
  { 'i', 'WhatsApp',                  'shift' },
  { 'o', 'Messenger' },
  { 'p', 'Spotify' },

  -- Middle Row: Main Apps
  { 'h', 'com.culturedcode.ThingsMac' },
  { 'j', 'Google Chrome' },
  { 'j', 'Firefox Developer Edition', 'shift' },
  { 'k', 'Visual Studio Code' },
  { 'l', 'kitty' },
  { ';', 'Figma' },

  -- Bottom Row: Email, Calendar and ToDos
  { 'b', 'Google Meet' },
  { 'b', 'zoom.us',                   'shift' },
  { 'n', 'Obsidian' },
  { 'n', 'Notion',                    'shift' },
  { 'm', 'Mail' },
  { ',', 'Fantastical' },
  { '.', 'Finder' },
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
